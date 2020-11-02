
%% System Initialization
% ########################################################################
% To initialize PLECS model for DAB3 system 
%
% Operating flag (to set up the OP_flag in controller):     
%                     OP_flag = 1;    % 1: SPS(bidirection)
%                                     % 2: ADCC (bidirection)
%                                     % 3: IADCC (bidirection)
%                                      
% ICC mode (to set up the OP_mode in modulator):          
%                     ICC_flag = 0;   % 0: without ICC
%                                     % 1: with ICC
%                                      
% Dead time mode (to set up the OP_mode in controller):     
%                     td_mode = 1:    % 1: Start of on-time intervall
%                                     % 2: End of on-time intervall
%                                     % 3: Split: half start, half end
%
% Establishment: 11.05.2020 Huixue Liu, PGS, RWTH Aachen
% Last change:   10.10.2020 Zhiqing Yang, PGS, RWTH Aachen
% ########################################################################

%% Parameters definition

% Simulation parameters
simtime = 0.1;                               % [s] simulation time in Plecs      

% Define DAB parameter
DAB3 = Def_DAB3();

% Define modulator
Mod = Def_Mod(DAB3);

% Define controller
Ctrl = Def_Ctrl(DAB3,Mod);

% Define operation range
OP = Def_Plot_OP_Range(DAB3,Ctrl);

