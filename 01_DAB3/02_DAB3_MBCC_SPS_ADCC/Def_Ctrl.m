
%% Controller of DAB3 Definition
% ########################################################################
% Define Object of a Controller for DAB3
% Input:
%       - [obj] Parameters of DAB3
% Output:
%       - [obj] The parameters of Controller for DAB3 
%
%
% Establishment: 14,09,2020 Huixue Liu, PGS, RWTH Aachen
% Last Change:   17,09,2020 Huixue Liu, PGS, RWTH Aachen
% ########################################################################

%% Parameters definition

function Ctrl = Def_Ctrl(DAB3)       

% %% Set up the operating point and operating mode
% set the value and direction of power flow
Ctrl.Pn = 500e3 ;                                   % [W] rated power  
Ctrl.P_op = 0.2;                                      % [p.u.] operation power refer to Pn 
Ctrl.Pref = Ctrl.P_op*Ctrl.Pn;                      % [p.u.] referred transferred power

% Set up the operating mode and dead time mode
Ctrl.f = 1000;                                      % [Hz] switching frequency
Ctrl.w = 2*pi*Ctrl.f;                               % [rad/s]
Ctrl.f_samp = 1000;                                 % [Hz] sampling frequency
Ctrl.OP_flag = 2;                                   % [s] Operation flag: 1: SPS(bidirection)
                                                    %                     2: ADCC (bidirection)
                                                    %                     3: IADCC (bidirection)                                                          
Ctrl.td_in = 5e-6;                                  % [s] dead time of input bridge devices
Ctrl.td_out = 5e-6;                                 % [s] dead time of output bridge devices
Ctrl.td_mode = 1;                                   % [s] dead time mode:  1: Start of on-time intervall
                                                    %                      2: End of on-time intervall
                                                    %                      3: Split: half start, half end
Ctrl.td_flag = 1;                                   % [s] dead time compensation mode:  1: on;
                                                    %                                   0: off;
Ctrl.zcs_rel = 2*Ctrl.td_in*Ctrl.f;                 % relative forced ZCS space

% %% Set up the controller parameters based on DAB3
Ctrl.Ntr = DAB3.Ntr;
Ctrl.L = DAB3.L;

end