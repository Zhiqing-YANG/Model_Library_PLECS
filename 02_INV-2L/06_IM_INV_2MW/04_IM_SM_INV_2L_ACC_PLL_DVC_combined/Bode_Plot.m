%% Bode Plot 
% ########################################################################
% Impedance Model Bode Plot 
% Establishment: 16.03.2020 Zhiqing Yang, PGS, RWTH Aachen
% Last Change:   15.01.2021 Jiani He, PGS, RWTH Aachen
% ########################################################################

% load system
addpath('System/');
eval('Def_System');

% frequency range
fi=0;
ff=4;
n_sample=3000;
f_swp = logspace(fi,ff,n_sample);

% change system parameters
Ctrl.ACC.K_VFF = 2*pi*3000;        % [] filter bandwidth of VFF 

% case 1
Ctrl.PLL.Kp = 0.12;
[Z_inv_1,Y_inv_1,Z_pcc_1,Y_pcc_1,Z_g_1,Y_g_1] = IM_INV_2L_ACC_PLL_DVC(Grid,Inv,Ctrl,f_swp);
[f_int_1,phs_int_1] = find_intersection_Bode(Z_pcc_1,Z_g_1,f_swp,n_sample,2);

% case 2
Ctrl.PLL.Kp = 0.36;
[Z_inv_2,Y_inv_2,Z_pcc_2,Y_pcc_2,Z_g_2,Y_g_2] = IM_INV_2L_ACC_PLL_DVC(Grid,Inv,Ctrl,f_swp);
[f_int_2,phs_int_2] = find_intersection_Bode(Z_pcc_2,Z_g_2,f_swp,n_sample,2);

% case 3
Ctrl.PLL.Kp = 1.08;
[Z_inv_3,Y_inv_3,Z_pcc_3,Y_pcc_3,Z_g_3,Y_g_3] = IM_INV_2L_ACC_PLL_DVC(Grid,Inv,Ctrl,f_swp);
[f_int_3,phs_int_3] = find_intersection_Bode(Z_pcc_3,Z_g_3,f_swp,n_sample,2);

% load color template
eval('Def_Color');

%% Bode Plot in dd Axis
figure ()

subplot(2,1,1)
title('{Z}_{pcc}^{dd} with {Z}_{g}^{dd}')
hold on
% Z_g
h_0 = plot(f_swp,20*log10(abs(Z_g_1.dd)),'-','MarkerSize',5);
set(h_0,'linewidth',1.5,'Color',gray);
% case 1
h_1 = plot(f_swp,20*log10(abs(Z_pcc_1.dd)),'-','MarkerSize',5);
set(h_1,'linewidth',1.5,'Color',blue50);
% case 2
h_2 = plot(f_swp,20*log10(abs(Z_pcc_2.dd)),'-','MarkerSize',5);
set(h_2,'linewidth',1.5,'Color',blue75);
% case 3
h_3 = plot(f_swp,20*log10(abs(Z_pcc_3.dd)),'-','MarkerSize',5);
set(h_3,'linewidth',1.5,'Color',blue);

% ylim([-80,20]);
% xlabel('Frequency (Hz)');
ylabel('Magnitude in dB')
legend([h_1,h_2,h_3],'{K}_{p}^{PLL} = 0.12','{K}_{p}^{PLL} = 0.36','{K}_{p}^{PLL} = 1.08');
set(gca,'XScale','log')
grid on
box on
set(findall(gcf,'-property','FontSize'),'FontSize',16)
set(findall(gcf,'-property','Fontname'),'Fontname','Times New Roman')

subplot(2,1,2)
hold on
% Zg
h_0 = plot(f_swp,wrapTo180(angle(Z_g_1.dd)/pi*180),'-','MarkerSize',5);
set(h_0,'linewidth',1.5,'Color',gray);
% case 1
h_1 = plot(f_swp,wrapTo180(angle(Z_pcc_1.dd)/pi*180),'-','MarkerSize',5);
set(h_1,'linewidth',1.5,'Color',blue50);
% case 2
h_2 = plot(f_swp,wrapTo180(angle(Z_pcc_2.dd)/pi*180),'-','MarkerSize',5);
set(h_2,'linewidth',1.5,'Color',blue75);
% case 3
h_3 = plot(f_swp,wrapTo180(angle(Z_pcc_3.dd)/pi*180),'-','MarkerSize',5);
set(h_3,'linewidth',1.5,'Color',blue);

