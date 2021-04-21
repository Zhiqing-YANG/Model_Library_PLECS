function [Pade] = Pade_cal(Pade,Inv)
% pade approximation
k = Pade.order;                         % [] order of Pade approximation 
T_del = 1.5*Inv.T_sp;

Pade.A_dk = zeros(k,k);
Pade.B_dk = zeros(k,1);
Pade.C_dk = zeros(1,k);
switch k
    case 0
        Pade.A_dk = 0;
        Pade.B_dk = 0;
        Pade.C_dk = 0;
        Pade.D_dk = 1;
    case 1
         l = k;
         j = 0;
         a_j = (factorial(l+k-j)*factorial(k))/(factorial(j)*factorial(k-j));
         b_j = (-1)^j*(factorial(l+k-j)*factorial(l))/(factorial(j)*factorial(l-j));
         a_k = (factorial(l+k-k)*factorial(k))/(factorial(k)*factorial(k-k));
         b_k = (-1)^k*(factorial(l+k-k)*factorial(l))/(factorial(k)*factorial(l-k));
         Pade.A_dk = -a_j*T_del^(-k+j)/a_k;
         Pade.B_dk(k,1) = 1;
         Pade.C_dk(1,j+1)=1/(a_k)^2*(a_k*b_j-a_j*b_k)*T_del^(-k+j);
         Pade.D_dk = b_k/a_k;
    otherwise
        l = k;
        for x = 1:1:k-1
            y = x+1;
            Pade.A_dk(x,y) = 1;       
        end
        for j = 0:1:k-1
            a_j = (factorial(l+k-j)*factorial(k))/(factorial(j)*factorial(k-j));
            b_j = (-1)^j*(factorial(l+k-j)*factorial(l))/(factorial(j)*factorial(l-j));
            a_k = (factorial(l+k-k)*factorial(k))/(factorial(k)*factorial(k-k));
            b_k = (-1)^k*(factorial(l+k-k)*factorial(l))/(factorial(k)*factorial(l-k));
            Pade.A_dk(k,j+1) = -a_j*T_del^(-k+j)/a_k;
            Pade.B_dk(k,1) = 1;
            Pade.C_dk(1,j+1)=1/(a_k)^2*(a_k*b_j-a_j*b_k)*T_del^(-k+j);
            Pade.D_dk = b_k/a_k;
         end                         
end

end

