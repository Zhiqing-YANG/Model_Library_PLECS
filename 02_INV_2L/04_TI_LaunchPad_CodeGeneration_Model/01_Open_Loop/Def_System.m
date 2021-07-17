%% System Initialization
% ########################################################################
% Define a system
% Establishment: 23.08.2020 Zhiqing Yang, PGS, RWTH Aachen
% Last Change:   15.01.2021 Jiani He, PGS, RWTH Aachen
% ########################################################################

clear all

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
% change of inverter parameters
