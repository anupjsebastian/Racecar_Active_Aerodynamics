% This script generates two matrices containing lift and drag forces
% produced by the front wing design versus at each angle
% The rows represent the angles varying from -7 to 20 and the columns
% represent the lift force and the drag force in each respective matrix

global rho %[kg/m^3] density of air
global MinAeroVel % [km/hr] Minimum velocity at which Active aerodynamics should start
global MaxAeroVel % [km/hr] Maximum velocity of the car

NoOfVals = MaxAeroVel - MinAeroVel;

LiftDataF = zeros(28,NoOfVals);
DragDataF = zeros(28,NoOfVals);
velocity = MinAeroVel:MaxAeroVel;
angle = -7:20;

for j = 1:NoOfVals
    for i = 1:28
        LiftDataF(i,j) = -0.5 * rho * AeroDataInputF(i,2) .* velocity(j)^2 * AeroDataInputF(i,3);
        DragDataF(i,j) = 0.5 * rho * AeroDataInputF(i,2) .* velocity(j)^2 * AeroDataInputF(i,4);
    end
end

clear i j NoOfVals;