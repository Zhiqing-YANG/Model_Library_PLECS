%% Find the Magnitude Intersection Points in Bode Plot 
% ########################################################################
% find the magnitude intersection points in Bode plot 
% Input:
%       - [obj] impedance Z1 at a given frequency range
%       - [obj] impedance Z2 at a given frequency range
%       - [vector] a frequency range
%       - [num] number of sample points
%       - [num] option
%               opt = 0 don't print
%               opt = 1 print every intersection point 
%               opt = 2 print the intersection point with max. phase difference
% Output:
%       - [obj] vector of frequency where |Z1.dd|&|Z2.dd| or |Z1.qq|&|Z2.qq| intersect 
%       - [obj] vector of phase difference where |Z1.dd|&|Z2.dd| or |Z1.qq|&|Z2.qq| intersect
% Establishment: 07.01.2020 Jiani He, PGS, RWTH Aachen
% Last Change:   15.01.2021 Jiani He, PGS, RWTH Aachen
% ########################################################################

function [f_int,phs_int] = find_intersection_Bode(Z1,Z2,f_swp,n_sample,opt)
f_int.dd = [];
f_int.qq = [];
phs_int.dd = [];
phs_int.qq = [];
d_angle_max = 0;

% dd axis
if opt == 1
    fprintf('dd axis:\n');
end
d_abs_dd = abs(Z1.dd)-abs(Z2.dd);
d_angle_dd = abs((angle(Z1.dd)-angle(Z2.dd))/pi*180);
i_int_dd = [];
for i = 1:n_sample-1
    if d_abs_dd(i)*d_abs_dd(i+1)<0
        i_int_dd = [i_int_dd,i];
    end
end

n=1;
for i = i_int_dd
    if opt == 1
        fprintf('Intersection point %d @ %.2f Hz, phase difference: %.2f deg. \n',n,f_swp(i),d_angle_dd(i));
    end
    if d_angle_dd(i) > d_angle_max
        d_angle_max = d_angle_dd(i);
        f_int_max = f_swp(i);
        axis_int_max = 1;
    end
    f_int.dd = [f_int.dd, f_swp(i)];
    phs_int.dd = [phs_int.dd, d_angle_dd(i)];
    n = n+1;
end

% qq axis
if opt == 1
    fprintf('qq axis:\n');
end
d_abs_qq = abs(Z1.qq)-abs(Z2.qq);
d_angle_qq = abs((angle(Z1.qq)-angle(Z2.qq))/pi*180);
i_int_qq = [];
for i = 1:n_sample-1
    if d_abs_qq(i)*d_abs_qq(i+1)<0
        i_int_qq = [i_int_qq,i];
    end
end

n=1;
for i = i_int_qq
    if opt == 1
        fprintf('Intersection point %d @ %.2f Hz, phase difference: %.2f deg. \n',n,f_swp(i),d_angle_qq(i));
    end
    if d_angle_qq(i) > d_angle_max
        d_angle_max = d_angle_qq(i);
        f_int_max = f_swp(i);
        axis_int_max = 2;
    end
    f_int.qq = [f_int.qq, f_swp(i)];
    phs_int.qq = [phs_int.qq, d_angle_qq(i)];
    n = n+1;
end

if opt == 2
    if axis_int_max == 1
        fprintf('Intersection point in dd axis @ %.2f Hz, phase difference: %.2f deg. \n',f_int_max,d_angle_max);
    elseif axis_int_max == 2
        fprintf('Intersection point in qq axis @ %.2f Hz, phase difference: %.2f deg. \n',f_int_max,d_angle_max);
    end
end
end