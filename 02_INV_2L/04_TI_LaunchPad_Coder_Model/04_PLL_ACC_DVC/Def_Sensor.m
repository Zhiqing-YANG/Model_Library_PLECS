%% Sensor Definition
% ########################################################################
% Define the object of a sensor
% Detailed information: "Mainboard Sensor Calibration - Board2.xlsx"
% Establishment: 24.02.2021 Liu Yu, Tianxiao Chen, PGS, RWTH Aachen
% ########################################################################

function Sensor = Def_Sensor()
%% Voltage sensor
% components
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
% components
turn = 2;
Rm = 135;
Ra1 = 100e3;
Ra2 = 26.1e3;

Sensor.I.v_ref = 1.497;
Sensor.I.ratio = Ra1/Ra2*1000/Rm/turn;
Sensor.I.shift.S1 = -0.01;
Sensor.I.shift.S2 = -0.01;
Sensor.I.shift.S3 = 0;

%% Voltage sensor dc
% components
Ra1 = 100e3;
Ra2 = 30e3;

Sensor.Vdc.v_ref = 0;
Sensor.Vdc.ratio = Ra1/Ra2*100/0.71;
Sensor.Vdc.shift = 0;

end
