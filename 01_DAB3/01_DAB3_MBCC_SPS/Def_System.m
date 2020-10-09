
%% System Initialization
% ########################################################################
% To initialize PLECS model for DAB3 system 
%
% Operating flag:     SPS(bidirection)                                                                       
%                                      
% Dead time mode:     td_mode = 1:    % 1: Start of on-time intervall
%                                     % 2: End of on-time intervall
%                                     % 3: Split: half start, half end
%
% Establishment: 11.05.2020 Huixue Liu, PGS, RWTH Aachen
% Last change:   20.09.2020 Huixue Liu, PGS, RWTH Aachen
    
% ########################################################################

%% Parameters definition

% Simulation parameters
simtime = 0.1;                               % [s] simulation time in Plecs      

% Object of Three Phase DAB
DAB3 = Def_DAB3();

% Object of controller 
Ctrl = Def_Ctrl(DAB3);

% Object of modulator
Mod = Def_Mod(DAB3,Ctrl);

% Decide constant voltage value side & Plot OP-Point and OP-Range
fix_flag = 'input side';
[Vi,Vo]= Def_Plot_OP_Range(DAB3,fix_flag,Ctrl);

