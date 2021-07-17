%% Inverter Definition
% ########################################################################
% Define object of a rectifier
% Output:
%       - [obj] rectifier parameter 
% Establishment: 23.08.2020 Zhiqing Yang, PGS, RWTH Aachen
% Last Change:   23.08.2020 Zhiqing Yang, PGS, RWTH Aachen
% ########################################################################

function Rec = Def_Rectifier()

% AC side 
Rec.Filter.Lac = 1e-4;                      % [H] inductance at the AC side
Rec.Filter.Rac = 0;                      % [Ohm] resistance at the AC side

% DC side 
Rec.Filter.Ldc = 50e-3;                      % [H] inductance at the AC side
Rec.Filter.Rdc = 20;                     % [Ohm] resistance at the AC side

end
