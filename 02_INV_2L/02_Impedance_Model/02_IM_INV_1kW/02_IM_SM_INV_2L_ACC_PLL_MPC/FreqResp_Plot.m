%% Frequency Response Plot 
% ########################################################################
% Impedance Model Frequency Response Plot 
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
% Ctrl.PLL.Kp = 8;
Ctrl.MBC.Kp = 0;
Ctrl.PLL.Kp = 2.3;

% case 1
% Ctrl.MBC.Kp = 0;
Ctrl.ACC.Kp = 10;
e_1 = solve_eig(Grid,Inv,Ctrl,f_swp,1);   
[f_jmp_1,mag_jmp_1] = find_phase_jump_FreqResp(e_1,f_swp,n_sample,2);

% case 2
% Ctrl.MBC.Kp = 10;
Ctrl.ACC.Kp = 8;
e_2 = solve_eig(Grid,Inv,Ctrl,f_swp,1);   
[f_jmp_2,mag_jmp_2] = find_phase_jump_FreqResp(e_2,f_swp,n_sample,2);

% case 3
% Ctrl.MBC.Kp = 20;
Ctrl.ACC.Kp = 7;
e_3 = solve_eig(Grid,Inv,Ctrl,f_swp,1);   
[f_jmp_3,mag_jmp_3] = find_phase_jump_FreqResp(e_3,f_swp,n_sample,2);

%% Frequency Response Plot
% load color template
eval('Def_Color');

figure()

subplot(2,1,1) 
hold on
% mag = 0dB
h_0 = plot([f_swp(1),f_swp(n_sample)],[0,0],'-','MarkerSize',5);      
set(h_0,'linewidth',1,'Color',gray);
% case 1
h_1 = plot(f_swp,20*log10(abs(e_1(1,:))),'-','MarkerSize',5);                        % eigenvalue 1 
h_2 = plot(f_swp,20*log10(abs(e_1(2,:))),'-','MarkerSize',5);                        % eigenvalue 2
set(h_1,'linewidth',1.5,'Color',blue50);
set(h_2,'linewidth',1.5,'Color',red50);
% case 2
h_3 = plot(f_swp,20*log10(abs(e_2(1,:))),'-','MarkerSize',5);                        % eigenvalue 1 
h_4 = plot(f_swp,20*log10(abs(e_2(2,:))),'-','MarkerSize',5);                        % eigenvalue 2
set(h_3,'linewidth',1.5,'Color',blue75);
set(h_4,'linewidth',1.5,'Color',red75);
% case 3
h_5 = plot(f_swp,20*log10(abs(e_3(1,:))),'-','MarkerSize',5);                        % eigenvalue 1 
h_6 = plot(f_swp,20*log10(abs(e_3(2,:))),'-','MarkerSize',5);                        % eigenvalue 2
set(h_5,'linewidth',1.5,'Color',blue);
set(h_6,'linewidth',1.5,'Color',red);

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
set(h_0,'linewidth',1,'Color',gray);
h_0 = plot([f_swp(1),f_swp(n_sample)],[-180,-180],'-','MarkerSize',5);  
set(h_0,'linewidth',1,'Color',gray);
% case 1
h_1 = plot(f_swp,180/pi*angle(e_1(1,:)),'-','MarkerSize',5);                         % eigenvalue 1
h_2 = plot(f_swp,180/pi*angle(e_1(2,:)),'-','MarkerSize',5);                         % eigenvalue 2
set(h_1,'linewidth',1.5,'Color',blue50);
set(h_2,'linewidth',1.5,'Color',red50);
% case 2
h_3 = plot(f_swp,180/pi*angle(e_2(1,:)),'-','MarkerSize',5);                         % eigenvalue 1
h_4 = plot(f_swp,180/pi*angle(e_2(2,:)),'-','MarkerSize',5);                         % eigenvalue 2
set(h_3,'linewidth',1.5,'Color',blue75);
set(h_4,'linewidth',1.5,'Color',red75);
% case 3
h_5 = plot(f_swp,180/pi*angle(e_3(1,:)),'-','MarkerSize',5);                         % eigenvalue 1
h_6 = plot(f_swp,180/pi*angle(e_3(2,:)),'-','MarkerSize',5);                         % eigenvalue 2
set(h_5,'linewidth',1.5,'Color',blue);
set(h_6,'linewidth',1.5,'Color',red);

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
