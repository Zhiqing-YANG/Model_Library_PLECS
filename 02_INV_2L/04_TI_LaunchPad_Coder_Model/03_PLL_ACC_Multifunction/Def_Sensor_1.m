%% Sensor Definition
% ########################################################################
% Define the object of a sensor
% Detailed information: "Mainboard Sensor Calibration - Board1 - Sensor 1.xlsx"
% Establishment: 24.02.2021 Jiani He, PGS, RWTH Aachen
% #############################################################################

function Sensor = Def_Sensor_1()
%% Voltage sensor
Sensor.V.ratio.S1 = 0.0053456;
Sensor.V.ratio.S2 = 0.0053739; 
Sensor.V.ratio.S3 = 0.0053431;
Sensor.V.shift.S1 = 1.49805;
Sensor.V.shift.S2 = 1.49619;
Sensor.V.shift.S3 = 1.492;

%% Current sensor
Sensor.I.ratio.S1 = 0.0703745;
Sensor.I.ratio.S2 = 0.0703745;
Sensor.I.ratio.S3 = 0.0703834;
Sensor.I.shift.S1 = 1.48804;
Sensor.I.shift.S2 = 1.49413;
Sensor.I.shift.S3 = 1.49735;

end



