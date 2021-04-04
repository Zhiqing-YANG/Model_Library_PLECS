%% Control Definition
% ########################################################################
% Design voltage control parameters for a DAB3 converter
% Input:
%       - [obj] inverter definition
%       - [obj] grid definition
%       - [obj] control definition
%       - [obj] design requirements (ACC,PLL,DVC  BW & PM)
%       - [boolean] print option
%       - '0' for no print
%       - '1' for for transfer function format
%       - '2' for for latex format
% Output:
%       - [obj] designed parameters (ACC,PLL,DVC  Kp & Ki)
% Establishment: 29.03.2021 Zhiqing Yang, PGS, RWTH Aachen
% ########################################################################

function Design = Design_Ctrl(DAB3,Ctrl,Req,print_opt)

%% Initialization
close 

% system parameters
C_out = DAB3.C_out;         % [F] output DC-link capacitor

% control parameters
Ts = Ctrl.T_sp;             % [s] sampling time

%-------------------------------------------
% fCrossover < 1/10 fSampling 
%-------------------------------------------

% parameters for transfer function
s = tf('s');
z = tf('z',Ts);

% inner close-loop transfer function is assumed as one sampling delay
T_MBCC = (2-s*Ts)/(2+s*Ts); 

%% Outer loop voltage controller
% design requirements
f_b_DVC = Req.DVC.BW;           % [Hz] crossover frequency
w_b_DVC = 2*pi*f_b_DVC;         % [rad/s] crossover anlge frequency
PM_DVC = 60;                    % [degree] phase margin

% design in s domain
G_vi = 1/(s*C_out);
G_OL_DVC = G_vi*T_MBCC;
G_OL_w = freqresp(G_OL_DVC,w_b_DVC);
G_OL_DVC_w_mag = abs(G_OL_w);
G_OL_DVC_w_phase = angle(G_OL_w)*180/pi;
G_OL_DVC_phase = -180+PM_DVC-G_OL_DVC_w_phase;
Design.DVC.Kp = abs(cos(G_OL_DVC_phase*pi/180)/G_OL_DVC_w_mag);
Design.DVC.Ki = abs(sin(G_OL_DVC_phase*pi/180)/G_OL_DVC_w_mag*w_b_DVC);
G_DVC = Design.DVC.Kp+Design.DVC.Ki/s;
T_OL_DVC = G_DVC*G_OL_DVC;

%% Present results
% print 
fprintf('Kp_DVC = %f\n',Design.DVC.Kp)
fprintf('Ki_DVC = %f\n',Design.DVC.Ki)

if (print_opt == 1)
    
% plot
opts = bodeoptions;
opts.FreqUnits = 'Hz';

figure
hold on 
bodeplot(T_OL_DVC,opts);   
h = findobj(gcf,'type','line');
set(h,'linewidth',2);
box on
grid on
legend('DVC');
title('Frequency Domain Response')
set(findall(gcf,'-property','FontSize'),'FontSize',12)
set(findall(gcf,'-property','Fontname'),'Fontname','Times New Roman')

elseif (print_opt == 2)
    
% TF frequency-domain evaluation
n = 1000;                   % number of evaluated frequencies/points
f = logspace(-2,5,n);       % [Hz] frequencies to be evaluated

T_OL_DVC_f = zeros(1,length(f));

for i = 1:n
    T_OL_DVC_f(i) = evalfr(T_OL_DVC,1j*2*pi*f(i));
end

% magnitude
figure
subplot(2,1,1)
hold on
h_1 = plot(f,20*log10(abs(T_OL_DVC_f)),'MarkerSize',5);
h_2 = plot([10^(-2),10^5],[0,0],'--','MarkerSize',5); 
set(h_1,'linewidth',3,'Color',[64,127,183]/255);
set(h_2,'linewidth',2,'Color',[156,158,159]/255);
% xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)')
set(gca,'XScale','log')
grid on
box on
xlim([10^(-2),10^5])
% ylim([-40,20]);
set(findall(gcf,'-property','FontSize'),'FontSize',14)
set(findall(gcf,'-property','Fontname'),'Fontname','Times New Roman')
legend('DVC');

% phase
subplot(2,1,2)
hold on
h_1 = plot(f,wrapTo180(angle(T_OL_DVC_f)/pi*180),'MarkerSize',5);
h_2 = plot([10^(-2),10^5],[180,180],'--','MarkerSize',5); 
h_3 = plot([10^(-2),10^5],[-180,-180],'--','MarkerSize',5);
set(h_1,'linewidth',3,'Color',[64,127,183]/255);
set(h_2,'linewidth',2,'Color',[156,158,159]/255);
set(h_3,'linewidth',2,'Color',[156,158,159]/255);
xlabel('Frequency (Hz)');
ylabel('Phase (deg)')
set(gca,'XScale','log')
grid on
box on
xlim([10^(-2),10^5])
ylim([-200,200]);
set(findall(gcf,'-property','FontSize'),'FontSize',14)
set(findall(gcf,'-property','Fontname'),'Fontname','Times New Roman')

else
    return
end

end