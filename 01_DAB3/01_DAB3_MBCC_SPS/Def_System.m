
%% System Initialization
% ########################################################################
% To initialize PLECS model for DAB3 system 
%
% Operating flag:     SPS(Single Phase Shift - bidirection)                                                                       
%                                      
% Dead time mode:     Start of on-time intervall
%
%
% Establishment: 11.05.2020 Huixue Liu, PGS, RWTH Aachen
% Last change:   25.10.2020 Huixue Liu, PGS, RWTH Aachen  
% ########################################################################

%% Parameters Definition
% Simulation Parameters
simtime = 0.1;                               % [s] simulation time in Plecs      

% Object of Three Phase DAB
DAB3 = Def_DAB3();

% Object of Setting Operating Point
fix_flag = 'input side';
OP = Def_SetOP(fix_flag,DAB3);
OP.P_op = 0.9;
OP.r_op = 0.8;

% Object of Modulator
Mod = Def_Mod();

% Object of Controller 
Ctrl = Def_Ctrl(OP,DAB3,Mod);

% Plot Operating Point and Operating Range
Def_Plot(OP,DAB3,Ctrl);

