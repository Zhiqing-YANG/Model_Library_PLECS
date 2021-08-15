%% System Initialization
% ########################################################################
% Define a system
% Establishment: 23.08.2020 Zhiqing Yang, PGS, RWTH Aachen
% ########################################################################

clear

%% Simulation 
simtime = 30;                            % [s] simulation time

%% Grid
Grid = Def_Grid();   
% change of grid parameters                

%% Inverter
Inv = Def_Inverter();
% change of inverter parameters

%% PCB
% Def Sensor
% 1: mainboard 1 + sensor 1
% 2: mainboard 2 + sensor 2
Sensor = Def_Sensor(2);

%% Control
Ctrl = Def_Control(Grid,Inv,Sensor);
% change of inverter parameters
