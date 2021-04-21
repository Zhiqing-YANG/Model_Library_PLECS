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
Grid.Lg = 200e-6;                   
Grid.Lg_add = 100e-6;                    % [H] incremental grid inductance 


%% Inverter
Inv = Def_Inverter();
% change of inverter parameters
Inv.OP.I_pv = 1000;                     % [A] operating condition pv current

%% Control
Ctrl = Def_Control(Grid,Inv);
% change of inverter parameters                
% Ctrl.MBC.Theta = 0;                 % [rad] phase correction angle
Ctrl.ACC.K_VFF = 2*pi*3000;