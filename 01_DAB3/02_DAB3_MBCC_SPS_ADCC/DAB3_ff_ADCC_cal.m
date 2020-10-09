%% DAB3 Feedforward Calculation
% ########################################################################
% to calculate phase shift and duty cycle of ADCC (bidirectional)

% Establishment: 28.12.2016 Zhiqing Yang, PGS, RWTH Aachen
% Last change:   28.12.2016 Zhiqing Yang, PGS, RWTH Aachen
    
% ########################################################################
function [d1,d2,dp,mode] = DAB3_ff_ADCC_cal(ff_cal_param,plot_param)

% parameter abstraction
Vi = ff_cal_param.op(1);
Vo = ff_cal_param.op(2);
Ntr = ff_cal_param.op(3);
f =ff_cal_param.op(4);
L = ff_cal_param.op(5);
P_op = ff_cal_param.op(6);
r_op = ff_cal_param.op(7);
Pn = ff_cal_param.op(8);
td_in = ff_cal_param.op(9);
td_out = ff_cal_param.op(10);
td_mode = ff_cal_param.op(11);
td_flag = ff_cal_param.op(12);
zcs_rel = ff_cal_param.op(13);
Pref = Pn*P_op;
w = 2*pi*f;

Vi_range = ff_cal_param.range{1};
Vo_range = ff_cal_param.range{2};

plot_range = plot_param.range;
part_1 = plot_param.part{1};
part_2 = plot_param.part{2};

% color definition
col_b = [0    0.4470    0.7410];             % blue
col_r = [0.8500    0.3250    0.0980];        % red
col_y = [0.9290    0.6940    0.1250];        % yellow
col_p = [0.4940    0.1840    0.5560];        % purple
col_g = [0    0.5977    0.2969];             % green
col_lb = [0.3010    0.7450    0.9330];       % light blue
col_br = [0.6350    0.0780    0.1840];       % brown
col_k = [0    0    0];                       % black
col_w = [1    1    1];                       % white
col_gr = [0.7500,   0.7500,   0.7500];       % gray

% boundary calculations
P_SPS_1_max_op = (pi*Ntr*Vi*Vo)/(6*L*w); 
P_SPS_1_input_boundary_op = -(2*pi*Vi*(- Ntr^2*Vo^2 + Vi^2))/(9*L*Ntr*Vo*w);
P_SPS_1_output_boundary_op = (2*Ntr*pi*Vo*(- Ntr^2*Vo^2 + Vi^2))/(9*L*Vi*w);
P_ADCC_TRI_BUCK_max_op = -(2*Ntr^2*pi*Vo^2*((Ntr*Vo)/Vi - 1))/(9*L*w);
P_ADCC_TRI_BOOST_max_op = -(2*pi*Vi^2*(Vi - Ntr*Vo))/(9*L*Ntr*Vo*w);  
P_ADCC_TRAP_max_op = (2*Ntr^2*pi*Vi^2*Vo^2)/(9*L*w*(Ntr^2*Vo^2 + Ntr*Vi*Vo + Vi^2));
P_SPS_neg_1_max_op = -(pi*Ntr*Vi*Vo)/(6*L*w);  
P_SPS_neg_1_output_boundary_op = -(2*Ntr*pi*Vo*(- Ntr^2*Vo^2 + Vi^2))/(9*L*Vi*w);
P_SPS_neg_1_input_boundary_op = (2*pi*Vi*(- Ntr^2*Vo^2 + Vi^2))/(9*L*Ntr*Vo*w);
P_ADCC_TRI_BUCK_neg_max_op = (2*Ntr^2*pi*Vo^2*((Ntr*Vo)/(3*Vi) - 1/3))/(3*L*w);
P_ADCC_TRI_BOOST_neg_max_op = (2*pi*Vi^2*(Vi - Ntr*Vo))/(9*L*Ntr*Vo*w);
P_ADCC_TRAP_neg_max_op = -(2*Ntr^2*pi*Vi^2*Vo^2)/(9*L*w*(Ntr^2*Vo^2 + Ntr*Vi*Vo + Vi^2));