% ylim([-180,180]);
xlabel('Frequency in Hz');
ylabel('Phase in deg')
legend([h_1,h_2,h_3],'{K}_{p}^{PLL} = 0.12','{K}_{p}^{PLL} = 0.36','{K}_{p}^{PLL} = 1.08');
set(gca,'XScale','log')
grid on
box on
set(findall(gcf,'-property','FontSize'),'FontSize',16)
set(findall(gcf,'-property','Fontname'),'Fontname','Times New Roman')

% cleanfigure();
% matlab2tikz('Bode_Plot.tex')

%% Bode Plot in qq Axis
figure ()

subplot(2,1,1)
title('{Z}_{pcc}^{qq} with {Z}_{g}^{qq}')
hold on
% Z_g
h_0 = plot(f_swp,20*log10(abs(Z_g_1.qq)),'-','MarkerSize',5);
set(h_0,'linewidth',1.5,'Color',gray);
% case 1
h_1 = plot(f_swp,20*log10(abs(Z_pcc_1.qq)),'-','MarkerSize',5);
set(h_1,'linewidth',1.5,'Color',blue50);
% case 2
h_2 = plot(f_swp,20*log10(abs(Z_pcc_2.qq)),'-','MarkerSize',5);
set(h_2,'linewidth',1.5,'Color',blue75);
% case 3
h_3 = plot(f_swp,20*log10(abs(Z_pcc_3.qq)),'-','MarkerSize',5);
set(h_3,'linewidth',1.5,'Color',blue);

% ylim([-80,20]);
% xlabel('Frequency (Hz)');
ylabel('Magnitude in dB')
legend([h_1,h_2,h_3],'{K}_{p}^{PLL} = 0.12','{K}_{p}^{PLL} = 0.36','{K}_{p}^{PLL} = 1.08');
set(gca,'XScale','log')
grid on
box on
set(findall(gcf,'-property','FontSize'),'FontSize',16)
set(findall(gcf,'-property','Fontname'),'Fontname','Times New Roman')

subplot(2,1,2)
hold on
% Zg
h_0 = plot(f_swp,wrapTo180(angle(Z_g_1.qq)/pi*180),'-','MarkerSize',5);
set(h_0,'linewidth',1.5,'Color',gray);
% case 1
h_1 = plot(f_swp,wrapTo180(angle(Z_pcc_1.qq)/pi*180),'-','MarkerSize',5);
set(h_1,'linewidth',1.5,'Color',blue50);
% case 2
h_2 = plot(f_swp,wrapTo180(angle(Z_pcc_2.qq)/pi*180),'-','MarkerSize',5);
set(h_2,'linewidth',1.5,'Color',blue75);
% case 3
h_3 = plot(f_swp,wrapTo180(angle(Z_pcc_3.qq)/pi*180),'-','MarkerSize',5);
set(h_3,'linewidth',1.5,'Color',blue);

% ylim([-180,180]);
xlabel('Frequency in Hz');
ylabel('Phase in deg')
legend([h_1,h_2,h_3],'{K}_{p}^{PLL} = 0.12','{K}_{p}^{PLL} = 0.36','{K}_{p}^{PLL} = 1.08');
set(gca,'XScale','log')
grid on
box on
set(findall(gcf,'-property','FontSize'),'FontSize',16)
set(findall(gcf,'-property','Fontname'),'Fontname','Times New Roman')

% cleanfigure();
% matlab2tikz('Bode_Plot.tex')

