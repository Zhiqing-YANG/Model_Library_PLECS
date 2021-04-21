%% Passivity Plot 
% ########################################################################
% Impedance Model Passivity Plot 
% Establishment: 28.11.2020 Jiani He, PGS, RWTH Aachen
% Last Change:   15.01.2021 Jiani He, PGS, RWTH Aachen
% ########################################################################

% load system
addpath('System/');
eval('Def_System');

% frequency range
fi=0;
ff=4;
n_sample=1000;
f_swp = logspace(fi,ff,n_sample);

% change system parameters
Ctrl.ACC.K_VFF = 2*pi*3000;        % [] filter bandwidth of VFF 

% case 1
Ctrl.VDC.Gqq.Kp = 2;
Ctrl.VDC.Gqq.Ki = 2500;
Ctrl.VDC.Gdd.Kp = 4;
Ctrl.VDC.Gdd.Ki = 0;
[Z_inv_1,Y_inv_1,Z_pcc_1,Y_pcc_1,Z_g_1,Y_g_1] = IM_INV_2L_ACC_PLL_DVC_VDC(Grid,Inv,Ctrl,f_swp);

% case 2
Ctrl.VDC.Gqq.Kp = 0;
Ctrl.VDC.Gqq.Ki = 0;
Ctrl.VDC.Gdd.Kp = 0;
Ctrl.VDC.Gdd.Ki = 0;
[Z_inv_2,Y_inv_2,Z_pcc_2,Y_pcc_2,Z_g_2,Y_g_2] = IM_INV_2L_ACC_PLL_DVC_VDC(Grid,Inv,Ctrl,f_swp);

% case 3

[Z_inv_3,Y_inv_3,Z_pcc_3,Y_pcc_3,Z_g_3,Y_g_3] = IM_INV_2L_ACC_PLL_DVC_VDC(Grid,Inv,Ctrl,f_swp);

%% Passivity Plot
% load color template
eval('Def_Color');

figure()

subplot(2,2,1)
hold on 
% case 1
h_1 = plot(f_swp,real(Y_inv_1.dd),'-','MarkerSize',5);  
set(h_1,'linewidth',1.5,'Color',blue75);
% case 2
h_2 = plot(f_swp,real(Y_inv_2.dd),'-','MarkerSize',5);  
set(h_2,'linewidth',1.5,'Color',pink75);
% case 3
h_3 = plot(f_swp,real(Y_inv_3.dd),'-','MarkerSize',5);  
set(h_3,'linewidth',1.5,'Color',green75);

ylim([-10,10]);
ylabel('Re\{Y_{inv}^{dd}(j\omega)\} in S')
% xlabel('Frequency in Hz')
% legend('Kp^{dd}=0','Kp^{dd}=0.2','Kp^{dd}=0.4','Kp^{dd}=0.8');
set(gca,'XScale','log')
grid on
box on
set(findall(gcf,'-property','FontSize'),'FontSize',16)
set(findall(gcf,'-property','Fontname'),'Fontname','Times New Roman')

subplot(2,2,2)
hold on
% case 1
h_1 = plot(f_swp,real(Y_inv_1.dq),'-','MarkerSize',5);  
set(h_1,'linewidth',1.5,'Color',blue75);
% case 2
h_2 = plot(f_swp,real(Y_inv_2.dq),'-','MarkerSize',5);  
set(h_2,'linewidth',1.5,'Color',pink75);
% case 3
h_3 = plot(f_swp,real(Y_inv_3.dq),'-','MarkerSize',5);  
set(h_3,'linewidth',1.5,'Color',green75);

ylim([-10,10]);
ylabel('Re\{Y_{inv}^{dq}(j\omega)\} in S')
% xlabel('Frequency in Hz')
% legend('Kp^{dd}=0','Kp^{dd}=0.2','Kp^{dd}=0.4','Kp^{dd}=0.8');
set(gca,'XScale','log')
grid on
box on
set(findall(gcf,'-property','FontSize'),'FontSize',16)
set(findall(gcf,'-property','Fontname'),'Fontname','Times New Roman')

subplot(2,2,3)
hold on
% case 1
h_1 = plot(f_swp,real(Y_inv_1.qd),'-','MarkerSize',5);  
set(h_1,'linewidth',1.5,'Color',blue75);
% case 2
h_2 = plot(f_swp,real(Y_inv_2.qd),'-','MarkerSize',5);  
set(h_2,'linewidth',1.5,'Color',pink75);
% case 3
h_3 = plot(f_swp,real(Y_inv_3.qd),'-','MarkerSize',5);  
set(h_3,'linewidth',1.5,'Color',green75);

ylim([-10,10]);
ylabel('Re\{Y_{inv}^{qd}(j\omega)\} in S')
xlabel('Frequency in Hz')
% legend('Kp^{dd}=0','Kp^{dd}=0.2','Kp^{dd}=0.4','Kp^{dd}=0.8');
set(gca,'XScale','log')
grid on
box on
set(findall(gcf,'-property','FontSize'),'FontSize',16)
set(findall(gcf,'-property','Fontname'),'Fontname','Times New Roman')

subplot(2,2,4)
hold on
% case 1
h_1 = plot(f_swp,real(Y_inv_1.qq),'-','MarkerSize',5);  
set(h_1,'linewidth',1.5,'Color',blue75);
% case 2
h_2 = plot(f_swp,real(Y_inv_2.qq),'-','MarkerSize',5);  
set(h_2,'linewidth',1.5,'Color',pink75);
% case 3
h_3 = plot(f_swp,real(Y_inv_3.qq),'-','MarkerSize',5);  
set(h_3,'linewidth',1.5,'Color',green75);

ylim([-10,10]);
ylabel('Re\{Y_{inv}^{qq}(j\omega)\} in S')
xlabel('Frequency in Hz')
% legend('Kp^{dd}=0','Kp^{dd}=0.2','Kp^{dd}=0.4','Kp^{dd}=0.8');
set(gca,'XScale','log')
grid on
box on
set(findall(gcf,'-property','FontSize'),'FontSize',16)
set(findall(gcf,'-property','Fontname'),'Fontname','Times New Roman')