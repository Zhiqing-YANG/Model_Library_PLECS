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
% Grid.Lg_add = 2e-3;                    % [H] incremental grid inductance 

%% Inverter
Inv = Def_Inverter();
% change of inverter parameters


%% Control
Ctrl = Def_Control(Grid,Inv);
% change of inverter parameters
Ctrl.MBC.Theta = 0;                 % [rad] phase correction angle
% Ctrl.PLL.Kp = 8;
Ctrl.ACC.Kp = 8;