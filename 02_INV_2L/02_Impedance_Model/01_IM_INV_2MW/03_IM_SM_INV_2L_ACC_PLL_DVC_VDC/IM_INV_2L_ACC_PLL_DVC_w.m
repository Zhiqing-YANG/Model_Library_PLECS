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
%       - VDC
% Establishment: 18.03.2019, Zhiqing Yang, PGS, RWTH Aachen
% ########################################################################

function [Z_inv_w, Y_inv_w, Z_pcc_w, Y_pcc_w, Z_g_w, Y_g_w] = IM_INV_2L_ACC_PLL_DVC_VDC_w(Grid,Inv,Ctrl,w)
%% Calculation of the Steady-State Values
Inv.OP.I_L1_d = Ctrl.I_ref_d;
Inv.OP.I_L1_q = Ctrl.I_ref_q;
Inv.OP.V_C_d = sqrt((Grid.V_amp)^2-(Inv.OP.I_L1_q*(Inv.Filter.R2+Grid.Rg)+Inv.OP.I_L1_d*Grid.wg*(Inv.Filter.L2+Grid.Lg))^2)...
               +Inv.OP.I_L1_d*(Inv.Filter.R2+Grid.Rg)+Inv.OP.I_L1_q*Grid.wg*(Inv.Filter.L2+Grid.Lg);
Inv.OP.V_C_q = 0;
Inv.OP.I_C_d = Inv.OP.V_C_q*Grid.wg*Inv.Filter.C;
Inv.OP.I_C_q = -Inv.OP.V_C_d*Grid.wg*Inv.Filter.C;
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
G_ACC = [Ctrl.ACC.Kp+Ctrl.ACC.Ki/(1i*w),0;0,Ctrl.ACC.Kp+Ctrl.ACC.Ki/(1i*w)];    % PI current controller in dq frame
G_dec = [0,Grid.wg*Inv.Filter.L1;-Grid.wg*Inv.Filter.L1,0];                     % dq decoupling
G_AD = [Ctrl.ACC.K_AD,0;0,Ctrl.ACC.K_AD];                                       % active damping
G_VFF = [Ctrl.ACC.K_VFF/((1i*w)+Ctrl.ACC.K_VFF),0;0,Ctrl.ACC.K_VFF/((1i*w)+Ctrl.ACC.K_VFF)]; 

% delay and hold
% F_del = exp(-1i*(w)*Ctrl.Td_PWM);                           % delay function
F_del = (2-Ctrl.Td_PWM*(1i*w))/(2+Ctrl.Td_PWM*(1i*w));        % delay function
G_del = [F_del,0;0,F_del];                                    % delay matrix

% PLL 
F_PLL = Ctrl.PLL.Kp+Ctrl.PLL.Ki/(1i*w);             % PI controller of PLL in dq frame
H_PLL = F_PLL/((1i*w)+Inv.OP.V_C_d*F_PLL);          % small-signal model of PLL

% effect of PLL
G_PLL_m = [0,-Inv.OP.M_q*H_PLL;0,Inv.OP.M_d*H_PLL];             % G_PLL_m
G_PLL_i = [0,Inv.OP.I_L1_q*H_PLL;0,-Inv.OP.I_L1_d*H_PLL];       % G_PLL_i
G_PLL_v = [1,Inv.OP.V_C_q*H_PLL;0,1-Inv.OP.V_C_d*H_PLL];        % G_PLL_v
G_PLL_ic = [0,Inv.OP.I_C_q*H_PLL;0,-Inv.OP.I_C_d*H_PLL];        % G_PLL_ic

% DVC 
F_DVC = Ctrl.DVC.Kp+Ctrl.DVC.Ki/(1i*w);             % PI controller of DVC in dq frame
G_DVC = [F_DVC;0];                                  % small-signal model of DVC

% virtual damping control
F_VDC_dd = Ctrl.VDC.Gdd.Kp+Ctrl.VDC.Gdd.Ki/(1i*w)+Ctrl.VDC.Gdd.Kd*Ctrl.VDC.w_LPF*(1i*w)/((1i*w)+Ctrl.VDC.w_LPF);   
F_VDC_qq = Ctrl.VDC.Gqq.Kp+Ctrl.VDC.Gqq.Ki/(1i*w)+Ctrl.VDC.Gqq.Kd*Ctrl.VDC.w_LPF*(1i*w)/((1i*w)+Ctrl.VDC.w_LPF);   
F_VDC_dq = 0;                           
F_VDC_qd = 0;   
G_VDC = [F_VDC_dd,F_VDC_dq;F_VDC_qd,F_VDC_qq];

% effect of dc-link 
G_vd = [3*Inv.OP.I_L1_d/(4*Y_dc),3*Inv.OP.I_L1_q/(4*Y_dc)];
G_vi = [3*Inv.OP.M_d/(4*Y_dc),3*Inv.OP.M_q/(4*Y_dc)];
G_M = [Inv.OP.M_d;Inv.OP.M_q];

G_A = I*Inv.OP.V_dc/2-G_del*G_ACC*G_DVC*G_vd-G_M/2*G_vd;
G_B = G_del*G_ACC*G_DVC*G_vi-G_del*(G_ACC+G_dec)+G_M/2*G_vi; 
G_C = G_PLL_m*Inv.OP.V_dc/2+G_del*(G_VFF-G_ACC*G_VDC)*G_PLL_v-G_del*(G_ACC+G_dec)*G_PLL_i-G_del*G_AD*(G_PLL_ic+Y_C);

%% Impedance Model of Inverter 
% impedance
Z_inv_w = -(I-(Inv.OP.V_dc/2*I-G_M/2*G_vd)*inv(G_A)*G_C)\((Inv.OP.V_dc/2*I-G_M/2*G_vd)*inv(G_A)*G_B-G_M/2*G_vi-Z_L1);
          
% admittance 
Y_inv_w = I/Z_inv_w;

%% Impedance Model of Inverter with L2, C
% impedance
Z_pcc_w =inv(inv(Z_inv_w)+inv(inv(Y_C)+Z_Rd))+Z_L2; 
          
% admittance 
Y_pcc_w = I/Z_pcc_w;

%% Impedance Model of Grid
% impedance
Z_g_w = [(1i*w)*Grid.Lg+Grid.Rg, -Grid.wg*Grid.Lg; Grid.wg*Grid.Lg, (1i*w)*Grid.Lg+Grid.Rg]; 

% admittance
Y_g_w = I/Z_g_w;  

end