% feedforward parameters calculation
if (Pref >= 0)
    if (Pref < P_ADCC_TRI_BUCK_max_op)
        mode = 'ADCC TRI BUCK';
        d1 = (2^(1/2)*(-L)^(1/2)*Pref^(1/2)*w^(1/2))/(2*pi^(1/2)*Vi^(1/2)*(Ntr*Vo - Vi)^(1/2));
        d2 = d1/(Ntr*Vo/Vi);
        dp = 0; 
        % deadtime compensation
        if (td_flag == 1)
            d1 = d1+td_in*f;
            if (td_mode == 1)
                dp = dp+td_in*f; 
            elseif (td_mode == 2)
                dp = dp+td_out*f;
            else
                dp = dp+(td_in+td_out)*f/2;
            end
        end
    elseif (Pref < P_ADCC_TRI_BOOST_max_op)
        mode = 'ADCC TRI BOOST';
        d1 = (2^(1/2)*L^(1/2)*Ntr^(1/2)*Pref^(1/2)*Vo^(1/2)*w^(1/2))/(2*pi^(1/2)*Vi*(Ntr*Vo - Vi)^(1/2));
        d2 = d1/(Ntr*Vo/Vi);
        dp = d1-d2;
        % deadtime compensation
        if (td_flag == 1)
            if (td_mode == 1)
                dp = dp+td_in*f;
            elseif (td_mode == 2)
                dp = dp+td_out*f;
            else
                dp = dp+(td_in+td_out)*f/2;
            end
        end
    elseif (Pref <= P_ADCC_TRAP_max_op)
        mode = 'ADCC TRAP';
        d1 = (Ntr*Vo*(4*pi^(1/2)*Vi^2 + 2*2^(1/2)*(-(Vi*(- 2*pi*Ntr^2*Vi^2*Vo^2 + 9*L*Pref*w*Ntr^2*Vo^2 + 9*L*Pref*w*Ntr*Vi*Vo + 9*L*Pref*w*Vi^2))/(Ntr*Vo))^(1/2) + 4*Ntr*pi^(1/2)*Vi*Vo))/(12*pi^(1/2)*(Ntr^2*Vi*Vo^2 + Ntr*Vi^2*Vo + Vi^3));
        d2 = d1/(Ntr*Vo/Vi);
        dp = 1/3-d2; 
        % deadtime compensation
        if (td_flag == 1)
            d1 = d1+td_in*f;
            if (td_mode == 1)
                dp = dp+td_in*f;
            elseif (td_mode == 2)
                dp = dp+td_out*f;
            else
                dp = dp+(td_in+td_out)*f/2;
            end
        end
    elseif (Pref <= P_SPS_1_max_op)
        mode = 'SPS 1';
        d1 = 0.5;
        d2 = 0.5;
        dp =  -(2^(1/2)*(-Ntr*Vi*Vo*(9*L*Pref*w - 2*pi*Ntr*Vi*Vo))^(1/2) - 2*Ntr*pi^(1/2)*Vi*Vo)/(6*Ntr*pi^(1/2)*Vi*Vo);
        % dead time compensation
        if (td_flag == 1)
            if (Pref <= P_SPS_1_input_boundary_op)
                % compensation if input hard-switching
                if (td_mode == 1)
                    dp = dp+td_in*f;
                elseif (td_mode == 2)
                    dp = dp+td_out*f;
                else
                    dp = dp+(td_in+td_out)*f/2;
                end
           elseif (Pref <= P_SPS_1_output_boundary_op)
                % compensation if output hard-switching
                if (td_mode == 1)
                    dp = dp-td_out*f;
                elseif (td_mode == 2)
                    dp = dp-td_in*f;
                else
                    dp = dp-(td_in+td_out)*f/2;
                end
            else   
                % compensation if soft-switching
                if (td_mode == 1)
                    dp = dp+0*f;
                elseif (td_mode == 2)
                    dp = dp-(td_in-td_out)*f;
                else
                    dp = dp-(td_in-td_out)*f/2;
                end
            end
        end
    else
        mode = 'SPS 1 max';
        d1 = 0.5;
        d2 = 0.5;
        dp = 1/6;
        % deadtime compensation
        if (td_flag == 1)
            % compensation if soft-switching
            if (td_mode == 1)
                dp = dp+0*f;
            elseif (td_mode == 2)
                dp = dp-(td_in-td_out)*f;
            else
                dp = dp-(td_in-td_out)*f/2;
            end
        end
    end 
