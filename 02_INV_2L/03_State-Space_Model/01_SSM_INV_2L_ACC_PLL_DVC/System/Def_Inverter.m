%% Inverter Definition
% ########################################################################
% Define object of a central inverter
% Output:
%       - [obj] inverter parameter 
% Establishment: 23.08.2020 Zhiqing Yang, PGS, RWTH Aachen
% ########################################################################

function Inv = Def_Inverter()
%% Filter Parameters
% dc-link filters
Inv.Filter.C_dc = 15e-3;          % [F] dc-link capacitance
Inv.Filter.R_dc = 10e-6;          % [H] dc-link stray inductance

% ac-side filters
Inv.Filter.L1 = 120e-6;           % [H] filter inductance in inverter side
Inv.Filter.R1 = 1e-3;             % [Ohm] parasite resistance in L1
Inv.Filter.C = 1e-3;              % [H] filter capacitance 
Inv.Filter.Rd = 0;                % [Ohm] damping resistance    
Inv.Filter.L2 = 40e-6;            % [H] filter inductance in grid side
Inv.Filter.R2 = 1e-3;             % [Ohm] parasite resistance in L2

%% Operating Point
Inv.OP.V_dc = 1200;               % [V] operating condition dc-link voltage
Inv.OP.I_pv = 1500;               % [A] operating condition pv current

end
