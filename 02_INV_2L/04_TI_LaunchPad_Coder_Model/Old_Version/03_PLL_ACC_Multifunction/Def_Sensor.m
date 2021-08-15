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
Sensor.V.ratio.S1 = Ra1/Ra2/Rm*1e3/2.5*R1/1000;
Sensor.V.ratio.S2 = Ra1/Ra2/Rm*1e3/2.5*R1/1000;
Sensor.V.ratio.S3 = Ra1/Ra2/Rm*1e3/2.5*R1/1000;
Sensor.V.shift.S1 = -0.003+Sensor.V.v_ref;
Sensor.V.shift.S2 = -0.003+Sensor.V.v_ref;
Sensor.V.shift.S3 = -0.003+Sensor.V.v_ref;
% fprintf('%.2f',Sensor.V.ratio)

%% Current sensor
% components
turn = 2;
Rm = 135;
Ra1 = 100e3;
Ra2 = 26.1e3;

Sensor.I.v_ref = 1.497;
Sensor.I.ratio.S1 = Ra1/Ra2*1000/Rm/turn;
Sensor.I.ratio.S2 = Ra1/Ra2*1000/Rm/turn;
Sensor.I.ratio.S3 = Ra1/Ra2*1000/Rm/turn;
Sensor.I.shift.S1 = -0.01+Sensor.I.v_ref;
Sensor.I.shift.S2 = -0.01+Sensor.I.v_ref;
Sensor.I.shift.S3 = 0+Sensor.I.v_ref;

end


