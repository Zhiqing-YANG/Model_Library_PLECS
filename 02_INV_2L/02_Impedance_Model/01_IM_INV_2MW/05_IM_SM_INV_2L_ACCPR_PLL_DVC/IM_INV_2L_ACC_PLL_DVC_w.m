%% Numeric Calculation of Inverter Impedance Model 
% ########################################################################
% numeric calculation of impedance/admitance at a given frequency
% Input:
%       - [obj] grid parameter
%       - [obj] inverter parameter
%       - [obj] control parameter 
%       - [num] calculation frequency [rad/s]
% Output:
%       - [matrix] impedance/admitance matrix at a given frequency
% Consider:
%       - ACC
%       - PLL
%       - DVC
%       - AD
%       - VFF
% Establishment: 18.03.2019, Zhiqing Yang, PGS, RWTH Aachen
% ########################################################################

function [Z_inv_w, Y_inv_w, Z_pcc_w, Y_pcc_w, Z_g_w, Y_g_w] = IM_INV_2L_ACC_PLL_DVC_w(Grid,Inv,Ctrl,w)
%% Calculation of the Steady-State Values
Inv.OP.I_L1_d = Inv.OP.V_dc*Inv.OP.I_pv/(1.5*Grid.V_amp);
Inv.OP.I_L1_q = 0;
Inv.OP.V_C_d = sqrt((Grid.V_amp+Inv.OP.I_L1_d*(Inv.Filter.R2+Grid.Rg))^2+(Inv.OP.I_L1_d*Grid.wg*(Inv.Filter.L2+Grid.Lg))^2);
Inv.OP.V_C_q = 0;
Inv.OP.I_C_d = -Inv.OP.V_C_q*Grid.wg*Inv.Filter.C;
Inv.OP.I_C_q = Inv.OP.V_C_d*Grid.wg*Inv.Filter.C;
Inv.OP.V_inv_d = Inv.OP.V_C_d+Inv.OP.I_L1_d*Inv.Filter.R1-Inv.OP.I_L1_q*Grid.wg*Inv.Filter.L1;          
Inv.OP.V_inv_q = Inv.OP.V_C_q+Inv.OP.I_L1_q*Inv.Filter.R1+Inv.OP.I_L1_d*Grid.wg*Inv.Filter.L1;  
Inv.OP.M_d = Inv.OP.V_inv_d/(0.5*Inv.OP.V_dc);
Inv.OP.M_q = Inv.OP.V_inv_q/(0.5*Inv.OP.V_dc);

% Inv.OP.Theta_pll = atan(Grid.wg*Inv.OP.I_L1_d*(Inv.Filter.L2+Grid.Lg)/(Grid.V_amp+Inv.OP.I_L1_d*(Inv.Filter.R2+Grid.Rg))); 

%% Transfer Function Definition
% unit matrix
I = eye(2);

% filter
Z_L1 = [(1i*w)*Inv.Filter.L1+Inv.Filter.R1, -Grid.wg*Inv.Filter.L1; Grid.wg*Inv.Filter.L1, (1i*w)*Inv.Filter.L1+Inv.Filter.R1];      
Y_C = [(1i*w)*Inv.Filter.C, -Grid.wg*Inv.Filter.C; Grid.wg*Inv.Filter.C, (1i*w)*Inv.Filter.C];                 
Z_L2 = [(1i*w)*Inv.Filter.L2+Inv.Filter.R2, -Grid.wg*Inv.Filter.L2; Grid.wg*Inv.Filter.L2, (1i*w)*Inv.Filter.L2+Inv.Filter.R2];      
Y_dc = (1i*w)*Inv.Filter.C_dc;                                  % admittance of dc-link capacitance
Z_Rd = [Inv.Filter.Rd,0;0,Inv.Filter.Rd];

% ACC
G_ACCPR = [Ctrl.ACC.Kp+0.5*Ctrl.ACC.Kr/(1i*w)+0.5*Ctrl.ACC.Kr*(1i*w)/((1i*w)^2+4*Ctrl.ACC.wg^2), ...
           Ctrl.ACC.Kr*Ctrl.ACC.wg/((1i*w)^2+4*Ctrl.ACC.wg^2);...
          -Ctrl.ACC.Kr*Ctrl.ACC.wg/((1i*w)^2+4*Ctrl.ACC.wg^2), ...
           Ctrl.ACC.Kp+0.5*Ctrl.ACC.Kr/(1i*w)+0.5*Ctrl.ACC.Kr*(1i*w)/((1i*w)^2+4*Ctrl.ACC.wg^2)];      % PR controller in dq-frame
G_AD = [Ctrl.ACC.K_AD,0;0,Ctrl.ACC.K_AD];                                       % active damping

% delay and holder
G_dh = [(2-Ctrl.T_dh*(1i*w))/(2+Ctrl.T_dh*(1i*w)),0;0,(2-Ctrl.T_dh*(1i*w))/(2+Ctrl.T_dh*(1i*w))];   % pade approximation

% PLL 
H_PLL = Ctrl.PLL.Kp+Ctrl.PLL.Ki/(1i*w);                         % PI controller of PLL in dq frame
G_PLL = H_PLL/((1i*w)+Inv.OP.V_C_d*H_PLL);                      % small-signal model of PLL

% effect of PLL
G_PLL_I_ref = [0,-Inv.OP.I_L1_q*G_PLL;0,Inv.OP.I_L1_d*G_PLL];        % G_pll_i

% DVC   
G_DVC = [Ctrl.DVC.Kp+Ctrl.DVC.Ki/(1i*w);0];                     % PI voltage controller in dq-axis

% effect of dc-link 
G_vd = [3*Inv.OP.I_L1_d/(4*Y_dc),3*Inv.OP.I_L1_q/(4*Y_dc)];
G_vi = [3*Inv.OP.M_d/(4*Y_dc),3*Inv.OP.M_q/(4*Y_dc)];
G_M = [Inv.OP.M_d;Inv.OP.M_q];

G_A = G_dh*G_ACCPR*G_DVC*G_vd;
G_B = G_dh*G_ACCPR*(G_DVC*G_vi-I);
G_C = G_dh*(G_ACCPR*G_PLL_I_ref+I-G_AD*Y_C);
G_D = Inv.OP.V_dc/2*I-G_M/2*G_vd-G_A;

%% Impedance Model of Inverter 
% impedance
Z_inv_w = (I-G_A/G_D*G_C-G_C)\(-G_A/G_D*(G_B+G_M/2*G_vi)-G_B+Z_L1); 
          
% admittance 
Y_inv_w = I/Z_inv_w;

%% Impedance Model of Inverter with L2, C
% impedance
Z_pcc_w = inv(inv(Z_inv_w)+inv(inv(Y_C)+Z_Rd))+Z_L2; 
          
% admittance 
Y_pcc_w = I/Z_pcc_w;

%% Impedance Model of Grid
% impedance
Z_g_w = [(1i*w)*Grid.Lg+Grid.Rg, -Grid.wg*Grid.Lg; Grid.wg*Grid.Lg, (1i*w)*Grid.Lg+Grid.Rg]; 

% admittance
Y_g_w = I/Z_g_w;   

end