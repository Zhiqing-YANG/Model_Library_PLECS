%% System Initialization
% ########################################################################
% Define a system
% Establishment: 23.08.2020 Zhiqing Yang, PGS, RWTH Aachen
% Last Change:   15.01.2021 Jiani He, PGS, RWTH Aachen
% ########################################################################

clear all

%% Simulation 
simtime = 10;                            % [s] simulation time

%% Grid
Grid = Def_Grid();   
% change of grid parameters      
% Grid.Lg = 3e-3;

%% Inverter
Inv = Def_Inverter();
% change of inverter parameters
Inv.Filter.Rd = 3.2;

%% PCB
% Def Sensor
% Sensor = Def_Sensor;
Sensor = Def_Sensor_1;
% Sensor = Def_Sensor_2;

%% Control
Ctrl = Def_Control(Grid,Inv);
% change of control parameters
Ctrl.T_dh_extra = 4*Ctrl.T_sp;
Ctrl.ACC.K = 4*1000*2/pi*(Ctrl.T_dh+Ctrl.T_dh_extra)^2;
Ctrl.VDC.Kd = -4*(Ctrl.T_dh+Ctrl.T_dh_extra)^2/(Inv.Filter.L1*pi^2);

%% Protection
Ctrl.th_vc = 150;
Ctrl.th_iL = 20;
