%% Current Controller Design
% ########################################################################
% Design control parameters for a grid-tied inverter
% Description
%   - ACC (converter-side current control)
%   - DVC
%   - PLL
% Input:
%   - [obj] inverter definition
%   - [obj] grid definition
%   - [obj] control definition
%   - [obj] design requirements (ACC,PLL,DVC  BW & PM)
%   - [boolean] print option
%           - '0' for no print
%           - '1' for for transfer function format
%           - '2' for for latex format
% Output:
%   - [obj] designed parameters (ACC,PLL,DVC  Kp & Ki)
%
% Establishment: 25.11.2020 Zhiqing Yang, PGS, RWTH Aachen
% ########################################################################

function Design = Design_Ctrl(Inv,Grid,Ctrl,Req,print_opt)

%% Initialization
% control parameters
T_sp = Ctrl.T_sp;                % [s] sampling period
T_del = 1.5*T_sp;                % [s] pwm latching time + sampling delay
% V_dc = Inv.OP.V_dc;              % [V] dc-link voltage
V_dc = 1500;                     % [V] dc-link voltage defined as max
V_ac_amp = Grid.V_amp;           % [V] grid voltage amplitude

% filter parameters
L1 = Inv.Filter.L1;             % [H] filter inductance in inverter side
R1 = Inv.Filter.R1;             % [Ohm] parasite resistance in L1
C_dc = Inv.Filter.C_dc;         % [F] dc-link capacitance

% parameters for transfer function
s = tf('s');

% transfer function 
G_iv = 1/(s*L1+R1);                 % [] TF i_grid to v_modulation
G_del = (2-s*T_del)/(2+s*T_del);    % [] TF modulator
G_vi = -3/(2*s*C_dc)*V_ac_amp/V_dc; % [] TF v_dc to i_grid_d
G_PD_PLL = V_ac_amp;
G_theta = 1/s;                      % [] TF pll
G_OL_ACC = G_iv*G_del;              % [] TF ACC OL

%% Design of ACC
% design requirements
f_b_ACC = Req.ACC.BW;                % [Hz] crossover frequency
w_b_ACC = 2*pi*f_b_ACC;              % [rad/s] crossover anlge frequency
PM_ACC = Req.ACC.PM;                 % [degree] phase margin

% control design
G_OL_ACC_w = freqresp(G_OL_ACC,w_b_ACC);
G_OL_ACC_w_mag = abs(G_OL_ACC_w);
G_OL_ACC_w_phase = angle(G_OL_ACC_w)*180/pi;
G_OL_ACC_phase = -180+PM_ACC-G_OL_ACC_w_phase;
Design.ACC.Kp = abs(cos(G_OL_ACC_phase*pi/180)/G_OL_ACC_w_mag);           % adjust sign
Design.ACC.Ki = abs(sin(G_OL_ACC_phase*pi/180)/G_OL_ACC_w_mag*w_b_ACC); % adjust sign
G_ACC = Design.ACC.Kp + Design.ACC.Ki/s;
T_OL_ACC = G_ACC*G_OL_ACC;

%% Design of DVC
% design requirements
f_b_DVC = Req.DVC.BW;                 % [Hz] crossover frequency
w_b_DVC = 2*pi*f_b_DVC;               % [rad/s] crossover anlge frequency
PM_DVC = Req.DVC.PM;                  % [degree] phase margin

% control design
T_ACC = feedback(G_ACC*G_OL_ACC,1);
G_OL_DVC = T_ACC*G_vi;
G_OL_DVC_w = freqresp(G_OL_DVC,w_b_DVC);
G_OL_DVC_w_mag = abs(G_OL_DVC_w);
G_OL_DVC_w_phase = angle(G_OL_DVC_w)*180/pi;
G_OL_DVC_phase = -180+PM_DVC-G_OL_DVC_w_phase;
Design.DVC.Kp = -abs(cos(G_OL_DVC_phase*pi/180)/G_OL_DVC_w_mag);              % adjust sign
Design.DVC.Ki = -abs(sin(G_OL_DVC_phase*pi/180)/G_OL_DVC_w_mag*w_b_DVC);       % adjust sign
G_DVC = Design.DVC.Kp + Design.DVC.Ki/s;
T_OL_DVC = G_DVC*G_OL_DVC;

%% Design of PLL
% design requirements
f_b_PLL = Req.PLL.BW;                 % [Hz] crossover frequency
w_b_PLL = 2*pi*f_b_PLL;               % [rad/s] crossover anlge frequency
PM_PLL = Req.PLL.PM;                  % [degree] phase margin
 
