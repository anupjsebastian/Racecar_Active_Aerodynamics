% This script generates two matrices containing lift and drag forces
% produced by the rear wing design versus at each angle
% The rows represent the angles varying from -7 to 20 and the columns
% represent the lift force and the drag force in each respective matrix


global rho %[kg/m^3] density of air
global MinAeroVel % [km/hr] Minimum velocity at which Active aerodynamics should start
global MaxAeroVel % [km/hr] Maximum velocity of the car

NoOfVals = MaxAeroVel - MinAeroVel;

LiftDataR = zeros(28,NoOfVals);
DragDataR = zeros(28,NoOfVals);
velocity = MinAeroVel:MaxAeroVel;
angle = -7:20;



for j = 1:NoOfVals
    for i = 1:28
        LiftDataR(i,j) = -0.5 * rho * AeroDataInputR(i,2) .* velocity(j)^2 * AeroDataInputR(i,3);
        DragDataR(i,j) = 0.5 * rho * AeroDataInputR(i,2) .* velocity(j)^2 * AeroDataInputR(i,4);
    end
end

clear i j NoOfVals;