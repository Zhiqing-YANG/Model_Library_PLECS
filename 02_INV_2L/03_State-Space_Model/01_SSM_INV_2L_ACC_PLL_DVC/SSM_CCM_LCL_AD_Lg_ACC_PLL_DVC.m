%% Numeric State-Space Model
% ########################################################################
% Calculate numeric state matrix
% Input:
%       - [obj] inverter parameter 
%       - [obj] operation point
%       - [obj] grid parameter 
% Output:
%       - [matrix] state matrix 
% Establishment: 27.02.2019 Zhiqing Yang, PGS, RWTH Aachen
% Last Change:   26.06.2019 Christian Bendfeld, PGS, RWTH Aachen
% ########################################################################

function [SSM] = SSM_CCM_LCL_AD_Lg_ACC_PLL_DVC(Inv,OP,Grid,Pade)
%% Parameter

%% State matrix calculation
% direct voltage control
A_DVC = 0;
B_DVC = [1,-1];
C_DVC = [Inv.DVC.Ki];
D_DVC = [Inv.DVC.Kp,-Inv.DVC.Kp];

% alternating current control
A_ACC = [0,0,0,0;...
         0,0,0,0;...
         0,0,-Inv.ACC.K_VFF,0;...
         0,0,0,-Inv.ACC.K_VFF];
B_ACC = [1,0,-1,0,0,0,0,0;...
         0,1,0,-1,0,0,0,0;...
         0,0,0,0,Inv.ACC.K_VFF,0,0,0;...
         0,0,0,0,0,Inv.ACC.K_VFF,0,0];
C_ACC = [Inv.ACC.Ki,0,1,0;...
         0,Inv.ACC.Ki,0,1];
D_ACC = [Inv.ACC.Kp,0,-(Inv.ACC.Kp+Inv.ACC.K_AD),-Grid.wg*Inv.Filter.L1,0,0,Inv.ACC.K_AD,0;...
         0,Inv.ACC.Kp,Grid.wg*Inv.Filter.L1,-(Inv.ACC.Kp+Inv.ACC.K_AD),0,0,0,Inv.ACC.K_AD];

       
% delay and holder
A_del = [Pade.A_dk,0;...
         0,Pade.A_dk];
B_del = [Pade.B_dk,0;...
         0,Pade.B_dk];
C_del = [Pade.C_dk,0;...
         0,Pade.C_dk];
D_del = [Pade.D_dk,0;...
         0,Pade.D_dk];


% LCL Filter
A_LCL = [-Inv.Filter.R1/Inv.Filter.L1,Grid.wg,-1/Inv.Filter.L1,0,0,0;...
         -Grid.wg,-Inv.Filter.R1/Inv.Filter.L1,0,-1/Inv.Filter.L1,0,0;...
         1/Inv.Filter.C,0,0,Grid.wg,-1/Inv.Filter.C,0;...
         0,1/Inv.Filter.C,-Grid.wg,0,0,-1/Inv.Filter.C;...
         0,0,1/(Inv.Filter.L2),0,-(Inv.Filter.R2)/(Inv.Filter.L2),Grid.wg;...
         0,0,0,1/(Inv.Filter.L2),-Grid.wg,-(Inv.Filter.R2)/(Inv.Filter.L2)];
B_LCL = [1/Inv.Filter.L1,0,0,0;...
         0,1/Inv.Filter.L1,0,0;...
         0,0,0,0;...
         0,0,0,0;...
         0,0,-1/(Inv.Filter.L2),0;...
         0,0,0,-1/(Inv.Filter.L2)];
C_LCL = eye(6);
D_LCL = zeros(6,4);

% PLL
A_PLL = [0,0;...
         Inv.PLL.Ki,0];
B_PLL = [1;...
         Inv.PLL.Kp];
C_PLL = [0,1];
D_PLL = [0];

