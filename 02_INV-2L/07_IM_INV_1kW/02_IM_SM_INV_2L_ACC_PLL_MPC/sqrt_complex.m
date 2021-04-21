%% Square Root Function of Complex Number 
% ########################################################################
% sqrt function for complex number -- b = sqrt(a)
% Input:
%       - [num] the complex vector at current step
%       - [num] the complex vector at last step
%       - [num] number of turns which the complex vector circles around the origin
% Output:
%       - [num] sqrt of the complex vector
%       - [num] number of turns which the complex vector circles around the origin
% Establishment: 15.12.2020 Jiani He, PGS, RWTH Aachen
% Last Change:   15.01.2021 Jiani He, PGS, RWTH Aachen
% ########################################################################

function [b, circle_o] = sqrt_complex(a, a_old, circle_i)
mag_a = abs(a);
phase_a = angle(a)*180/pi;
phase_a_old = angle(a_old)*180/pi;

% check the phase jump
if (phase_a-phase_a_old>180)
    circle_o = circle_i+1;
elseif (phase_a-phase_a_old<-180)
    circle_o = circle_i-1;
else 
    circle_o = circle_i;
end

% solve square root
phase_b = mod((phase_a-360*circle_o)/2,360);
mag_b = sqrt(mag_a);

b = mag_b*cos(phase_b/180*pi)+1i*mag_b*sin(phase_b/180*pi);
end