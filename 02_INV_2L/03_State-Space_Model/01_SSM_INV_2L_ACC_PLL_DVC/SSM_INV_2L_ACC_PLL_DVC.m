%% Inverter Numeric State-Space Model
% ########################################################################
% Calculate numeric state matrix of an inverter 
% Input:
%       - [obj] inverter parameter 
%       - [obj] control parameter
%       - [obj] grid parameter 
% Output:
%       - [obj] state-space model
% Establishment: 24.07.2021 Zhiqing Yang, PGS, RWTH Aachen
% ########################################################################

function SSM_INV = SSM_INV_2L_ACC_PLL_DVC(Inv,Ctrl,Grid)
%% Calculation of the steady-state values
Inv.OP.I_L1_d = Inv.OP.V_dc*Inv.OP.I_pv/(1.5*Grid.V_amp);
Inv.OP.I_L1_q = 0;
Inv.OP.V_C_d = sqrt((Grid.V_amp+Inv.OP.I_L1_d*(Inv.Filter.R2+Grid.Rg))^2+(Inv.OP.I_L1_d*Grid.wg*(Inv.Filter.L2+Grid.Lg))^2);
Inv.OP.V_C_q = 0;
Inv.OP.I_C_d = -Inv.OP.V_C_q*Grid.wg*Inv.Filter.C;
Inv.OP.I_C_q = Inv.OP.V_C_d*Grid.wg*Inv.Filter.C;
Inv.OP.I_L2_d = Inv.OP.I_L1_d - Inv.OP.I_C_d;
Inv.OP.I_L2_q = Inv.OP.I_L1_q - Inv.OP.I_C_q;
Inv.OP.V_inv_d = Inv.OP.V_C_d+Inv.OP.I_L1_d*Inv.Filter.R1-Inv.OP.I_L1_q*Grid.wg*Inv.Filter.L1;          
Inv.OP.V_inv_q = Inv.OP.V_C_q+Inv.OP.I_L1_q*Inv.Filter.R1+Inv.OP.I_L1_d*Grid.wg*Inv.Filter.L1;  
Inv.OP.M_d = Inv.OP.V_inv_d/(0.5*Inv.OP.V_dc);
Inv.OP.M_q = Inv.OP.V_inv_q/(0.5*Inv.OP.V_dc);
Inv.OP.Theta = atan(Grid.wg*Inv.OP.I_L1_d*(Inv.Filter.L2+Grid.Lg)/(Grid.V_amp+Inv.OP.I_L1_d*(Inv.Filter.R2+Grid.Rg))); 

%% State matrix calculation of subsystems
% direct-voltage control 
A_DVC = 0;
B_DVC = [1,-1];
C_DVC = [Ctrl.DVC.Ki];
D_DVC = [Ctrl.DVC.Kp,-Ctrl.DVC.Kp];

% alternating-current control
A_ACC = [0,0,0,0;...
         0,0,0,0;...
         0,0,-Ctrl.ACC.K_VFF,0;...
         0,0,0,-Ctrl.ACC.K_VFF];
B_ACC = [1,0,-1,0,0,0,0,0;...
         0,1,0,-1,0,0,0,0;...
         0,0,0,0,Ctrl.ACC.K_VFF,0,0,0;...
         0,0,0,0,0,Ctrl.ACC.K_VFF,0,0];
C_ACC = [Ctrl.ACC.Ki,0,1,0;...
         0,Ctrl.ACC.Ki,0,1];
D_ACC = [Ctrl.ACC.Kp,0,-(Ctrl.ACC.Kp+Ctrl.ACC.K_AD),-Grid.wg*Inv.Filter.L1,0,0,Ctrl.ACC.K_AD,0;...
         0,Ctrl.ACC.Kp,Grid.wg*Inv.Filter.L1,-(Ctrl.ACC.Kp+Ctrl.ACC.K_AD),0,0,0,Ctrl.ACC.K_AD];

% delay effect with Padé approximation
Pade_order = 1;
T_del = 1.5*Ctrl.T_sp;
[num,den] = pade(T_del,Pade_order); 
H = tf(num,den); 
Pade = ss(H);
A_del = blkdiag(Pade.A,Pade.A);
B_del = blkdiag(Pade.B,Pade.B);
C_del = blkdiag(Pade.C,Pade.C);
D_del = blkdiag(Pade.D,Pade.D);

% LCL Filter
A_LCL = [-Inv.Filter.R1/Inv.Filter.L1,Grid.wg,-1/Inv.Filter.L1,0,0,0;...
         -Grid.wg,-Inv.Filter.R1/Inv.Filter.L1,0,-1/Inv.Filter.L1,0,0;...
         1/Inv.Filter.C,0,0,Grid.wg,-1/Inv.Filter.C,0;...
         0,1/Inv.Filter.C,-Grid.wg,0,0,-1/Inv.Filter.C;...
         0,0,1/Inv.Filter.L2,0,-Inv.Filter.R2/Inv.Filter.L2,Grid.wg;...
         0,0,0,1/Inv.Filter.L2,-Grid.wg,-Inv.Filter.R2/Inv.Filter.L2];
B_LCL = [1/Inv.Filter.L1,0,0,0;...
         0,1/Inv.Filter.L1,0,0;...
         0,0,0,0;...
         0,0,0,0;...
         0,0,-1/Inv.Filter.L2,0;...
         0,0,0,-1/Inv.Filter.L2];
C_LCL = eye(6);
D_LCL = zeros(6,4);

