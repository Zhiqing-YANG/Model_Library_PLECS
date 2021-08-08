%% System Initialization
% ########################################################################
% Define a system
% Establishment: 23.08.2020 Zhiqing Yang, PGS, RWTH Aachen
% ########################################################################

clear

%% Simulation 
simtime = 1;                            % [s] simulation time

%% Grid
Grid = Def_Grid();   
% change of grid parameters
Grid.Lg = 100e-6;                   
Grid.Lg_add = 100e-6;                    % [H] incremental grid inductance 


%% Inverter
Inv = Def_Inverter();
% change of inverter parameters
Inv.OP.I_pv = 1500;                     % [A] operating condition pv current

%% Control
Ctrl = Def_Control(Grid,Inv);
% change of inverter parameters
% Ctrl.VDC.Gdd.Kp = 0;
% Ctrl.VDC.Gdd.Ki = 0;
% Ctrl.VDC.Gdd.Kd = 0;
% Ctrl.VDC.Gqq.Kp = 0;
% Ctrl.VDC.Gqq.Ki = 0;
% Ctrl.VDC.Gqq.Kd = 0;
