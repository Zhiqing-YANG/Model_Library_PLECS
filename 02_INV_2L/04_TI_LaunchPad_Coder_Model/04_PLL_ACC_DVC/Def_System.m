%% System Initialization
% ########################################################################
% Define a system
% Establishment: 02.08.2021 Zhiqing Yang, PGS, RWTH Aachen
% ########################################################################

clear

%% Simulation 
simtime = 1;                            % [s] simulation time

%% Grid
Grid = Def_Grid();   
% change of grid parameters                

%% Inverter
Inv = Def_Inverter();
% change of inverter parameters

%% PCB
% Def Sensor
Sensor = Def_Sensor;

%% Control
Ctrl = Def_Control(Grid,Inv);
% change of control parameters