% control design
G_OL_PLL = G_PD_PLL*G_theta;
G_OL_PLL_w = freqresp(G_OL_PLL,w_b_PLL);
G_OL_PLL_w_mag = abs(G_OL_PLL_w);
G_OL_PLL_w_phase = angle(G_OL_PLL_w)*180/pi;
G_OL_PLL_phase = -180+PM_PLL-G_OL_PLL_w_phase;
Design.PLL.Kp = cos(G_OL_PLL_phase*pi/180)/G_OL_PLL_w_mag;              % adjust sign
Design.PLL.Ki = -sin(G_OL_PLL_phase*pi/180)/G_OL_PLL_w_mag*w_b_PLL;      % adjust sign
G_PLL = Design.PLL.Kp + Design.PLL.Ki/s;
T_OL_PLL = G_PLL*G_OL_PLL;

%% Present results
% print values
fprintf('Kp_ACC = %f\n',Design.ACC.Kp)
fprintf('Ki_ACC = %f\n',Design.ACC.Ki)
fprintf('Kp_PLL = %f\n',Design.PLL.Kp)
fprintf('Ki_PLL = %f\n',Design.PLL.Ki)
fprintf('Kp_DVC = %f\n',Design.DVC.Kp)
fprintf('Ki_DVC = %f\n',Design.DVC.Ki)

if (print_opt == 1)

% plot option
opts = bodeoptions;
opts.FreqUnits = 'Hz';

figure
hold on 
bodeplot(T_OL_ACC,opts);   
h = findobj(gcf,'type','line');
set(h,'linewidth',2);
bodeplot(T_OL_PLL,opts);   
h = findobj(gcf,'type','line');
set(h,'linewidth',2);
bodeplot(T_OL_DVC,opts);   
h = findobj(gcf,'type','line');
set(h,'linewidth',2);
grid
legend('ACC','PLL','DVC')
title('Frequency Domain Response')
set(findall(gcf,'-property','FontSize'),'FontSize',14)
set(findall(gcf,'-property','Fontname'),'Fontname','Times New Roman')

elseif (print_opt == 2)
    
% TF frequency-domain evaluation
n = 1000;                   % number of evaluated frequencies/points
f = logspace(-2,5,n);       % [Hz] frequencies to be evaluated

% init
T_OL_ACC_f = zeros(1,length(f));
T_OL_PLL_f = zeros(1,length(f));
T_OL_DVC_f = zeros(1,length(f));

for i = 1:n
    T_OL_ACC_f(i) = evalfr(T_OL_ACC,1j*2*pi*f(i));
    T_OL_PLL_f(i) = evalfr(T_OL_PLL,1j*2*pi*f(i));
    T_OL_DVC_f(i) = evalfr(T_OL_DVC,1j*2*pi*f(i));
end

% magnitude
figure
subplot(2,1,1)
hold on
h_1 = plot(f,20*log10(abs(T_OL_ACC_f)),'MarkerSize',5);
h_2 = plot(f,20*log10(abs(T_OL_PLL_f)),'MarkerSize',5);
h_3 = plot(f,20*log10(abs(T_OL_DVC_f)),'MarkerSize',5);
h_4 = plot([10^(-2),10^5],[0,0],'--','MarkerSize',5); 
set(h_1,'linewidth',3,'Color',[64,127,183]/255);
set(h_2,'linewidth',3,'Color',[216,92,65]/255);
set(h_3,'linewidth',3,'Color',[250,190,80]/255);
set(h_4,'linewidth',2,'Color',[156,158,159]/255);
% xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)')
set(gca,'XScale','log')
grid on
box on
xlim([10^(-2),10^5])
% ylim([-40,20]);
set(findall(gcf,'-property','FontSize'),'FontSize',16)
set(findall(gcf,'-property','Fontname'),'Fontname','Times New Roman')
legend('ACC','PLL','DVC');

% phase
subplot(2,1,2)
hold on
h_1 = plot(f,wrapTo180(angle(T_OL_ACC_f)/pi*180),'MarkerSize',5);
h_2 = plot(f,wrapTo180(angle(T_OL_PLL_f)/pi*180),'MarkerSize',5);
h_3 = plot(f,wrapTo180(angle(T_OL_DVC_f)/pi*180),'MarkerSize',5);
h_4 = plot([10^(-2),10^5],[180,180],'--','MarkerSize',5); 
h_5 = plot([10^(-2),10^5],[-180,-180],'--','MarkerSize',5);
set(h_1,'linewidth',3,'Color',[64,127,183]/255);
set(h_2,'linewidth',3,'Color',[216,92,65]/255);
set(h_3,'linewidth',3,'Color',[250,190,80]/255);
set(h_4,'linewidth',2,'Color',[156,158,159]/255);
set(h_5,'linewidth',2,'Color',[156,158,159]/255);
xlabel('Frequency (Hz)');
ylabel('Phase (deg)')
set(gca,'XScale','log')
grid on
box on
xlim([10^(-2),10^5])
ylim([-200,200]);
set(findall(gcf,'-property','FontSize'),'FontSize',16)
set(findall(gcf,'-property','Fontname'),'Fontname','Times New Roman')

% cleanfigure();
% matlab2tikz('Bode_Plot_ACC_PLL_DVC_std_delay.tex')    

else
    return
end

end