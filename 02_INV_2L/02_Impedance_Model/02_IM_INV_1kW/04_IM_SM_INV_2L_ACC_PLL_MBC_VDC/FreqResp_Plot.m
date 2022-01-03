%% Frequency Response Plot 
% ########################################################################
% Frequency response plot of impedance models
% Establishment: 15.01.2021 Jiani He, PGS, RWTH Aachen
% ########################################################################

%% Load System
addpath('System/');
eval('Def_System');
Color = Def_Color();

%% Operating Case
% frequency range
fi=1;
ff=5;
n_sample=3000;
f_swp = logspace(fi,ff,n_sample);     

% change system parameters
Grid.Lg = 5.5e-3;

% case 1
Ctrl.MBC.Kp = 10;
Ctrl.VDC.Gdd.Kp = 0;
Ctrl.VDC.Gdd.Ki = 0;
Ctrl.VDC.Gqq.Kp = 0;
Ctrl.VDC.Gqq.Ki = 0;
e_1 = solve_eig(Grid,Inv,Ctrl,f_swp,1);   
[f_jmp_1,mag_jmp_1] = find_phase_jump_FreqResp(e_1,f_swp,n_sample,2);

% case 2
Ctrl.MBC.Kp = 0;
Ctrl.VDC.Gdd.Kp = 0.01;
Ctrl.VDC.Gdd.Ki = 0;
Ctrl.VDC.Gqq.Kp = 0.01;
Ctrl.VDC.Gqq.Ki = 30;
e_2 = solve_eig(Grid,Inv,Ctrl,f_swp,1);   
[f_jmp_2,mag_jmp_2] = find_phase_jump_FreqResp(e_2,f_swp,n_sample,2);

% case 3
Ctrl.MBC.Kp = 10;
Ctrl.VDC.Gdd.Kp = 0.01;
Ctrl.VDC.Gdd.Ki = 0;
Ctrl.VDC.Gqq.Kp = 0.01;
Ctrl.VDC.Gqq.Ki = 30;
e_3 = solve_eig(Grid,Inv,Ctrl,f_swp,1);   
[f_jmp_3,mag_jmp_3] = find_phase_jump_FreqResp(e_3,f_swp,n_sample,2);

%% Frequency Response Plot
figure()

subplot(2,1,1) 
hold on
% mag = 0dB
h_0 = plot([f_swp(1),f_swp(n_sample)],[0,0],'-','MarkerSize',5);      
set(h_0,'linewidth',1,'Color',Color.black.p75);
% case 1
h_1 = plot(f_swp,20*log10(abs(e_1(1,:))),'-','MarkerSize',5);                        % eigenvalue 1 
h_2 = plot(f_swp,20*log10(abs(e_1(2,:))),'-','MarkerSize',5);                        % eigenvalue 2
set(h_1,'linewidth',1.5,'Color',Color.blue.p50);
set(h_2,'linewidth',1.5,'Color',Color.red.p50);
% case 2
h_3 = plot(f_swp,20*log10(abs(e_2(1,:))),'-','MarkerSize',5);                        % eigenvalue 1 
h_4 = plot(f_swp,20*log10(abs(e_2(2,:))),'-','MarkerSize',5);                        % eigenvalue 2
set(h_3,'linewidth',1.5,'Color',Color.blue.p75);
set(h_4,'linewidth',1.5,'Color',Color.red.p75);
% case 3
h_5 = plot(f_swp,20*log10(abs(e_3(1,:))),'-','MarkerSize',5);                        % eigenvalue 1 
h_6 = plot(f_swp,20*log10(abs(e_3(2,:))),'-','MarkerSize',5);                        % eigenvalue 2
set(h_5,'linewidth',1.5,'Color',Color.blue.p100);
set(h_6,'linewidth',1.5,'Color',Color.red.p100);

% ylim([-40,20]);
% xlabel('Frequency in Hz');
ylabel('Magnitude in dB')
legend([h_5,h_6],'\lambda_{1}','\lambda_{2}');
set(gca,'XScale','log')
grid on
box on
set(findall(gcf,'-property','FontSize'),'FontSize',16)
set(findall(gcf,'-property','Fontname'),'Fontname','Times New Roman')

subplot(2,1,2) 
hold on
% plotting phase=+/-180 degree line
h_0 = plot([f_swp(1),f_swp(n_sample)],[180,180],'-','MarkerSize',5);    
set(h_0,'linewidth',1,'Color',Color.black.p75);
h_0 = plot([f_swp(1),f_swp(n_sample)],[-180,-180],'-','MarkerSize',5);  
set(h_0,'linewidth',1,'Color',Color.black.p75);
% case 1
h_1 = plot(f_swp,180/pi*angle(e_1(1,:)),'-','MarkerSize',5);                         % eigenvalue 1
h_2 = plot(f_swp,180/pi*angle(e_1(2,:)),'-','MarkerSize',5);                         % eigenvalue 2
set(h_1,'linewidth',1.5,'Color',Color.blue.p50);
set(h_2,'linewidth',1.5,'Color',Color.red.p50);
% case 2
h_3 = plot(f_swp,180/pi*angle(e_2(1,:)),'-','MarkerSize',5);                         % eigenvalue 1
h_4 = plot(f_swp,180/pi*angle(e_2(2,:)),'-','MarkerSize',5);                         % eigenvalue 2
set(h_3,'linewidth',1.5,'Color',Color.blue.p75);
set(h_4,'linewidth',1.5,'Color',Color.red.p75);
% case 3
h_5 = plot(f_swp,180/pi*angle(e_3(1,:)),'-','MarkerSize',5);                         % eigenvalue 1
h_6 = plot(f_swp,180/pi*angle(e_3(2,:)),'-','MarkerSize',5);                         % eigenvalue 2
set(h_5,'linewidth',1.5,'Color',Color.blue.p100);
set(h_6,'linewidth',1.5,'Color',Color.red.p100);

xlabel('Frequency in Hz');
ylabel('Phase in deg')
legend([h_5,h_6],'\lambda_{1}','\lambda_{2}');
set(gca,'XScale','log')
grid on
box on
set(findall(gcf,'-property','FontSize'),'FontSize',16)
set(findall(gcf,'-property','Fontname'),'Fontname','Times New Roman')

% cleanfigure();
% matlab2tikz('FreqResp_Plot_DVC_Kp.tex')
