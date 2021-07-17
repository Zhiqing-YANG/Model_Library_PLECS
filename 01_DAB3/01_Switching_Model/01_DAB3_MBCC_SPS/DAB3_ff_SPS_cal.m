%% DAB3 Feedforward Calculation
% ########################################################################
% to calculate phase shift and duty cycle of SPS

% Establishment: 28.12.2016 Zhiqing Yang, PGS, RWTH Aachen
% Last change:   28.12.2016 Zhiqing Yang, PGS, RWTH Aachen
    
% ########################################################################
function [d1,d2,dp,mode] = DAB3_ff_SPS_cal(ff_cal_param,plot_param)

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
td_flag = ff_cal_param.op(11);

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

% operation boundary calculations
P_SPS_1_max_op = (pi*Ntr*Vi*Vo)/(6*L*w);                  
P_SPS_1_input_boundary_op = -(2*pi*Vi*(- Ntr^2*Vo^2 + Vi^2))/(9*L*Ntr*Vo*w);
P_SPS_1_output_boundary_op = (2*Ntr*pi*Vo*(- Ntr^2*Vo^2 + Vi^2))/(9*L*Vi*w);
P_SPS_neg_1_max_op = -(pi*Ntr*Vi*Vo)/(6*L*w);  
P_SPS_neg_1_output_boundary_op = -(2*Ntr*pi*Vo*(- Ntr^2*Vo^2 + Vi^2))/(9*L*Vi*w);
P_SPS_neg_1_input_boundary_op = (2*pi*Vi*(- Ntr^2*Vo^2 + Vi^2))/(9*L*Ntr*Vo*w);


% feedforward parameters calculation
if (Pref >= 0)
    if (Pref <= P_SPS_1_max_op)
        mode = 'SPS 1';
        d1 = 0.5;
        d2 = d1;
        dp =  -(2^(1/2)*(-Ntr*Vi*Vo*(9*L*Pref*w - 2*pi*Ntr*Vi*Vo))^(1/2) - 2*Ntr*pi^(1/2)*Vi*Vo)/(6*Ntr*pi^(1/2)*Vi*Vo);
        % dead time compensation
        if (td_flag == 1)
            if (Pref <= P_SPS_1_input_boundary_op)
                % compensation if input hard-switching      
                    dp = dp+td_in*f;  
           elseif (Pref <= P_SPS_1_output_boundary_op)
                % compensation if output hard-switching
                    dp = dp-td_out*f;   
            else   
                % compensation if soft-switching
                    dp = dp+0*f;
            end
        end
    else
        mode = 'SPS 1 max';
        d1 = 0.5;
        d2 = d1;
        dp = 1/6;  
        % deadtime compensation
        if (td_flag == 1)
            % compensation if soft-switching
                dp = dp+0*f;
        end
    end
else
    if (Pref >= P_SPS_neg_1_max_op)
        mode = 'SPS negative 1';
        d1 = 0.5;
        d2 = 0.5;
        dp =  (2^(1/2)*(Ntr*Vi*Vo*(9*L*Pref*w + 2*pi*Ntr*Vi*Vo))^(1/2) - 2*Ntr*pi^(1/2)*Vi*Vo)/(6*Ntr*pi^(1/2)*Vi*Vo);
        % deadtime compensation
        if (td_flag == 1)
            if (Pref >= P_SPS_neg_1_output_boundary_op)
                % compensation if input hard-switching
                    dp = dp-td_out*f;
            elseif (Pref >= P_SPS_neg_1_input_boundary_op)
                % compensation if output hard-switching
                    dp = dp+td_in*f;
            else
                % compensation if soft-switching
                    dp = dp+0;
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
                dp = dp+0;
        end
    end
end

% plot boundary calculation
P_SPS_1_max = (pi.*Ntr.*Vi_range.*Vo_range)./(6.*L.*w);                  
P_SPS_1_input_boundary = -(2.*pi.*Vi_range.*(- Ntr.^2.*Vo_range.^2 + Vi_range.^2))./(9.*L.*Ntr.*Vo_range.*w);
P_SPS_1_output_boundary = (2.*Ntr.*pi.*Vo_range.*(- Ntr.^2.*Vo_range.^2 + Vi_range.^2))./(9.*L.*Vi_range.*w);
P_SPS_neg_1_max = -(pi.*Ntr.*Vi_range.*Vo_range)./(6.*L.*w);           
P_SPS_neg_1_output_boundary = -(2.*Ntr.*pi.*Vo_range.*(- Ntr.^2.*Vo_range.^2 + Vi_range.^2))./(9.*L.*Vi_range.*w);
P_SPS_neg_1_input_boundary = (2.*pi.*Vi_range.*(- Ntr.^2.*Vo_range.^2 + Vi_range.^2))./(9.*L.*Ntr.*Vo_range.*w);


% plot
figure 
hold on
max_pt = max(P_SPS_1_max/abs(Pn));
if (Pref >= 0)
    plot(plot_range,P_SPS_1_max/Pn,'Color',col_r,'LineWidth',2);  
    plot(plot_range(part_2),P_SPS_1_input_boundary(part_2)/Pn,'Color',col_k,'LineWidth',2,'LineStyle','--');  
    plot(plot_range(part_1),P_SPS_1_output_boundary(part_1)/Pn,'Color',col_k,'LineWidth',2,'LineStyle',':');  
    axis([plot_range(1),plot_range(end),0,max_pt]);
else
    plot(plot_range,P_SPS_neg_1_max/Pn,'Color',col_r,'LineWidth',2)
    plot(plot_range(part_2),P_SPS_neg_1_input_boundary(part_2)/Pn,'Color',col_k,'LineWidth',2,'LineStyle','--');  
    plot(plot_range(part_1),P_SPS_neg_1_output_boundary(part_1)/Pn,'Color',col_k,'LineWidth',2,'LineStyle',':');  
    axis([plot_range(1),plot_range(end),-max_pt,0]);
end
xlabel('Voltage Variation in p.u.');
ylabel('Transferred Power P in p.u.');
xlim([0.5,1.5]);
legend({'Pmax SPS Mode a','SPS ZVS Input Boundary','SPS ZVS Output Boundary'},'Location','northwest');
grid on
box on
title('Operation Map');
set(gca,'FontSize',14,'Fontname','Times New Roman');

% mark operation Point
plot(r_op, Pref/Pn, 'or','Markersize',7.5,'MarkerFaceColor','r','DisplayName','Operating Point');
hold off

end