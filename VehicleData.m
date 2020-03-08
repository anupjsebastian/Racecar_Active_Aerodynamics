% Use this script to input vehicle data

global g     % [m/s^2] constant of cravity
global mc    % [kg]    chassis mass
global mw    % [kg]    mass of each knuckle and wheel
global s     % [m]     track width
global h0    % [m]     height of center of gravity
global r0    % [m]     static tire radius
global cs    % [N/m]   suspension stiffness
global cb    % [N/m]   stiffness of anti roll bar
global cy    % [N/m]   tire lateral stiffness
global cz    % [N/m]   tire radial stiffness
global s0    % [m]     Length between steering pivot points
global wb    % [m]     Wheelbase
global mu    % Coefficient of friction with road
global MinAeroVel % [km/hr] Minimum velocity at which Active aerodynamics should start
global MaxAeroVel % [km/hr] Maximum velocity of the car
global rho %[kg/m^3] density of air
global weightPropF % proportion of weight of front of car to total weight
global weightPropR % proportion of weight of front of car to total weight


g  = 9.81 ;  % [m/s^2] constant of gravity
mc = 200;    % [kg]    chassis mass
mw =  9;     % [kg]    mass of each knuckle and wheel
s  = 1.5;    % [m]     track width
h0 = 0.6;    % [m]     height of center of gravity
r0 = 0.3;    % [m]     static tire radius
cs = 20000;  % [N/m]   suspension stiffness
cb = 10000;  % [N/m]   stiffness of anti roll bar
cy = 180000;  % [N/m]   tire lateral stiffness
cz = 200000;  % [N/m]   tire radial stiffness
s0 = 1.4;        % [m]     Length between steering pivot points
wb = 1.7;        % [m]     Wheelbase
mu = 1;          % Coefficient of friction with road
MinAeroVel = 40; % [km/hr] Minimum velocity at which Active aerodynamics should start
MaxAeroVel = 120; % [km/hr] Maximum velocity of the car
rho = 1.225;    %[kg/m^3] density of air
weightPropF  = 0.3; % ratio of weight of front of car to rear
weightPropR = 1 - weightPropF; % ratio of weight of front of car to rear


