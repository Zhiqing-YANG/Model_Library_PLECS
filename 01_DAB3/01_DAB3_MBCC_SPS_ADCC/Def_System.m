
%% System Initialization
% ########################################################################
% To initialize PLECS model for DAB3 system 
%
% Operating flag (to set up the OP_flag in controller):     
%                     OP_flag = 1;    % 1: SPS(bidirection)
%                                     % 2: ADCC (bidirection)
%                                     % 3: IADCC (bidirection)
%
% Dead time compensation flag (to set up the td_flag in controller): 
%                     td_flag = 1;    % 1: on;
%                                     % 0: off;
%                                      
% ICC mode (to set up the ICC_mode in modulator):          
%                     ICC_flag = 0;   % 0: without ICC
%                                     % 1: with ICC
%                                      
% Dead time mode (to set up the td_mode in modulator):     
%                     td_mode = 1:    % 1: Start of on-time intervall
%                                     % 2: End of on-time intervall
%                                     % 3: Split: half start, half end
%
%
% Establishment: 11.05.2020 Huixue Liu, PGS, RWTH Aachen
% Last change:   25.10.2020 Huixue Liu, PGS, RWTH Aachen
    
% ########################################################################

%% Parameters definition

% Simulation parameters
simtime = 0.1;                               % [s] simulation time in Plecs      

% Object of Three Phase DAB
DAB3 = Def_DAB3();

% Object of Setting Operating Point
fix_flag = 'input side';
OP = Def_SetOP(fix_flag,DAB3);

% Object of modulator
Mod = Def_Mod(DAB3);

% Object of controller 
Ctrl = Def_Ctrl(OP,DAB3,Mod);

% Plot Operating Point and Operating Range
Def_Plot(OP,DAB3,Ctrl);

