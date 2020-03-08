% Run this script first


VehicleData; % Read Vehicle data from VehicleData.m


global s     % [m]     track width
global s0    % [m]     Length between steering pivot points
global wb    % [m]     Wheelbase
global MinAeroVel % [km/hr] Minimum velocity at which Active aerodynamics should start
global weightPropF % proportion of weight of front of car to total weight
global weightPropR % proportion of weight of front of car to total weight
global TurnRight

TurnRight = false;


% CorrectionFactor = 10;

% Input Variables here. These will be live inputs in the SIMULINK Model
SteeringAngle =0 ;
Accelerator = true;

if SteeringAngle< 0
    TurnRight = true;
    SteeringAngle = -SteeringAngle;
end

VehicleVelocityKmhr = 100; % km/hr 

Brake = 0; % value between 0 and 1


VehicleVelocity = VehicleVelocityKmhr/3.6; % convert to m/s
% Calculations for Turning Radius
SteeringAngleRad = deg2rad(SteeringAngle);
TurningRad = (wb/sin(SteeringAngleRad/10) - (s-s0)/2);

% Calcuation of Lateral Acceleration from Velocity and Turning Radius
ay = VehicleVelocity^2/TurningRad;

% Calculation of Wheel loads when vehicle is travelling straight
[Fz01,Fz02,rollangle0] = getRollReactions(0);

% Calculation of Wheel loads when vehicle turns at TurningRad
[Fz1,Fz2,rollangle] = getRollReactions(ay);

% Display straight loads
disp(' ');
disp('Straight loads')
disp(['The outer wheel load is ',num2str(Fz01)])
disp(['The inner wheel load is ',num2str(Fz02)])
disp(['The roll angle is ',num2str(rollangle0)])

% Display turning loads
disp(' ');
disp('Turning loads')
disp(['The outer wheel load is ',num2str(Fz1)])
disp(['The inner wheel load is ',num2str(Fz2)])
disp(['The roll angle is ',num2str(rollangle)])

% To be done, create a vehicle overturn alert in the application. Could add
% later in the file after aerodynamic effect
if Fz2<0
    disp('Vehicle Overturns')
end

% Difference between the outer wheel forces when
deltaFz1 = Fz1 - Fz01;
deltaFz1F = deltaFz1* weightPropF;
deltaFz1R = deltaFz1* weightPropR;

disp(['The required delta F is ' num2str(deltaFz1)])

% Find out the optimal aerodynamic force for each wing

% Input Aerodynamic Data (variation of coeffs of lift and drag, frontal
% areas with angle)
% InputAeroDataF;
AeroDataInputF = xlsread('FrontWingDatasheet.xlsx','A2:D29');
AeroDataInputR = xlsread('RearWingDatasheet.xlsx','A2:D29');


%Generate Front and Rear Wing Data
GenerateFrontWingData;
GenerateRearWingData;


%Brake Light Control
BrakeLight = false;

if Brake ~= 0
    BrakeLight = true;
end

WingAngleFrontInner = 0;
WingAngleFrontOuter = 0;
WingAngleRearInner = 0;
WingAngleRearOuter = 0;

VelocityIndex = abs(round(VehicleVelocityKmhr - MinAeroVel));

if VelocityIndex == 0
    VelocityIndex = 1;
end


