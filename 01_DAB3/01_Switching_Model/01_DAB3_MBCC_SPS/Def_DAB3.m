
%% Three phase DAB converter Definition
% ########################################################################
% Define object of a Three phase DAB converter
%
% Output:
%       - [obj] Parameters of DAB3
%
% Establishment: 03.04.2021 Zhiqing Yang, PGS, RWTH Aachen
% ########################################################################

%%
function DAB3 = Def_DAB3()

% DC link intput side
DAB3.Rc_in = 1e-3;                            % [Ohm] parasite resistor of DC link input capacitor
DAB3.C_in = 2e-3;                             % [F] DC link input capacitor

% DC link output side
DAB3.Rc_out = 1e-3;                           % [Ohm] parasite resistor of DC link output capacitor
DAB3.C_out = 2e-3;                            % [F] DC link output capacitor
                       
% Transformer parameters
DAB3.Ntr = 1;                                 % turns ratio in transformer Ntr:1
DAB3.L = 1000e-6;                             % [H] leakage inductor (convert to prim)
DAB3.Rw = 500e-3;                             % [Ohm] winding resistor total

% Operating point
DAB3.Vn_in = 5000;                            % [V] initial voltage of input capacitor 
DAB3.Vn_out = 5000;                           % [V] initial voltage of output capacitor 

end