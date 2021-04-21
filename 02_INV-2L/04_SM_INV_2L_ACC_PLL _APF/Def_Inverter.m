%% Inverter Definition
% ########################################################################
% Define object of a central inverter
% Output:
%       - [obj] inverter parameter 
% Establishment: 23.08.2020 Zhiqing Yang, PGS, RWTH Aachen
% Last Change:   23.08.2020 Zhiqing Yang, PGS, RWTH Aachen
% ########################################################################

function Inv = Def_Inverter()

% dc-link filters
Inv.Filter.C_dc = 5e-3;           % [F] dc-link capacitance
Inv.Filter.R_dc = 10e-6;          % [H] dc-link stray resistance

% ac-side filters
Inv.Filter.L1 = 2e-3;           % [H] filter inductance in inverter side
Inv.Filter.R1 = 1e-3;             % [Ohm] parasite resistance in L1

% steady-state operating
Inv.OP.V_dc = 1200;             % [V] initial dc-link voltage

end
