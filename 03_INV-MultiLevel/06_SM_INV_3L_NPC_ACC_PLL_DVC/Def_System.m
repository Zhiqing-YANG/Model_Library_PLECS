%% System Initialization
% ########################################################################
% Define a system
% Establishment: 23.08.2020 Zhiqing Yang, PGS, RWTH Aachen
% Last Change:   23.08.2020 Zhiqing Yang, PGS, RWTH Aachen
% ########################################################################

% simulation 
simtime = 1;                        % [s] simulation time

% grid
Grid = Def_Grid();         

% inverter
Inv = Def_Inverter();
Ctrl = Def_Control(Grid,Inv);
