%% Find the Phase Margin in Nyquist Plot 
% ########################################################################
% find the phase margin in nyquist plot 
% Input:
%       - [matrix] the eigenvalues at a given frequency range
%       - [vector] a frequency range
%       - [num] number of sample points
%       - [num] option
%               opt = 0 don't print
%               opt = 1 print phase margin of each eigenvalue
%               opt = 2 print the smaller phase margin of two eigenvalues
% Output:
%       - [vector] vector of frequencies of unit mag. points
%       - [vector] vector of phase margin
% Establishment: 25.01.2020 Jiani He, PGS, RWTH Aachen
% ########################################################################

function [f_int,phs_int] = find_phase_margin_Nyq(e,f_swp,n_sample,opt)
% initialization
f_int = [];
phs_int = [];
phs_int_min = 180;

% eigenvalue 1
if opt == 1
    fprintf('Eigenvalue 1:\n');
end
mag1 = 20*log10(abs(e(1,:)));
phase1 = 180/pi*angle(e(1,:));

for i = 1:n_sample-1
    if mag1(i)<0 && mag1(i+1)>0
        i_int_1 = i;
        if phase1(i) > 0
            phase_margin1 = 180-phase1(i);
        else
            phase_margin1 = -180-phase1(i);
        end
        break;
    end
end


if opt == 1
    fprintf('Unit circle intersection point @ %.2f Hz, phase margin: %.2f dB. \n',f_swp(i_int_1),phase_margin1);
end

if phase_margin1 < phs_int_min
    phs_int_min = phase_margin1;
    f_int_min = f_swp(i_int_1);
    e_int_min = 1;
end
f_int = [f_int, f_swp(i_int_1)];
phs_int = [phs_int, phase_margin1];


% eigenvalue 2
if opt == 1
    fprintf('Eigenvalue 2:\n');
end
mag2 = 20*log10(abs(e(2,:)));
phase2 = 180/pi*angle(e(2,:));

for i = 1:n_sample-1
    if mag2(i)<0 && mag2(i+1)>0
        i_int_2 = i;
        if phase2(i) > 0
            phase_margin2 = 180-phase2(i);
        else
            phase_margin2 = -180-phase2(i);
        end
        break
    end
end

if opt == 1
    fprintf('Unit circle intersection point @ %.2f Hz, phase margin: %.2f dB. \n',f_swp(i_int_2),phase_margin2);
end

if phase_margin2 < phs_int_min
    phs_int_min = phase_margin2;
    f_int_min = f_swp(i_int_2);
    e_int_min = 2;
end
f_int = [f_int, f_swp(i_int_2)];
phs_int = [phs_int, phase_margin2];

if opt == 2
    if phs_int_min ~= 180
        fprintf('Eigenvalue %d has the minimum phase margin %.2f deg @ %.2f Hz. \n',e_int_min,phs_int_min,f_int_min);
    end
end

end