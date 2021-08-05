%% Sensor Definition
% ########################################################################
% Define the object of a sensor
% Detailed information: "Mainboard Sensor Calibration - Board2 - Sensor 2.xlsx"
% Establishment: 24.02.2021 Jiani He, PGS, RWTH Aachen
% #############################################################################

function Sensor = Def_Sensor_2()
%% Voltage sensor
Sensor.V.ratio.S1 = 0.0053592;
Sensor.V.ratio.S2 = 0.0053699;
Sensor.V.ratio.S3 = 0.0053627;
Sensor.V.shift.S1 = 1.48643;
Sensor.V.shift.S2 = 1.49014;
Sensor.V.shift.S3 = 1.50004;

%% Current sensor
Sensor.I.ratio.S1 = 0.0703745;
Sensor.I.ratio.S2 = 0.0703745;
Sensor.I.ratio.S3 = 0.0703834;
Sensor.I.shift.S1 = 1.48804;
Sensor.I.shift.S2 = 1.49413;
Sensor.I.shift.S3 = 1.49735;

end

