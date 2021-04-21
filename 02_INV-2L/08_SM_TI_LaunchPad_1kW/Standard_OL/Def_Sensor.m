%% Sensor
% ########################################################################
% Define object of the sensor
% Detailed information: "Mainboard Sensor Calibration - Board2.xlsx"
% ########################################################################



function Sensor = Def_Sensor()

%% Voltage sensor
% Components
R1 = 22e3;
Rm = 195;
Ra1 = 100e3;
Ra2 = 24.6e3;
Sensor.V.v_ref = 1.497;

Sensor.V.ratio = Ra1/Ra2/Rm*1e3/2.5*R1/1000;
Sensor.V.shift.S1 = -0.003;
Sensor.V.shift.S2 = -0.003;
Sensor.V.shift.S3 = -0.003;
% fprintf('%.2f',Sensor.V.ratio)

%% Current sensor
% Components
turn = 2;
Rm = 135;
Ra1 = 100e3;
Ra2 = 26.1e3;
Sensor.I.v_ref = 1.497;

Sensor.I.ratio = Ra1/Ra2*1000/Rm/turn;
Sensor.I.shift.S1 = -0.01;
Sensor.I.shift.S2 = -0.01;
Sensor.I.shift.S3 = 0;



