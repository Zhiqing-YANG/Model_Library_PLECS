%% Find the -180/180 Phase Jump Points in Frequency Response Plot 
% ########################################################################
% find the -180/180 phase jump points in frequency response plot 
% Input:
%       - [matrix] the eigenvalues at a given frequency range
%       - [vector] a frequency range
%       - [num] number of sample points
%       - [num] option
%               opt = 0 don't print
%               opt = 1 print every phase jump point
%               opt = 2 print the phase jmp point with maximum magnitude
% Output:
%       - [vector] vector of frequency where -180/180 phase jump happens
%       - [vector] vector of magnitude where -180/180 phase jump happens
% Establishment: 07.01.2020 Jiani He, PGS, RWTH Aachen
% Last Change:   15.01.2021 Jiani He, PGS, RWTH Aachen
% ########################################################################

function [f_jmp,mag_jmp] = find_phase_jump_FreqResp(e,f_swp,n_sample,opt)
f_jmp = [];
mag_jmp = [];
mag_jmp_max = -100;

% eigenvalue 1
if opt == 1
    fprintf('Eigenvalue 1:\n');
end
mag1 = 20*log10(abs(e(1,:)));
phase1 = 180/pi*angle(e(1,:));
i_jump_1 = [];
for i = 1:n_sample-1
    if phase1(i+1)-phase1(i)>180
        i_jump_1 = [i_jump_1,i];
    end
end

n = 1;
for i = i_jump_1
    if opt == 1
        fprintf('Phase jump point %d @ %.2f Hz, magnitude: %.2f dB. \n',n,f_swp(i),mag1(i));
    end
    if mag1(i) > mag_jmp_max
        mag_jmp_max = mag1(i);
        f_jmp_max = f_swp(i);
        e_jmp_max = 1;
    end
    f_jmp = [f_jmp, f_swp(i)];
    mag_jmp = [mag_jmp, mag1(i)];
    n = n+1;
end

% eigenvalue 2
if opt == 1
    fprintf('Eigenvalue 2:\n');
end
mag2 = 20*log10(abs(e(2,:)));
phase2 = 180/pi*angle(e(2,:));
i_jump_2 = [];
for i = 1:n_sample-1
    if phase2(i+1)-phase2(i)>180
        i_jump_2 = [i_jump_2,i];
    end
end

n = 1;
for i = i_jump_2
    if opt == 1
        fprintf('Phase jump point %d @ %.2f Hz, magnitude: %.2f dB. \n',n,f_swp(i),mag2(i));
    end
    if mag2(i) > mag_jmp_max
        mag_jmp_max = mag2(i);
        f_jmp_max = f_swp(i);
        e_jmp_max = 2;
    end
    f_jmp = [f_jmp, f_swp(i)];
    mag_jmp = [mag_jmp, mag2(i)];
    n = n+1;
end

if opt == 2
    if mag_jmp_max ~= -100
        fprintf('Phase jump of eigenvalue %d @ %.2f Hz, magnitude: %.2f dB. \n',e_jmp_max,f_jmp_max,mag_jmp_max);
    end
end
end