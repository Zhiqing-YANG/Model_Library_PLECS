
%% Set the Operating Point
% ########################################################################
% Decide the constant voltage value side and set the operating point 
%  according to the required power and voltage value.
%
% Input:
%       - [obj] DAB3: DAB3 converter paramter 
%       - [obj] Set: set operating point
% Output:
%       - [obj] OP: defined operating voltage and power
%
% Establishment: 03.04.2021 Zhiqing Yang, PGS, RWTH Aachen
% ########################################################################

%%
function OP = Def_SetOP(DAB3,Set)

% set the power flow direction and the rated power value
OP.Pn = 500e3 ;                            % [W] rated power  
OP.P_op = Set.P_op;                        % [p.u.] operation power refer to Pn 
OP.Pref = OP.P_op*OP.Pn;                   % [W] referred transferred power

% set the voltage value at the fixed voltage value side 
OP.V_fix = 5000;                           % [V] voltage at fixed side
OP.r_op = Set.V_ratio;                     % [ ] voltage ratio w.r.t. Vn_in or Vn_out
OP.fix_flag = Set.V_fix;                   % [ ] set the constant voltage value side

switch OP.fix_flag
    case 'Vin' 
        OP.Vn_in = OP.V_fix;               % [V] input nominal volage
        OP.Vn_out = OP.V_fix/DAB3.Ntr;     % [V] output nominal voltage
        OP.Vi = OP.Vn_in;                  % [V] input voltage operation point          
        OP.Vo = OP.Vn_out*OP.r_op;         % [V] output voltage operation point
        
    case 'Vout'
        OP.Vn_out = OP.V_fix;              % [V] input nominal volage
        OP.Vn_in = OP.V_fix*DAB3.Ntr;      % [V] output nominal voltage
        OP.Vo = OP.Vn_out;                 % [V] input voltage operation point          
        OP.Vi = OP.Vn_in*OP.r_op;          % [V] output voltage operation point    
end

end
