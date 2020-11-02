
%% Plot the Operating Point and the Oprating Range
% ########################################################################
% To decide the constant voltage value side and show the operating point and 
%  the operating range of DAB3
%
% Input:
%       - [obj] Parameters of OP
%       - [obj] Parameters of DAB3
%       - [obj] Parameters of Ctrl
% Output:
%       - [] plot the operating point and the operating range of DAB3
%
%
% Establishment: 15.09.2020 Huixue Liu, PGS, RWTH Aachen
% Last change:   25.10.2020 Huixue Liu, PGS, RWTH Aachen
    
% ########################################################################

%% 
function [] = Def_Plot(OP,DAB3,Ctrl)

V_var = [0.0,1.5];                            % [p.u.] voltage at variable side
V_var_aux = [V_var(1):0.05:1,1,1:0.05:V_var(end)];
fix_flag = OP.fix_flag;                       % [ ] set the constant voltage value side

switch fix_flag
    case 'input side' 
        Vi_range = OP.Vn_in;                  % [V] input voltage operation range
        Vo_range = V_var_aux*OP.Vn_out;       % [V] output voltage operation range
        plot_range = Vo_range/OP.Vn_out;      % plot range
        k = find(plot_range == 1);
        k = k(1);
        part_1 = 1:k;
        part_2 = k:length(plot_range);
        
    case 'output side'
        Vi_range = V_var_aux*OP.Vn_in;        % [V] input voltage operation range
        Vo_range = OP.Vn_out;                 % [V] output voltage operation range
        plot_range = Vi_range/Vn_in;          % plot range 
        k = find(plot_range == 1);
        k = k(1);
        part_1 = k:length(plot_range);
        part_2 = 1:k;
end

% generate plot range set
plot_param.range = plot_range;
plot_param.part{1} = part_1;
plot_param.part{2} = part_2;

% generate feedforward calculation parameter set
ff_cal_param.op = [OP.Vi,OP.Vo,DAB3.Ntr,Ctrl.f,DAB3.L,OP.P_op,OP.r_op,OP.Pn,Ctrl.td_in,Ctrl.td_out,Ctrl.td_flag];
ff_cal_param.range{1} = Vi_range;
ff_cal_param.range{2} = Vo_range;

%% region decision and control parameters calculation
[d1,d2,dp,mode] = DAB3_ff_SPS_cal(ff_cal_param,plot_param);

%% Print results
fprintf('The constant voltage value side is: %s\n',fix_flag)
fprintf('Mode = %s\n',mode)
fprintf('d1 = %f\n', d1)
fprintf('d2 = %f\n', d2)
fprintf('dp = %f\n', dp)

end
