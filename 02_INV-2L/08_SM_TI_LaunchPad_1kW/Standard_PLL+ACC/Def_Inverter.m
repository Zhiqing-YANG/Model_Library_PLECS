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
Inv.Filter.C_dc = 2e-3;           % [F] dc-link capacitance
Inv.Filter.R_dc = 10e-6;          % [H] dc-link stray inductance

% ac-side filters
Inv.Filter.L1 = 2.5e-3;           % [H] filter inductance in inverter side
Inv.Filter.R1 = 0.8;              % [Ohm] parasite resistance in L1
Inv.Filter.C = 10e-6;             % [H] filter capacitance 
Inv.Filter.Rd = 5.2;              % [Ohm] damping resistance    
Inv.Filter.L2 = 0;                % [H] filter inductance in grid side
Inv.Filter.R2 = 0;                % [Ohm] parasite resistance in L2

%% Operating Point
Inv.OP.V_dc = 180;                % [V] operating condition dc-link voltage
end
