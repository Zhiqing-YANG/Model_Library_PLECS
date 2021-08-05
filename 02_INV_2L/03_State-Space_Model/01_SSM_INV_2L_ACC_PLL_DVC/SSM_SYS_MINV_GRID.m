%% System Numeric State-Space Model
% ########################################################################
% Calculate numeric state matrix of a multi-inverter system
% Input:
%       - [obj] inverter parameter 
%       - [obj] control parameter
%       - [obj] grid parameter 
% Output:
%       - [obj] state-space model
% Establishment: 24.06.2019 Christian Bendfeld PGS, RWTH Aachen
% ########################################################################

function SSM_SYS = SSM_SYS_MINV_GRID(Grid,varargin)
%% Determine number of inverters 
n = length(varargin);    

%% State matrix calculation of subsystems
% multiple inverters
for i = 1:n
    A_minv{i} = varargin{i}.A;
    B_minv{i} = varargin{i}.B;
    C_minv{i} = varargin{i}.C;
    D_minv{i} = varargin{i}.D;
    OP_minv{i} = varargin{i}.OP;
    INIT_minv{i} = varargin{i}.INIT;
end

% grid
A_g = [-(Grid.Rg+Grid.Rv)/Grid.Lg,Grid.wg;...
       -Grid.wg,-(Grid.Rg+Grid.Rv)/Grid.Lg];   
for i = 1:n
    B_g_h{i} = Grid.Rv/Grid.Lg*eye(2);
end
B_g = [B_g_h{:},-1/Grid.Lg*eye(2)];
C_g = [-Grid.Rv,0;...
       0,-Grid.Rv;...
       1,0;...
       0,1];  
for i = 1:n
      D_g_h{i} = Grid.Rv*eye(2);
end
D_g = [D_g_h{:},zeros(2,2);...
       zeros(2,2+2*n)];

%% System interconnection
% u = L1*y + L2*a
% b = L3*y + L4*a
% L1
L_minv_1 = [zeros(3,4+2*n);...
            zeros(2,2*n),eye(2),zeros(2,2)];
for i = 2:n
    L_minv_1 = [L_minv_1;
                zeros(3,4+2*n);...
                zeros(2,2*n),eye(2),zeros(2,2)];
end
L_g_1 = [eye(2*n),zeros(2*n,4);...
         zeros(2,2*n+4)];
L_sys_1 = [L_minv_1;
           L_g_1];
% L2
L_minv_2 = [eye(3),zeros(3,3*n-1);...
            zeros(2,2+3*n)];...
for i = 2:n
    L_minv_2 = [L_minv_2;...
                zeros(3,3*(i-1)),eye(3),zeros(3,3*n-1-3*i+3);...
                zeros(2,2+3*n)];
end         
L_g_2 = [zeros(2*n,2+3*n);...
         zeros(2,3*n),eye(2)];
        
L_sys_2 =  [L_minv_2;...
            L_g_2]; 

%% System composition
A_sys_diag = blkdiag(A_minv{:},A_g);
B_sys_diag = blkdiag(B_minv{:},B_g);
C_sys_diag = blkdiag(C_minv{:},C_g);
D_sys_diag = blkdiag(D_minv{:},D_g);
I = eye(4+2*n);

% state matrix
SSM_SYS.A = A_sys_diag+B_sys_diag*L_sys_1*(I-D_sys_diag*L_sys_1)^-1*C_sys_diag;
% input matrix
SSM_SYS.B = B_sys_diag*L_sys_1*(I-D_sys_diag*L_sys_1)^(-1)*D_sys_diag*L_sys_2+B_sys_diag*L_sys_2;
% output matrix 
for i = 1:n
    C_minv{i} = [eye(7),zeros(7,9);...

                zeros(1,7),1,0,zeros(1,5),OP_minv{i}.I_L1_q,0;...
                zeros(1,7),0,1,zeros(1,5),-OP_minv{i}.I_L1_d,0;...

                zeros(1,9),1,0,zeros(1,3),OP_minv{i}.V_C_q,0;...
                zeros(1,9),0,1,zeros(1,3),-OP_minv{i}.V_C_d,0;...
                
                zeros(1,11),1,0,0,OP_minv{i}.I_L2_q,0;...
                zeros(1,11),0,1,0,-OP_minv{i}.I_L2_d,0;...
                
                zeros(3,13),eye(3)];
end    
SSM_SYS.C = blkdiag(C_minv{:},eye(2));
% feedthrough matrix
SSM_SYS.D = zeros(2+16*n,2+3*n);
% initial value
SSM_SYS.INIT = [INIT_minv{:},zeros(1,2)];

end