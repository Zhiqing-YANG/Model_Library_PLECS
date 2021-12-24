%% Passivity Plot 
% ########################################################################
% Passivity plot of impedance models
% Establishment: 15.01.2021 Jiani He, PGS, RWTH Aachen
% ########################################################################

%% Load System
addpath('System/');
eval('Def_System');
Color = Def_Color();

%% Operating Case
% frequency range
fi=0;
ff=4;
n_sample=3000;
f_swp = logspace(fi,ff,n_sample);

% change system parameters
Grid.Lg = 50e-6;
Inv.OP.I_pv = -1000;

% case 1
Ctrl.DVC.Kp  = -24;
[Z_inv_1,Y_inv_1,Z_pcc_1,Y_pcc_1,Z_g_1,Y_g_1] = IM_INV_2L_ACC_PLL_DVC(Grid,Inv,Ctrl,f_swp);

% case 2
Ctrl.DVC.Kp  = -34;
[Z_inv_2,Y_inv_2,Z_pcc_2,Y_pcc_2,Z_g_2,Y_g_2] = IM_INV_2L_ACC_PLL_DVC(Grid,Inv,Ctrl,f_swp);

% case 3
Ctrl.DVC.Kp  = -44;
[Z_inv_3,Y_inv_3,Z_pcc_3,Y_pcc_3,Z_g_3,Y_g_3] = IM_INV_2L_ACC_PLL_DVC(Grid,Inv,Ctrl,f_swp);

%% Passivity Plot
figure()

% passivity plot in dd axis
subplot(2,2,1)
hold on 
% case 1
h_1 = plot(f_swp,real(Y_inv_1.dd),'-','MarkerSize',5);  
set(h_1,'linewidth',1.5,'Color',Color.blue.p100);
% case 2
h_2 = plot(f_swp,real(Y_inv_2.dd),'-','MarkerSize',5);  
set(h_2,'linewidth',1.5,'Color',Color.red.p100);
% case 3
h_3 = plot(f_swp,real(Y_inv_3.dd),'-','MarkerSize',5);  
set(h_3,'linewidth',1.5,'Color',Color.orange.p100);

ylim([-10,10]);
ylabel('Re\{Y_{inv}^{dd}(j\omega)\} in S')
% xlabel('Frequency in Hz')
% legend('Kp^{dd}=0','Kp^{dd}=0.2','Kp^{dd}=0.4','Kp^{dd}=0.8');
set(gca,'XScale','log')
grid on
box on
set(findall(gcf,'-property','FontSize'),'FontSize',16)
set(findall(gcf,'-property','Fontname'),'Fontname','Times New Roman')

% passivity plot in dq axis
subplot(2,2,2)
hold on
% case 1
h_1 = plot(f_swp,real(Y_inv_1.dq),'-','MarkerSize',5);  
set(h_1,'linewidth',1.5,'Color',Color.blue.p100);
% case 2
h_2 = plot(f_swp,real(Y_inv_2.dq),'-','MarkerSize',5);  
set(h_2,'linewidth',1.5,'Color',Color.red.p100);
% case 3
h_3 = plot(f_swp,real(Y_inv_3.dq),'-','MarkerSize',5);  
set(h_3,'linewidth',1.5,'Color',Color.orange.p100);

ylim([-10,10]);
ylabel('Re\{Y_{inv}^{dq}(j\omega)\} in S')
% xlabel('Frequency in Hz')
% legend('Kp^{dd}=0','Kp^{dd}=0.2','Kp^{dd}=0.4','Kp^{dd}=0.8');
set(gca,'XScale','log')
grid on
box on
set(findall(gcf,'-property','FontSize'),'FontSize',16)
set(findall(gcf,'-property','Fontname'),'Fontname','Times New Roman')

% passivity plot in qd axis
subplot(2,2,3)
hold on
% case 1
h_1 = plot(f_swp,real(Y_inv_1.qd),'-','MarkerSize',5);  
set(h_1,'linewidth',1.5,'Color',Color.blue.p100);
% case 2
h_2 = plot(f_swp,real(Y_inv_2.qd),'-','MarkerSize',5);  
set(h_2,'linewidth',1.5,'Color',Color.red.p100);
% case 3
h_3 = plot(f_swp,real(Y_inv_3.qd),'-','MarkerSize',5);  
set(h_3,'linewidth',1.5,'Color',Color.orange.p100);

ylim([-10,10]);
ylabel('Re\{Y_{inv}^{qd}(j\omega)\} in S')
xlabel('Frequency in Hz')
% legend('Kp^{dd}=0','Kp^{dd}=0.2','Kp^{dd}=0.4','Kp^{dd}=0.8');
set(gca,'XScale','log')
grid on
box on
set(findall(gcf,'-property','FontSize'),'FontSize',16)
set(findall(gcf,'-property','Fontname'),'Fontname','Times New Roman')

% passivity plot in qq axis
subplot(2,2,4)
hold on
% case 1
h_1 = plot(f_swp,real(Y_inv_1.qq),'-','MarkerSize',5);  
set(h_1,'linewidth',1.5,'Color',Color.blue.p100);
% case 2
h_2 = plot(f_swp,real(Y_inv_2.qq),'-','MarkerSize',5);  
set(h_2,'linewidth',1.5,'Color',Color.red.p100);
% case 3
h_3 = plot(f_swp,real(Y_inv_3.qq),'-','MarkerSize',5);  
set(h_3,'linewidth',1.5,'Color',Color.orange.p100);

ylim([-10,10]);
ylabel('Re\{Y_{inv}^{qq}(j\omega)\} in S')
xlabel('Frequency in Hz')
% legend('Kp^{dd}=0','Kp^{dd}=0.2','Kp^{dd}=0.4','Kp^{dd}=0.8');
set(gca,'XScale','log')
grid on
box on
set(findall(gcf,'-property','FontSize'),'FontSize',16)
set(findall(gcf,'-property','Fontname'),'Fontname','Times New Roman')