else
    if (Pref >= P_ADCC_TRI_BUCK_neg_max_op) 
        mode = 'ADCC TRI BUCK negative';
        d1 = (2^(1/2)*L^(1/2)*Pref^(1/2)*w^(1/2))/(2*pi^(1/2)*Vi^(1/2)*(Ntr*Vo - Vi)^(1/2));
        d2 = d1/(Ntr*Vo/Vi);
        dp = d1-d2;
        % deadtime compensation
        if (td_flag == 1)
            if (td_mode == 1)
                dp = dp-td_out*f;
            elseif (td_mode == 2)
                dp = dp-td_in*f;
            else
                dp = dp-(td_in+td_out)*f/2;
            end
        end
    elseif (Pref >= P_ADCC_TRI_BOOST_neg_max_op) 
        mode = 'ADCC TRI BOOST negative';
        d1 = -(2^(1/2)*(-L)^(1/2)*Ntr^(1/2)*Pref^(1/2)*Vo^(1/2)*w^(1/2))/(2*pi^(1/2)*Vi*(Ntr*Vo - Vi)^(1/2));
        d2 = d1/(Ntr*Vo/Vi);
        dp = 0;
        % deadtime compensation
        if (td_flag == 1)
            d2 = d2+td_out*f;
            if (td_mode == 1)
                dp = dp-td_out*f;
            elseif (td_mode == 2)
                dp = dp-td_in*f;
            else
                dp = dp-(td_in+td_out)*f/2;
            end
        end
    elseif (Pref >= P_ADCC_TRAP_neg_max_op)
        mode = 'ADCC TRAP negative';
        d1 = (Ntr*Vo*(4*pi^(1/2)*Vi^2 + 2*2^(1/2)*((Vi*(2*pi*Ntr^2*Vi^2*Vo^2 + 9*L*Pref*w*Ntr^2*Vo^2 + 9*L*Pref*w*Ntr*Vi*Vo + 9*L*Pref*w*Vi^2))/(Ntr*Vo))^(1/2) + 4*Ntr*pi^(1/2)*Vi*Vo))/(12*pi^(1/2)*(Ntr^2*Vi*Vo^2 + Ntr*Vi^2*Vo + Vi^3));
        d2 = d1/(Ntr*Vo/Vi);
        dp = d1-1/3; 
        % deadtime compensation
        if (td_flag == 1)
            if (td_mode == 1)
                dp = dp-td_out*f;
            elseif (td_mode == 2)
                dp = dp-td_in*f;
            else
                dp = dp-(td_in+td_out)*f/2;
            end
        end
    elseif (Pref >= P_SPS_neg_1_max_op)
        mode = 'SPS negative 1 ';
        d1 = 0.5;
        d2 = 0.5;
        dp =  (2^(1/2)*(Ntr*Vi*Vo*(9*L*Pref*w + 2*pi*Ntr*Vi*Vo))^(1/2) - 2*Ntr*pi^(1/2)*Vi*Vo)/(6*Ntr*pi^(1/2)*Vi*Vo);
        % deadtime compensation
        if (td_flag == 1)
            if (Pref >= P_SPS_neg_1_output_boundary_op)
                % compensation if input hard-switching
                if (td_mode == 1)
                    dp = dp-td_out*f;
                elseif (td_mode == 2)
                    dp = dp-td_in*f;
                else
                    dp = dp-(td_in+td_out)*f/2;
                end
            elseif (Pref >= P_SPS_neg_1_input_boundary_op)
                % compensation if output hard-switching
                if (td_mode == 1)
                    dp = dp+td_in*f;
                elseif (td_mode == 2)
                    dp = dp+td_out*f;
                else
                    dp = dp+(td_in+td_out)*f/2;
                end
            else
                % compensation if soft-switching
                if (td_mode == 1)
                    dp = dp+0;
                elseif (td_mode == 2)
                    dp = dp-(td_in-td_out)*f;
                else
                    dp = dp-(td_in-td_out)*f/2;
                end
            end
        end    
    else
        mode = 'SPS negative 1 max';
        d1 = 0.5;
        d2 = 0.5;
        dp = -1/6;   
        % deadtime compensation
        if (td_flag == 1)
            % compensation if soft-switching
            if (td_mode == 1)
                dp = dp+0;
            elseif (td_mode == 2)
                dp = dp-(td_in-td_out)*f;
            else
                dp = dp-(td_in-td_out)*f/2;
            end
        end
    end 
end

