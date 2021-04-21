%% Nyquist Plot 
% ########################################################################
% Impedance Model Nyquist Plot 
% Establishment: 16.03.2020 Zhiqing Yang, PGS, RWTH Aachen
% Last Change:   15.01.2021 Jiani He, PGS, RWTH Aachen
% ########################################################################

% load system
addpath('System/');
eval('Def_System');

% define frequency range
fi=-3;
ff=6;
n_sample=3000;
f_swp = logspace(fi,ff,n_sample);   

% change system parameters
Ctrl.VDC.Gqq.Kp = 0;
Ctrl.VDC.Gqq.Ki = 0;
Ctrl.VDC.Gdd.Kp = 0;
Ctrl.VDC.Gdd.Ki = 0;
Grid.Lg = 300e-6;
Inv.OP.I_pv = 1000;   
Ctrl.ACC.K_VFF = 2*pi*3000;

% case 1
Ctrl.MBC.Kp = 0;
e_1= solve_eig(Grid,Inv,Ctrl,f_swp,1);  
[f_int_1,phs_int_1] = find_phase_margin_Nyq(e_1,f_swp,n_sample,2);

% case 2
Ctrl.MBC.Kp = 1.2;
e_2 = solve_eig(Grid,Inv,Ctrl,f_swp,1);  
[f_int_2,phs_int_2] = find_phase_margin_Nyq(e_2,f_swp,n_sample,2);

% case 3
Ctrl.MBC.Kp = 3.4;
e_3 = solve_eig(Grid,Inv,Ctrl,f_swp,1); 
[f_int_3,phs_int_3] = find_phase_margin_Nyq(e_3,f_swp,n_sample,2);

%% Nyquist Plot
% load color template
eval('Def_Color');

figure()
hold on
% unit circle 
theta = linspace(0,2*pi);
x1 = cos(theta);
y1 = sin(theta);
plot(x1,y1,'-','LineWidth',1,'Color',gray);     
% case 1
h_1 = plot(real(e_1(1,:)),imag(e_1(1,:)),'-','MarkerSize',5);   % eigenvalue 1
h_2 = plot(real(e_1(2,:)),imag(e_1(2,:)),'-','MarkerSize',5);   % eigenvalue 2
set(h_1,'linewidth',1.5,'Color',blue50);
set(h_2,'linewidth',1.5,'Color',red50);
% case 2
h_3 = plot(real(e_2(1,:)),imag(e_2(1,:)),'-','MarkerSize',5);   % eigenvalue 1
h_4 = plot(real(e_2(2,:)),imag(e_2(2,:)),'-','MarkerSize',5);   % eigenvalue 2
set(h_3,'linewidth',1.5,'Color',blue75);
set(h_4,'linewidth',1.5,'Color',red75);
% case 3
h_5 = plot(real(e_3(1,:)),imag(e_3(1,:)),'-','MarkerSize',5);   % eigenvalue 1
h_6 = plot(real(e_3(2,:)),imag(e_3(2,:)),'-','MarkerSize',5);   % eigenvalue 2
set(h_5,'linewidth',1.5,'Color',blue);
set(h_6,'linewidth',1.5,'Color',red);
% (-1,0) point
plot(-1,0,'+','LineWidth',3,'Color',green75);      

% xlim([-1.5,1]);
% ylim([-1,1]);
xlabel('Real axis in rad/s');
ylabel('Imaginary axis in rad/s')
legend([h_5,h_6],'\lambda_{1}','\lambda_{2}');
grid on
box on
set(findall(gcf,'-property','FontSize'),'FontSize',16)
set(findall(gcf,'-property','Fontname'),'Fontname','Times New Roman')

% cleanfigure();
% matlab2tikz('Nyquist_Plot.tex')