% phase-locked loop
A_PLL = [0,0;...
         Ctrl.PLL.Ki,0];
B_PLL = [1;...
         Ctrl.PLL.Kp];
C_PLL = [0,1];
D_PLL = [0];

% dc-link capacitor
A_DC = 1.5*(Inv.OP.V_inv_d*Inv.OP.I_L1_d+Inv.OP.V_inv_q*Inv.OP.I_L1_q)/(Inv.Filter.C_dc*Inv.OP.V_dc*Inv.OP.V_dc);
B_DC = [-1.5*Inv.OP.I_L1_d/(Inv.Filter.C_dc*Inv.OP.V_dc),-1.5*Inv.OP.I_L1_q/(Inv.Filter.C_dc*Inv.OP.V_dc),-1.5*Inv.OP.V_inv_d/(Inv.Filter.C_dc*Inv.OP.V_dc),-1.5*Inv.OP.V_inv_q/(Inv.Filter.C_dc*Inv.OP.V_dc),1/Inv.Filter.C_dc];
C_DC = 1;
D_DC = [0,0,0,0,0];

%% Power angle relationship
% clockwise
T_C = [cos(Inv.OP.Theta),-sin(Inv.OP.Theta);...
       sin(Inv.OP.Theta),cos(Inv.OP.Theta)];
     
% anti-clockwise 
T_A = [cos(Inv.OP.Theta),sin(Inv.OP.Theta);...
       -sin(Inv.OP.Theta),cos(Inv.OP.Theta)];

% system -> control
T_s2c_v_C = [Inv.OP.V_C_q;...
             -Inv.OP.V_C_d];
         
         
T_s2c_i_L1 = [Inv.OP.I_L1_q;...
              -Inv.OP.I_L1_d];
     
T_s2c_i_L2 = [Inv.OP.I_L2_q;...
              -Inv.OP.I_L2_d];

          
% control -> system
T_c2s_v_inv = [-Inv.OP.V_inv_q;...
               Inv.OP.V_inv_d];

%% System interconnection
% u = L1*y + L2*a
% b = L3*y + L4*a
% L1
L_inv_1 = [zeros(1,13);...                                          v_dc,ref        i_ref_d,c
           zeros(1,12),1;...                                        v_dc            v_ref_dq,c
           1,zeros(1,12);...                                        i_ref_d,c       v_inv_dq,c
           zeros(1,13);...                                          i_ref_q,c       i_L1_dq,s
           zeros(2,5),eye(2),zeros(2,4),T_s2c_i_L1,zeros(2,1);...   i_L1_dq,c       v_C_dq,s
           zeros(2,7),eye(2),zeros(2,2),T_s2c_v_C,zeros(2,1);...    v_C_dq,c        i_L2_dq,s
           zeros(2,9),eye(2),T_s2c_i_L2,zeros(2,1);...              i_L2_dq,c       theta_diff
           zeros(2,1),eye(2),zeros(2,10);...                        v_ref_dq,c      v_dc
           zeros(2,3),eye(2),zeros(2,6),T_c2s_v_inv,zeros(2,1);...  v_inv_dq,s
           zeros(2,13);...                                          v_pcc_dq,s
           zeros(1,8),1,zeros(1,2),T_s2c_v_C(2,1),0;...             v_C_q,c
           zeros(2,3),eye(2),zeros(2,6),T_c2s_v_inv,zeros(2,1);...  v_inv_dq,s
           zeros(2,5),eye(2),zeros(2,6);...                         i_L1_dq,s
           zeros(1,13)];                                            %i_dc    
% L2
L_inv_2 = [1,0,0,0,0;...                                            v_dc,ref
           zeros(2,5);...
           0,1,0,0,0;...                                            i_ref_q
           zeros(10,5);...
           zeros(2,3),T_A;...                                       v_pcc_DQ
           zeros(5,5);...
           0,0,1,0,0];                                              %i_pv
% L3
L_inv_3 = [zeros(2,9),T_C,zeros(2,2)];
% L4
L_inv_4 = zeros(2,5);

%% System composition
A_inv_diag = blkdiag(A_DVC,A_ACC,A_del,A_LCL,A_PLL,A_DC);
B_inv_diag = blkdiag(B_DVC,B_ACC,B_del,B_LCL,B_PLL,B_DC);
C_inv_diag = blkdiag(C_DVC,C_ACC,C_del,C_LCL,C_PLL,C_DC);
D_inv_diag = blkdiag(D_DVC,D_ACC,D_del,D_LCL,D_PLL,D_DC);
I = eye(13);

% state matrix
SSM_INV.A = A_inv_diag+B_inv_diag*L_inv_1*((I-D_inv_diag*L_inv_1)^-1)*C_inv_diag;
% input matrix
SSM_INV.B = B_inv_diag*L_inv_1*((I-D_inv_diag*L_inv_1)^-1)*D_inv_diag*L_inv_2+B_inv_diag*L_inv_2;
% output matrix 
SSM_INV.C = L_inv_3*((I-D_inv_diag*L_inv_1)^-1)*C_inv_diag;
% feedthrough matrix
SSM_INV.D = L_inv_3*((I-D_inv_diag*L_inv_1)^-1)*D_inv_diag*L_inv_2+L_inv_4;
% initial value
SSM_INV.OP = Inv.OP;
SSM_INV.INIT = [zeros(1,9),Inv.OP.V_C_d,Inv.OP.V_C_q,zeros(1,3),pi/2-Inv.OP.Theta,Inv.OP.V_dc];

end