
%% Set the Fix-Flag and Plot Operating Point and Oprating Range
% ########################################################################
% To decide the constant voltage value side and set operating point for DAB3
%
% operation flag selections:
%         1: SPS
%         2: ADCC
%         3: IADCC
% Input:
%       - [obj] DAB3
%       - [obj] Ctrl
%       - [] fix_flag(set the constant voltage value side): 'input side'
%                                                           'output side'
% Output:
%       - [V] Vi: the input voltage of dc-dc converter
%       - [V] Vo: the output voltage of dc-dc converter
%       - [] plot the operating point and operating range
%
% Establishment: 15.09.2020 Huixue Liu, PGS, RWTH Aachen
% Last change:   15.09.2020 Huixue Liu, PGS, RWTH Aachen
% ########################################################################


%% To decide the constant voltage value side
function OP = Def_Plot_OP_Range(DAB3,Ctrl)
% define voltage ranges
V_fix = 1000;                              % [V] voltage at fixed side
r_op = 1.2;                                % voltage ratio w.r.t. Vn_in or Vn_out 
V_var = [0.0,1.5];                         % [p.u.] voltage at variable side
fix_flag = 'input';                        % 'input': input voltage fixed
                                           % 'output': output voltage fixed
                                          
% generate plot range                                         
V_var_aux = [V_var(1):0.05:1,1,1:0.05:V_var(end)];

switch fix_flag
    case 'input' 
        Vn_in = V_fix;                     % [V] input nominal volage
        Vn_out = V_fix/DAB3.Ntr;           % [V] output nominal voltage
        OP.Vi = Vn_in;                        % [V] input voltage operation point          
        OP.Vo = Vn_out*r_op;                  % [V] output voltage operation point
        Vi_range = Vn_in;                  % [V] input voltage operation range
        Vo_range = V_var_aux*Vn_out;       % [V] output voltage operation range
        plot_range = Vo_range/Vn_out;      % plot range
        k = find(plot_range == 1);
        k = k(1);
        part_1 = 1:k;
        part_2 = k:length(plot_range);
    case 'output'
        Vn_out = V_fix;                    % [V] input nominal volage
        Vn_in = V_fix*DAB3.Ntr;            % [V] output nominal voltage
        OP.Vo = Vn_out;                    % [V] input voltage operation point          
        OP.Vi = Vn_out*r_op*DAB3.Ntr;       % [V] output voltage operation point
        Vi_range = V_var_aux*Vn_in;        % [V] input voltage operation range
        Vo_range = Vn_out;                 % [V] output voltage operation range
        plot_range = Vi_range/Vn_in;       % plot range 
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
ff_cal_param.op = [OP.Vi,OP.Vo,DAB3.Ntr,Ctrl.f,DAB3.L,Ctrl.P_op,r_op,Ctrl.Pn,Ctrl.td_in,Ctrl.td_out,Ctrl.td_mode,Ctrl.td_flag,Ctrl.zcs_rel];
ff_cal_param.range{1} = Vi_range;
ff_cal_param.range{2} = Vo_range;

%% region decision and control parameters calculation
switch Ctrl.OP_flag
    
    case 1
        [d1,d2,dp,mode] = DAB3_ff_SPS_cal(ff_cal_param,plot_param);
        
    case 2
        [d1,d2,dp,mode] = DAB3_ff_ADCC_cal(ff_cal_param,plot_param);
        
    case 3
        [d1,d2,dp,mode] = DAB3_ff_IADCC_cal(ff_cal_param,plot_param);
   
    otherwise
        error('wrong operation mode');
end

%% Print results
fprintf('The constant voltage value side is: %s\n',fix_flag)
fprintf('Mode = %s\n',mode)
fprintf('d1 = %f\n', d1)
fprintf('d2 = %f\n', d2)
fprintf('dp = %f\n', dp)

end
