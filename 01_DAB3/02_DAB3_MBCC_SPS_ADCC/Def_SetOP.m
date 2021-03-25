
%% Set the Operating Point
% ########################################################################
% Decide the constant voltage value side and set the operating point 
%  according to the required power and voltage value.
%
% Definition:
%       - [W] Pn: rated power 
%       - [ ] fix_flag(set the constant voltage value side): 'input side'
%                                                            'output side' 
%       - [V] V_fix: the voltage value at the fixed voltage value side
% Output:
%       - [W] Pref: referred transferred power
%       - [V] Vi: the input voltage of dc-dc converter
%       - [V] Vo: the output voltage of dc-dc converter
%
%
% Establishment: 19.10.2020 Huixue Liu, PGS, RWTH Aachen
% Last change:   25.10.2020 Huixue Liu, PGS, RWTH Aachen
   
% ########################################################################

%% 
function OP = Def_SetOP(fix_flag,DAB3)

% set the power flow direction and the rated power value
OP.Pn = 500e3 ;                            % [W] rated power  
OP.P_op = 1;                               % [p.u.] operation power refer to Pn 
OP.Pref = OP.P_op*OP.Pn;                   % [W] referred transferred power

% set the voltage value at the fixed voltage value side 
OP.V_fix = 1000;                           % [V] voltage at fixed side
OP.r_op = 1.0;                             % [ ] voltage ratio w.r.t. Vn_in or Vn_out
OP.fix_flag = fix_flag;                    % [ ] set the constant voltage value side

switch OP.fix_flag
    case 'input side' 
        OP.Vn_in = OP.V_fix;               % [V] input nominal volage
        OP.Vn_out = OP.V_fix/DAB3.Ntr;     % [V] output nominal voltage
        OP.Vi = OP.Vn_in;                  % [V] input voltage operation point          
        OP.Vo = OP.Vn_out*OP.r_op;         % [V] output voltage operation point
        
    case 'output side'
        OP.Vn_out = OP.V_fix;              % [V] input nominal volage
        OP.Vn_in = OP.V_fix*DAB3.Ntr;      % [V] output nominal voltage
        OP.Vo = OP.Vn_out;                 % [V] input voltage operation point          
        OP.Vi = OP.Vn_in*OP.r_op;          % [V] output voltage operation point
        
end


end
