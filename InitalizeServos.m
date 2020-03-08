
% initialize Arduino

a = arduino('COM5', 'Uno', 'Libraries', 'Servo');

% initialize servos

FL = servo(a, 'D4');
FR = servo(a, 'D5');
RL = servo(a, 'D6');
RR = servo(a, 'D7');
