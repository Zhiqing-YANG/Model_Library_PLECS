%% Current Controller Design
% ########################################################################
% Design control parameters for a grid-tied inverter
% Description
%   - ACC (converter-side current control)
%   - DVC
%   - PLL
% Input:
%   - [obj] inverter parameter 
%   - [V] max dc voltage
%   - [obj] grid parameter 
%   - [obj] ACC design requirement (BW in Hz and PM in deg)
%   - [obj] DVC design requirement (BW and PM)
%   - [obj] PLL design requirement (BW and PM)
%   - [boolean] print option, '1' for print, '0' for no print
% Output:
%   - [obj] ACC designed parameter (Kp and Ki)
%   - [obj] DVC designed parameter (Kp and Ki)
%   - [obj] PLL designed parameter (Kp and Ki)
%
% Establishment: 22.07.2019 Zhiqing Yang, PGS, RWTH Aachen
% Last change:   22.07.2019 Zhiqing Yang, PGS, RWTH Aachen
% ########################################################################

function [ACC,DVC,PLL] = Design_Ctrl(Inv,V_dc_max,Grid,ACC_req,DVC_req,PLL_req,print_opt)

%% Initialization
% control parameters
T_sp = Inv.T_sp;                    % [s] sampling period
T_del = 1.5*T_sp;                   % [s] pwm latching time + sampling delay
V_dc = V_dc_max;                    % [V] dc-link voltage
V_ac_amp = sqrt(2/3)*Grid.V_rms_l;  % [V] grid voltage amplitude

% filter parameters
L1 = Inv.Filter.L1;         % [H] filter inductance in inverter side
R1 = Inv.Filter.R1;         % [Ohm] parasite resistance in inverter side
C_dc = Inv.Filter.C_dc;     % [F] dc-link capacitance

% parameters for transfer function
s = tf('s');

% transfer function 
G_iv = 1/(s*L1+R1);                 % [] TF i_grid to v_modulation
G_del = (2-s*T_del)/(2+s*T_del);    % [] TF modulator
G_vi = -3/(2*s*C_dc)*V_ac_amp/V_dc; % [] TF v_dc to i_grid_d
G_PD_PLL = V_ac_amp;
G_theta = 1/s;                      % [] TF pll
G_OL_ACC = G_iv*G_del;               % [] TF ACC OL

%% Design of ACC
% design requirements
f_b_ACC = ACC_req.BW;                % [Hz] crossover frequency
w_b_ACC = 2*pi*f_b_ACC;               % [rad/s] crossover anlge frequency
PM_ACC = ACC_req.PM;                 % [degree] phase margin

% control design
G_OL_ACC_w = freqresp(G_OL_ACC,w_b_ACC);
G_OL_ACC_w_mag = abs(G_OL_ACC_w);
G_OL_ACC_w_phase = angle(G_OL_ACC_w)*180/pi;
G_OL_ACC_phase = -180+PM_ACC-G_OL_ACC_w_phase;
ACC.Kp = abs(cos(G_OL_ACC_phase*pi/180)/G_OL_ACC_w_mag);           % adjust sign
ACC.Ki = abs(sin(G_OL_ACC_phase*pi/180)/G_OL_ACC_w_mag*w_b_ACC); % adjust sign
G_ACC = ACC.Kp + ACC.Ki/s;
T_OL_ACC = G_ACC*G_OL_ACC;

%% Design of DVC
% design requirements
f_b_DVC = DVC_req.BW;                 % [Hz] crossover frequency
w_b_DVC = 2*pi*f_b_DVC;              % [rad/s] crossover anlge frequency
PM_DVC = DVC_req.PM;                        % [degree] phase margin

% control design
T_ACC = feedback(G_ACC*G_OL_ACC,1);
G_OL_DVC = T_ACC*G_vi;
G_OL_DVC_w = freqresp(G_OL_DVC,w_b_DVC);
G_OL_DVC_w_mag = abs(G_OL_DVC_w);
G_OL_DVC_w_phase = angle(G_OL_DVC_w)*180/pi;
G_OL_DVC_phase = -180+PM_DVC-G_OL_DVC_w_phase;
DVC.Kp = -abs(cos(G_OL_DVC_phase*pi/180)/G_OL_DVC_w_mag);              % adjust sign
DVC.Ki = -abs(sin(G_OL_DVC_phase*pi/180)/G_OL_DVC_w_mag*w_b_DVC);       % adjust sign
G_DVC = DVC.Kp + DVC.Ki/s;
T_OL_DVC = G_DVC*G_OL_DVC;

%% Design of PLL
% design requirements
f_b_PLL = PLL_req.BW;                 % [Hz] crossover frequency
w_b_PLL = 2*pi*f_b_PLL;               % [rad/s] crossover anlge frequency
PM_PLL = PLL_req.PM;                  % [degree] phase margin
 
% control design
G_OL_PLL = G_PD_PLL*G_theta;
G_OL_PLL_w = freqresp(G_OL_PLL,w_b_PLL);
G_OL_PLL_w_mag = abs(G_OL_PLL_w);
G_OL_PLL_w_phase = angle(G_OL_PLL_w)*180/pi;
G_OL_PLL_phase = -180+PM_PLL-G_OL_PLL_w_phase;
PLL.Kp = cos(G_OL_PLL_phase*pi/180)/G_OL_PLL_w_mag;              % adjust sign
PLL.Ki = -sin(G_OL_PLL_phase*pi/180)/G_OL_PLL_w_mag*w_b_PLL;      % adjust sign
G_PLL = PLL.Kp + PLL.Ki/s;
T_OL_PLL = G_PLL*G_OL_PLL;

%% Present results
% print 
if (print_opt == 1)
fprintf('Kp_CC = %f\n',ACC.Kp)
fprintf('Ki_CC = %f\n',ACC.Ki)
fprintf('Kp_VC = %f\n',DVC.Kp)
fprintf('Ki_VC = %f\n',DVC.Ki)
fprintf('Kp_PLL = %f\n',PLL.Kp)
fprintf('Ki_PLL = %f\n',PLL.Ki)

% plot
opts = bodeoptions;
opts.FreqUnits = 'Hz';

figure
hold on 
bodeplot(T_OL_ACC,opts);   
h = findobj(gcf,'type','line');
set(h,'linewidth',2);
bodeplot(T_OL_DVC,opts);   
h = findobj(gcf,'type','line');
set(h,'linewidth',2);
bodeplot(T_OL_PLL,opts);   
h = findobj(gcf,'type','line');
set(h,'linewidth',2);
grid
legend('ACC','DVC','PLL')
title('Frequency Domain Response')
set(gca,'FontSize',14,'Fontname','Times New Roman');
else
    return
end

end