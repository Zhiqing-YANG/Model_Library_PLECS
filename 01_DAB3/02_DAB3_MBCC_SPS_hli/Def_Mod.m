
%% Modulator of DAB3 Definition
% ########################################################################
% Define Object of a Modulator for DAB3
%
% Output:
%       - [obj] The parameters of Modulator for DAB3 
%
%
% Establishment: 14,09,2020 Huixue Liu, PGS, RWTH Aachen
% Last Change:   09,10,2020 Huixue Liu, PGS, RWTH Aachen

% ########################################################################

%% Parameters definition

function Mod = Def_Mod()

% Set up the operating point
Mod.f = 1000;                                        % [Hz] switching frequency

% Dead Time 
Mod.td_in = 5e-6;                                    % [s] dead time of input bridge devices
Mod.td_out = 5e-6;                                   % [s] dead time of output bridge devices

end