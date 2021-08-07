%% Nyquist Plot 
% ########################################################################
% Nyquist plot of impedance models
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
Ctrl.ACC.Kp = 15;
e_1= solve_eig(Grid,Inv,Ctrl,f_swp,1);  
[f_int_1,phs_int_1] = find_phase_margin_Nyq(e_1,f_swp,n_sample,2);

% case 2
Ctrl.ACC.Kp = 10;
e_2 = solve_eig(Grid,Inv,Ctrl,f_swp,1);  
[f_int_2,phs_int_2] = find_phase_margin_Nyq(e_2,f_swp,n_sample,2);

% case 3
Ctrl.ACC.Kp = 5;
e_3 = solve_eig(Grid,Inv,Ctrl,f_swp,1);
[f_int_3,phs_int_3] = find_phase_margin_Nyq(e_3,f_swp,n_sample,2);

%% Nyquist Plot
figure()
hold on
% unit circle 
theta = linspace(0,2*pi);
x1 = cos(theta);
y1 = sin(theta);
plot(x1,y1,'-','LineWidth',1,'Color',Color.black.p75);     
% case 1
h_1 = plot(real(e_1(1,:)),imag(e_1(1,:)),'-','MarkerSize',5);   % eigenvalue 1
h_2 = plot(real(e_1(2,:)),imag(e_1(2,:)),'-','MarkerSize',5);   % eigenvalue 2
set(h_1,'linewidth',1.5,'Color',Color.blue.p50);
set(h_2,'linewidth',1.5,'Color',Color.red.p50);
% case 2
h_3 = plot(real(e_2(1,:)),imag(e_2(1,:)),'-','MarkerSize',5);   % eigenvalue 1
h_4 = plot(real(e_2(2,:)),imag(e_2(2,:)),'-','MarkerSize',5);   % eigenvalue 2
set(h_3,'linewidth',1.5,'Color',Color.blue.p75);
set(h_4,'linewidth',1.5,'Color',Color.red.p75);
% case 3
h_5 = plot(real(e_3(1,:)),imag(e_3(1,:)),'-','MarkerSize',5);   % eigenvalue 1
h_6 = plot(real(e_3(2,:)),imag(e_3(2,:)),'-','MarkerSize',5);   % eigenvalue 2
set(h_5,'linewidth',1.5,'Color',Color.blue.p100);
set(h_6,'linewidth',1.5,'Color',Color.red.p100);
% (-1,0) point
plot(-1,0,'+','LineWidth',3,'Color',Color.green.p75);      

xlim([-1.5,1]);
ylim([-1,1]);
xlabel('Real axis in rad/s');
ylabel('Imaginary axis in rad/s')
legend([h_5,h_6],'\lambda_{1}','\lambda_{2}');
grid on
box on
set(findall(gcf,'-property','FontSize'),'FontSize',16)
set(findall(gcf,'-property','Fontname'),'Fontname','Times New Roman')

% cleanfigure();
% matlab2tikz('Nyquist_Plot.tex')
