
%% Three phase DAB converter Definition
% ########################################################################
% Define object of a Three phase DAB converter
%
% Output:
%       - [obj] Three phase DAB converter parameters
%
%
% Establishment: 13,05,2020 Huixue Liu, PGS, RWTH Aachen
% Last Change:   17,09,2020 Huixue Liu, PGS, RWTH Aachen

% ########################################################################

%% Parameters definition
function DAB3 = Def_DAB3()

% DC link intput side
DAB3.Rc_in = 1e-3;                            % [Ohm] parasite resistor of DC link input capacitor
DAB3.C_in = 2e-3;                             % [F] DC link input capacitor
DAB3.Vn_in = 5000;                            % [V] initial voltage of input capacitor that from OP.Vn_in in Def_SetOP

% DC link output side
DAB3.Rc_out = 1e-3;                           % [Ohm] parasite resistor of DC link output capacitor
DAB3.C_out = 2e-3;                            % [F] DC link output capacitor
DAB3.Vn_out = 5000;                           % [V] initial voltage of output capacitor that from OP.Vn_out in Def_SetOP
                       
% Transformer parameters
DAB3.Ntr = 1;                                 % turns ratio in transformer Ntr:1
DAB3.L = 1000e-6;                             % [H] leakage inductor (convert to prim)
DAB3.Rw = 500e-3;                             % [Ohm] winding resistor total

end