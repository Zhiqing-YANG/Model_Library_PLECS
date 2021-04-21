%% Inverter Definition
% ########################################################################
% Define object of a central inverter
% Output:
%       - [obj] inverter parameter 
% Establishment: 23.08.2020 Zhiqing Yang, PGS, RWTH Aachen
% Last Change:   15.01.2021 Jiani He, PGS, RWTH Aachen
% ########################################################################

function Inv = Def_Inverter()
%% Filter Parameters
% dc-link filters
Inv.Filter.C_dc = 15e-3;          % [F] dc-link capacitance
Inv.Filter.R_dc = 10e-6;          % [H] dc-link stray inductance

% ac-side filters
Inv.Filter.L1 = 102e-6;           % [H] filter inductance in inverter side
Inv.Filter.R1 = 1e-3;             % [Ohm] parasite resistance in L1
Inv.Filter.C = 1.05e-3;              % [H] filter capacitance 
Inv.Filter.Rd = 0.06;                % [Ohm] damping resistance    
Inv.Filter.L2 = 55e-6;            % [H] filter inductance in grid side
Inv.Filter.R2 = 1e-3;             % [Ohm] parasite resistance in L2

%% Operating Point
Inv.OP.V_dc = 1200;               % [V] operating condition dc-link voltage
Inv.OP.I_pv = 1200;               % [A] operating condition pv current

end