%% Bode Plot in dq Axis
% figure ()
% 
% subplot(2,1,1)
% title('{Z}_{pcc}^{dq} with {Z}_{g}^{dq}')
% hold on
% % Z_g
% h_0 = plot(f_swp,20*log10(abs(Z_g_1.dq)),'-','MarkerSize',5);
% set(h_0,'linewidth',1.5,'Color',gray);
% % case 1
% h_1 = plot(f_swp,20*log10(abs(Z_pcc_1.dq)),'-','MarkerSize',5);
% set(h_1,'linewidth',1.5,'Color',blue50);
% % case 2
% h_2 = plot(f_swp,20*log10(abs(Z_pcc_2.dq)),'-','MarkerSize',5);
% set(h_2,'linewidth',1.5,'Color',blue75);
% % case 3
% h_3 = plot(f_swp,20*log10(abs(Z_pcc_3.dq)),'-','MarkerSize',5);
% set(h_3,'linewidth',1.5,'Color',blue);
% 
% % xlabel('Frequency (Hz)');
% ylabel('Magnitude in dB')
% legend([h_1,h_2,h_3],'{K}_{p}^{PLL} = 0.12','{K}_{p}^{PLL} = 0.36','{K}_{p}^{PLL} = 1.08');
% set(gca,'XScale','log')
% grid on
% box on
% set(findall(gcf,'-property','FontSize'),'FontSize',16)
% set(findall(gcf,'-property','Fontname'),'Fontname','Times New Roman')
% % ylim([-80,20]);
% 
% subplot(2,1,2)
% hold on
% % Zg
% h_0 = plot(f_swp,wrapTo180(angle(Z_g_1.dq)/pi*180),'-','MarkerSize',5);
% set(h_0,'linewidth',1.5,'Color',gray);
% % case 1
% h_1 = plot(f_swp,wrapTo180(angle(Z_pcc_1.dq)/pi*180),'-','MarkerSize',5);
% set(h_1,'linewidth',1.5,'Color',blue50);
% % case 2
% h_2 = plot(f_swp,wrapTo180(angle(Z_pcc_2.dq)/pi*180),'-','MarkerSize',5);
% set(h_2,'linewidth',1.5,'Color',blue75);
% % case 3
% h_3 = plot(f_swp,wrapTo180(angle(Z_pcc_3.dq)/pi*180),'-','MarkerSize',5);
% set(h_3,'linewidth',1.5,'Color',blue);
% 
% xlabel('Frequency in Hz');
% ylabel('Phase in deg')
% legend([h_1,h_2,h_3],'{K}_{p}^{PLL} = 0.12','{K}_{p}^{PLL} = 0.36','{K}_{p}^{PLL} = 1.08');
% set(gca,'XScale','log')
% grid on
% box on
% set(findall(gcf,'-property','FontSize'),'FontSize',16)
% set(findall(gcf,'-property','Fontname'),'Fontname','Times New Roman')
% % ylim([-180,180]);
% 
% % cleanfigure();
% % matlab2tikz('Bode_Plot.tex')
% 
%% Bode Plot in qd Axis
% figure ()
% 
% subplot(2,1,1)
% title('{Z}_{pcc}^{qd} with {Z}_{g}^{qd}')
% hold on
% % Z_g
% h_0 = plot(f_swp,20*log10(abs(Z_g_1.qd)),'-','MarkerSize',5);
% set(h_0,'linewidth',1.5,'Color',gray);
% % case 1
% h_1 = plot(f_swp,20*log10(abs(Z_pcc_1.qd)),'-','MarkerSize',5);
% set(h_1,'linewidth',1.5,'Color',blue50);
% % case 2
% h_2 = plot(f_swp,20*log10(abs(Z_pcc_2.qd)),'-','MarkerSize',5);
% set(h_2,'linewidth',1.5,'Color',blue75);
% % case 3
% h_3 = plot(f_swp,20*log10(abs(Z_pcc_3.qd)),'-','MarkerSize',5);
% set(h_3,'linewidth',1.5,'Color',blue);
% 
% % xlabel('Frequency (Hz)');
% ylabel('Magnitude in dB')
% legend([h_1,h_2,h_3],'{K}_{p}^{PLL} = 0.12','{K}_{p}^{PLL} = 0.36','{K}_{p}^{PLL} = 1.08');
% set(gca,'XScale','log')
% grid on
% box on
% set(findall(gcf,'-property','FontSize'),'FontSize',16)
% set(findall(gcf,'-property','Fontname'),'Fontname','Times New Roman')
% % ylim([-80,20]);
% 
% subplot(2,1,2)
% hold on
% % Zg
% h_0 = plot(f_swp,wrapTo180(angle(Z_g_1.qd)/pi*180),'-','MarkerSize',5);
% set(h_0,'linewidth',1.5,'Color',gray);
% % case 1
% h_1 = plot(f_swp,wrapTo180(angle(Z_pcc_1.qd)/pi*180),'-','MarkerSize',5);
% set(h_1,'linewidth',1.5,'Color',blue50);
% % case 2
% h_2 = plot(f_swp,wrapTo180(angle(Z_pcc_2.qd)/pi*180),'-','MarkerSize',5);
% set(h_2,'linewidth',1.5,'Color',blue75);
% % case 3
% h_3 = plot(f_swp,wrapTo180(angle(Z_pcc_3.qd)/pi*180),'-','MarkerSize',5);
% set(h_3,'linewidth',1.5,'Color',blue);
% 
% xlabel('Frequency in Hz');
% ylabel('Phase in deg')
% legend([h_1,h_2,h_3],'{K}_{p}^{PLL} = 0.12','{K}_{p}^{PLL} = 0.36','{K}_{p}^{PLL} = 1.08');
% set(gca,'XScale','log')
% grid on
% box on
% set(findall(gcf,'-property','FontSize'),'FontSize',16)
% set(findall(gcf,'-property','Fontname'),'Fontname','Times New Roman')
% % ylim([-180,180]);
% 
% % cleanfigure();
% % matlab2tikz('Bode_Plot.tex')