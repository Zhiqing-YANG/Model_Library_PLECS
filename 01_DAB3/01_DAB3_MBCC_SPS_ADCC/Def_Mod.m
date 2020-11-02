
%% Modulator of DAB3 Definition
% ########################################################################
% Define Object of a Modulator for DAB3
%
% Input:
%       - [obj] Parameters of DAB3
% Output:
%       - [obj] The parameters of Modulator for DAB3 
%
%
% Establishment: 14,09,2020 Huixue Liu, PGS, RWTH Aachen
% Last Change:   17,09,2020 Huixue Liu, PGS, RWTH Aachen
% ########################################################################

%% Parameters definition

function Mod = Def_Mod(DAB3)

% Set up the operating point and operating mode
Mod.f = 1000;                                        % [Hz] switching frequency
Mod.ICC_flag = 0;                                    % [s] ICC mode: 0: without ICC;
                                                     %               1: with ICC    
                                                     
% Dead Time 
Mod.td_in = 5e-6;                                    % [s] dead time of input bridge devices
Mod.td_out = 5e-6;                                   % [s] dead time of output bridge devices
Mod.td_mode = 1;                                     % [s] dead time mode: 1: Start of on-time intervall
                                                     %                     2: End of on-time intervall
                                                     %                     3: Split: half start, half end
% Set up the modulator parameters based on DAB3
Mod.L = DAB3.L;                                      % [H] leakage inductor (convert to prim)
Mod.Rw = DAB3.Rw;                                    % [Ohm] winding resistor total
 
end