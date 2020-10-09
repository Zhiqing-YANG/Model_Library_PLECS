
%% Modulator of DAB3 Definition
% ########################################################################
% Define Object of a Modulator for DAB3
% Input:
%       - [obj] Parameters of DAB3
%       - [obj] Parameters of Controller for DAB3
% Output:
%       - [obj] The parameters of Modulator for DAB3 
%
%
% Establishment: 14,09,2020 Huixue Liu, PGS, RWTH Aachen
% Last Change:   17,09,2020 Huixue Liu, PGS, RWTH Aachen
% ########################################################################

%% Parameters definition

function Mod = Def_Mod(DAB3,Ctrl)

% Set up the operating point
Mod.f = 1000;                                        % [Hz] switching frequency

% Dead Time 
Mod.td_in = Ctrl.td_in;                              % [s] dead time of input bridge devices
Mod.td_out = Ctrl.td_out;                            % [s] dead time of output bridge devices
Mod.td_mode = Ctrl.td_mode;                          % [s] dead time mode:  1: Start of on-time intervall
                                                     %                      2: End of on-time intervall
                                                     %                      3: Split: half start, half end
Mod.td_flag = Ctrl.td_flag;                          % [s] dead time compensation mode:  1: on;
                                                     %                                   0: off;
                                                     
% Set up the modulator parameters based on DAB3
Mod.L = DAB3.L;                                      % [H] leakage inductor (convert to prim)
Mod.Rw = DAB3.Rw;                                    % [Ohm] winding resistor total

end