if Brake >= 0.65
    % push all wings to max position 
    % finding out the maximum drag position
    [WingDragFrontInner,WingAngleFrontInner] = max(DragDataF(:,VelocityIndex));
    [WingDragFrontOuter,WingAngleFrontOuter] = max(DragDataF(:,VelocityIndex));
    [WingDragRearInner,WingAngleRearInner] = max(DragDataR(:,VelocityIndex));
    [WingDragRearOuter,WingAngleRearOuter] = max(DragDataR(:,VelocityIndex));
    
    % The following is added as we have collected data for angles of attack
    % from -7 to 20 degrees
    WingAngleFrontInner = WingAngleFrontInner - 8;
    WingAngleFrontOuter = WingAngleFrontOuter - 8;
    WingAngleRearInner = WingAngleRearInner - 8;
    WingAngleRearOuter = WingAngleRearOuter - 8;
    
    % calcutating total extra drag
    TotalExtraDrag = WingDragFrontInner + WingDragFrontOuter + WingDragRearInner + WingDragRearOuter;
    
    % displaying results
    disp(' ');
    disp(['The angle of the Front Inner wing is at ' num2str(WingAngleFrontInner) ' and produces ' ...
        num2str(WingDragFrontInner) 'N of additional drag'])
    disp(['The angle of the Front Outer wing is at ' num2str(WingAngleFrontOuter) ' and produces ' ...
        num2str(WingDragFrontOuter) 'N of additional drag'])
    disp(['The angle of the Rear Inner wing is at ' num2str(WingAngleRearInner) ' and produces ' ...
        num2str(WingDragRearInner) 'N of additional drag'])
    disp(['The angle of the Rear Outer wing is at ' num2str(WingAngleRearOuter) ' and produces ' ...
        num2str(WingDragRearOuter) 'N of additional drag'])
        
      disp(' ');
      disp(['The Total Additional Drag Force produced is ' num2str(TotalExtraDrag) 'N'])
    
    
