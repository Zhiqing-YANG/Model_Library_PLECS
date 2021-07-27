%% Inverter Definition
% ########################################################################
% Define the object of a rectifier
% Output:
%       - [obj] rectifier parameter 
% Establishment: 23.08.2020 Zhiqing Yang, PGS, RWTH Aachen
% ########################################################################

function Rec = Def_Rectifier()
%% Filter Parameters
% dc-side filters
Rec.Filter.Ldc = 50e-3;                  % [H] inductance at the AC side
Rec.Filter.Rdc = 20;                     % [Ohm] resistance at the AC side

% ac-side filters 
Rec.Filter.Lac = 1e-4;                   % [H] inductance at the AC side
Rec.Filter.Rac = 0;                      % [Ohm] resistance at the AC side

end
