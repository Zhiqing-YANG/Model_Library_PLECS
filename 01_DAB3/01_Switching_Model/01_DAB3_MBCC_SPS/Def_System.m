
%% System Initialization
% ########################################################################
% To initialize PLECS model for DAB3 system 
%
% Establishment: 03.04.2021 Zhiqing Yang, PGS, RWTH Aachen
% ########################################################################

%%
% Simulation Parameters
simtime = 0.1;                                     

% Object of Three Phase DAB
DAB3 = Def_DAB3();

% Object of Setting Operating Point
Set.V_fix = 'Vin';
Set.V_ratio = 0.95;
Set.P_op = 0.8;
OP = Def_SetOP(DAB3,Set);

% Object of Controller 
Ctrl = Def_Control(DAB3,OP);

% Plot Operating Point and Operating Range
Plot_OP(DAB3,Ctrl,OP);