% DC-link
A_DC = [1.5*(OP.V_inv_d*OP.I_L1_d+OP.V_inv_q*OP.I_L1_q)/(Inv.Filter.C_dc*OP.V_dc*OP.V_dc)];
B_DC = [-1.5*OP.I_L1_d/(Inv.Filter.C_dc*OP.V_dc),-1.5*OP.I_L1_q/(Inv.Filter.C_dc*OP.V_dc),-1.5*OP.V_inv_d/(Inv.Filter.C_dc*OP.V_dc),-1.5*OP.V_inv_q/(Inv.Filter.C_dc*OP.V_dc),1/Inv.Filter.C_dc];
C_DC = [1];
D_DC = [0,0,0,0,0];

%% Power angle relationship
% clockwise
T_C = [cos(OP.Theta_diff),-sin(OP.Theta_diff);...
       sin(OP.Theta_diff),cos(OP.Theta_diff)];
     
% anti-clockwise 
T_A = [cos(OP.Theta_diff),sin(OP.Theta_diff);...
       -sin(OP.Theta_diff),cos(OP.Theta_diff)];

% system -> control
T_s2c_v_C = [OP.V_C_q;...
             -OP.V_C_d];

T_s2c_i_L1 = [OP.I_L1_q;...
              -OP.I_L1_d];
     
T_s2c_i_L2 = [OP.I_L2_q;...
              -OP.I_L2_d];

% control -> system
T_c2s_v_inv = [-OP.V_inv_q;...
               OP.V_inv_d];

% composite system model
A_inv_com = blkdiag(A_DVC,A_ACC,A_del,A_LCL,A_PLL,A_DC);
B_inv_com = blkdiag(B_DVC,B_ACC,B_del,B_LCL,B_PLL,B_DC);
C_inv_com = blkdiag(C_DVC,C_ACC,C_del,C_LCL,C_PLL,C_DC);
D_inv_com = blkdiag(D_DVC,D_ACC,D_del,D_LCL,D_PLL,D_DC);

% interconnection
                                                                    %u)             y)
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

L_inv_2 = [1,0,0,0,0;...                                            v_dc,ref
           zeros(2,5);...
           0,1,0,0,0;...                                            i_ref_q
           zeros(10,5);...
           zeros(2,3),T_A;...                                       v_pcc_dq
           zeros(5,5);...
           0,0,1,0,0];                                              %i_dc
       
% b = L_3*y+L_4*a
L_inv_3 = [zeros(2,9),T_C,zeros(2,2)];
L_inv_4 = zeros(2,2);  



%% Network Model
A_grid = [-(Grid.Rg+Grid.Rv)/Grid.Lg,Grid.wg;...
          -Grid.wg,-(Grid.Rg+Grid.Rv)/Grid.Lg];
B_grid = [Grid.Rv/Grid.Lg,0,-1/Grid.Lg,0;...
          0,Grid.Rv/Grid.Lg,0,-1/Grid.Lg];
C_grid = [-Grid.Rv,0;...
          0,-Grid.Rv];
D_grid = [Grid.Rv,0,0,0;...
          0,Grid.Rv,0,0];

      
%% Complete Microgrid Model
% composote model
A_sym_com = blkdiag(A_inv_com,A_grid);
B_sym_com = blkdiag(B_inv_com,B_grid);
C_sym_com = blkdiag(C_inv_com,C_grid);
D_sym_com = blkdiag(D_inv_com,D_grid);

% interconnection matrixes
L_sym_1 = [L_inv_1,L_inv_2(:,4),L_inv_2(:,5);...
           L_inv_3,L_inv_4(:,1),L_inv_4(:,2);...
           zeros(2,15)];
L_sym_2 = [L_inv_2(:,1),L_inv_2(:,2),L_inv_2(:,3),zeros(22,2);...
           zeros(2,5);...
           zeros(2,3),eye(2)];
       
% Desired state equation and output equation
A = A_sym_com+B_sym_com*L_sym_1*(eye(15)-D_sym_com*L_sym_1)^(-1)*C_sym_com;
B = B_sym_com*L_sym_1*(eye(15)-D_sym_com*L_sym_1)^(-1)*D_sym_com*L_sym_2+B_sym_com*L_sym_2;
% output matrix 
C = eye(18);
% feedthrough matrx
D = zeros(18,5);

SSM = ss(A,B,C,D);



end