elseif Brake < 0.65

    LiftMaxF = max(LiftDataF(:,VelocityIndex));
    LiftMaxR = max(LiftDataR(:,VelocityIndex));
    
    % For Front
    if deltaFz1F >= LiftMaxF 
        % angle of attack of inner is at max lift postion and lift angle of
        % inner is at min lift position
        [WingLiftFrontInner,WingAngleFrontInner] = max(LiftDataF(:,VelocityIndex));
        [WingLiftFrontOuter,WingAngleFrontOuter] = min(LiftDataF(:,VelocityIndex));
        
    elseif deltaFz1F < LiftMaxF && deltaFz1F ~= 0 && Accelerator == false
        % attack angle of inner is at max and outer is a function of velocity
        [WingLiftFrontInner,WingAngleFrontInner] = max(LiftDataF(:,VelocityIndex));
        
        % Finding out the required value of Lift on the outer wing
        WingLiftFrontOuterReqd = WingLiftFrontInner - deltaFz1F;
        
        % Finding the closest wing angle to that value
        [~,WingAngleFrontOuter] = min(abs(LiftDataF(:,VelocityIndex) - WingLiftFrontOuterReqd ));
        WingLiftFrontOuter = LiftDataF(WingAngleFrontOuter,VelocityIndex);
        
                
    elseif deltaFz1F < LiftMaxF && deltaFz1F ~= 0 && Accelerator == true
        % attack angle of outer is at min and inner is a function of velocity
        [WingLiftFrontOuter,WingAngleFrontOuter] = min(LiftDataF(:,VelocityIndex));
        
        % Finding out the required value of Lift on the inner wing
        WingLiftFrontInnerReqd = WingLiftFrontOuter + deltaFz1F;
        
        % Finding the closest wing angle to that value
        [~,WingAngleFrontInner] = min(abs(LiftDataF(:,VelocityIndex) - WingLiftFrontInnerReqd ));
        WingLiftFrontInner = LiftDataF(WingAngleFrontInner,VelocityIndex);
        
    elseif deltaFz1F == 0
        % all wings are at minimum drag positions
        [WingLiftFrontInner,WingAngleFrontInner] = min(LiftDataF(:,VelocityIndex));
        [WingLiftFrontOuter,WingAngleFrontOuter] = min(LiftDataF(:,VelocityIndex));
    end
    
    % For Rear
    if deltaFz1R >= LiftMaxR 
        % angle of attack of inner is at max lift postion and lift angle of
        % inner is at min lift position
        [WingLiftRearInner,WingAngleRearInner] = max(LiftDataR(:,VelocityIndex));
        [WingLiftRearOuter,WingAngleRearOuter] = min(LiftDataR(:,VelocityIndex));
        
                
    elseif deltaFz1R < LiftMaxR && deltaFz1R ~= 0 && Accelerator == false
        % attack angle of inner is at max and outer is a function of velocity
        [WingLiftRearInner,WingAngleRearInner] = max(LiftDataR(:,VelocityIndex));
        
        % Finding out the required value of Lift on the outer wing
        WingLiftRearOuterReqd = WingLiftRearInner - deltaFz1R;
        
        % Finding the closest wing angle to that value
        [~,WingAngleRearOuter] = min(abs(LiftDataR(:,VelocityIndex) - WingLiftRearOuterReqd ));
        WingLiftRearOuter = LiftDataR(WingAngleRearOuter,VelocityIndex);
        
                
    elseif deltaFz1R < LiftMaxR && deltaFz1R ~= 0 && Accelerator == true
        % attack angle of outer is at min and inner is a function of velocity
        [WingLiftRearOuter,WingAngleRearOuter] = min(LiftDataR(:,VelocityIndex));
        
        % Finding out the required value of Lift on the inner wing
        WingLiftRearInnerReqd = WingLiftRearOuter + deltaFz1R;
        
        % Finding the closest wing angle to that value
        [~,WingAngleRearInner] = min(abs(LiftDataR(:,VelocityIndex) - WingLiftRearInnerReqd ));
        WingLiftRearInner = LiftDataR(WingAngleRearInner,VelocityIndex);
        
    elseif deltaFz1R == 0
        % all wings are at minimum drag positions
        [WingLiftRearInner,WingAngleRearInner] = min(LiftDataR(:,VelocityIndex));
        [WingLiftRearOuter,WingAngleRearOuter] = min(LiftDataR(:,VelocityIndex));
    end
    
    % Correction of Angles
    WingAngleFrontInner = WingAngleFrontInner - 8;
    WingAngleFrontOuter = WingAngleFrontOuter - 8;
    WingAngleRearInner = WingAngleRearInner - 8;
    WingAngleRearOuter = WingAngleRearOuter - 8;
    
    
    %Print Results
    
    % calcutating total extra drag
    TotalExtraLift = (WingLiftFrontInner - WingLiftFrontOuter) + (WingLiftRearInner - WingLiftRearOuter);
    
    % displaying results
    disp(' ');
    disp(['The angle of the Front Inner wing is at ' num2str(WingAngleFrontInner) ' degrees and produces ' ...
        num2str(WingLiftFrontInner) ' N of additional lift(downforce)'])
    disp(['The angle of the Front Outer wing is at ' num2str(WingAngleFrontOuter) ' degrees and produces ' ...
        num2str(WingLiftFrontOuter) ' N of additional lift(downforce)'])
    disp(['The angle of the Rear Inner wing is at ' num2str(WingAngleRearInner) ' degrees and produces ' ...
        num2str(WingLiftRearInner) ' N of additional lift(downforce)'])
    disp(['The angle of the Rear Outer wing is at ' num2str(WingAngleRearOuter) ' degrees and produces ' ...
        num2str(WingLiftRearOuter) ' N of additional lift(downforce)'])
        
      disp(' ')
      disp(['The Total Turning Couple produced is ' num2str(TotalExtraLift) ' N'])
      
      disp(' ')
      NetCouple = deltaFz1 - TotalExtraLift;
      
      disp(['The net rolling force acting on the vehicle with active aerodynamics is ' num2str(NetCouple) ' N']);
      
end

 Limits;

% We are in the process of implementing this code into a SIMULINK model to
% control 4 servo motors as a demonstration of this project based on
% various input signals. The input signals will be taken from  a free SIMULINK
% vehicle model provided by Cruden (https://www.cruden.com/) called
% Panthera Free (http://www.cruden.com/panthera-free/)