% plot boundary
P_SPS_1_max = (pi.*Ntr.*Vi_range.*Vo_range)./(6.*L.*w);                  
P_SPS_1_input_boundary = -(2.*pi.*Vi_range.*(- Ntr.^2.*Vo_range.^2 + Vi_range.^2))./(9.*L.*Ntr.*Vo_range.*w);
P_SPS_1_output_boundary = (2.*Ntr.*pi.*Vo_range.*(- Ntr.^2.*Vo_range.^2 + Vi_range.^2))./(9.*L.*Vi_range.*w);
P_ADCC_TRI_BUCK_max = -(2.*Ntr.^2.*pi.*Vo_range.^2.*((Ntr.*Vo_range)./Vi_range - 1))./(9.*L.*w);
P_ADCC_TRI_BOOST_max = -(2.*pi.*Vi_range.^2.*(Vi_range - Ntr.*Vo_range))./(9.*L.*Ntr.*Vo_range.*w);  
P_ADCC_TRAP_max = (2.*Ntr.^2.*pi.*Vi_range.^2.*Vo_range.^2)./(9.*L.*w.*(Ntr.^2.*Vo_range.^2 + Ntr.*Vi_range.*Vo_range + Vi_range.^2));
P_SPS_neg_1_max = -(pi.*Ntr.*Vi_range.*Vo_range)./(6.*L.*w);           
P_SPS_neg_1_output_boundary = -(2.*Ntr.*pi.*Vo_range.*(- Ntr.^2.*Vo_range.^2 + Vi_range.^2))./(9.*L.*Vi_range.*w);
P_SPS_neg_1_input_boundary = (2.*pi.*Vi_range.*(- Ntr.^2.*Vo_range.^2 + Vi_range.^2))./(9.*L.*Ntr.*Vo_range.*w);
P_ADCC_TRI_BUCK_neg_max = (2.*Ntr.^2.*pi.*Vo_range.^2.*((Ntr.*Vo_range)./(3.*Vi_range) - 1./3))./(3.*L.*w);
P_ADCC_TRI_BOOST_neg_max = (2.*pi.*Vi_range.^2.*(Vi_range - Ntr.*Vo_range))./(9.*L.*Ntr.*Vo_range.*w);
P_ADCC_TRAP_neg_max = -(2.*Ntr.^2.*pi.*Vi_range.^2.*Vo_range.^2)./(9.*L.*w.*(Ntr.^2.*Vo_range.^2 + Ntr.*Vi_range.*Vo_range + Vi_range.^2)); 

% plot
figure 
hold on 
max_pt = max(P_SPS_1_max/Pn);
if (Pref >= 0)
    plot(plot_range,P_SPS_1_max/Pn,'Color',col_r,'LineWidth',2);  
    plot(plot_range(part_1),P_ADCC_TRI_BUCK_max(part_1)/Pn,'Color',col_g,'LineWidth',2);  
    plot(plot_range(part_2),P_ADCC_TRI_BOOST_max(part_2)/Pn,'Color',col_lb,'LineWidth',2);  
    plot(plot_range,P_ADCC_TRAP_max/Pn,'Color',col_b,'LineWidth',2);
    plot(plot_range(part_2),P_SPS_1_input_boundary(part_2)/Pn,'Color',col_k,'LineWidth',2,'LineStyle','--');  
    plot(plot_range(part_1),P_SPS_1_output_boundary(part_1)/Pn,'Color',col_k,'LineWidth',2,'LineStyle',':'); 
    axis([plot_range(1),plot_range(end),0,max_pt]);
else
    plot(plot_range,P_SPS_neg_1_max/Pn,'Color',col_r,'LineWidth',2)
    plot(plot_range(part_1),P_ADCC_TRI_BUCK_neg_max(part_1)/Pn,'Color',col_g,'LineWidth',2);  
    plot(plot_range(part_2),P_ADCC_TRI_BOOST_neg_max(part_2)/Pn,'Color',col_lb,'LineWidth',2);  
    plot(plot_range,P_ADCC_TRAP_neg_max/Pn,'Color',col_b,'LineWidth',2);
    plot(plot_range(part_2),P_SPS_neg_1_input_boundary(part_2)/Pn,'Color',col_k,'LineWidth',2,'LineStyle','--');  
    plot(plot_range(part_1),P_SPS_neg_1_output_boundary(part_1)/Pn,'Color',col_k,'LineWidth',2,'LineStyle',':');     
    axis([plot_range(1),plot_range(end),-max_pt,0]);
end
xlabel('Voltage Variation in p.u.');
ylabel('Transferred Power P in p.u.');
grid
title('Operation Map');
legend({'Pmax SPS 1','Pmax ADCC Tri-Buck','Pmax ADCC Tri-Boost','Pmax ADCC Trap','SPS ZVS Input Boundary','SPS ZVS Output Boundary'},'Location','northwest');
% mark operation Point
plot(r_op, Pref/Pn, 'or','Markersize',7.5,'MarkerFaceColor','r','DisplayName','Operating Point')
hold off

end