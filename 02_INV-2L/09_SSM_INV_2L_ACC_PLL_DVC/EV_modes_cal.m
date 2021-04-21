%% Eigenvalues modes
% ########################################################################
% to plot eigenvalues distribution
% to calculate oscillation frequency and damping ratio
%
% Establishment:    10.08.2018 Qilei Wang, PGS, RWTH Aachen
% Last Change:      04.07.2019 Christian Bendfeld, PGS, RWTH Aachen
% ########################################################################

function [Index] = EV_modes_cal(varargin)

l = length(varargin);

format short g
EV = eig(varargin{1}.A);
n = length(EV);


%% Oscillation
% oscillation frequency
Saver_fi = zeros(n,1);
f_i = zeros(n,1);
for i = 1:n
    Saver_fi(i) = imag(EV(i));
    f_i(i) = abs(Saver_fi(i))/(2*pi);
end


% Damping ratio
Saver_di = zeros(n,1);
d_i = zeros(n,1);
for i = 1:n
    Saver_di(i) = real(EV(i));
    d_i(i) = -Saver_di(i)/sqrt(abs(Saver_di(i)^2)+abs(Saver_fi(i)^2));
end

Index = find(d_i==min(d_i));


M = [f_i,d_i];

disp('          Eigenvalues')
disp(EV)
disp('     Frequency   Damping ratio')
disp(M)


% figure
% for i = 1:length(varargin)
%     pzmap(varargin{i});
%     hold on
% end
% a = findobj(gca,'type','line');
% for i = 1:length(a)
%     set(a(i),'markersize',8) %change marker size
%     set(a(i), 'linewidth',1.5)  %change linewidth
% end
% set(gca, 'XLim', [-3000, get(gca, 'XLim') * [0; 1]])
% %xlim([-2500 0])

figure
for i = 1:1:n
    s = scatter(real(EV(i)),imag(EV(i)),50,'x','Linewidth',1.5);
    s.MarkerEdgeColor = [75 128 232]/255;
hold on
end
hold off
box on
grid on
set(gca,'FontSize',14,'Fontname','Times New Roman');
xlabel('Real axis in rad/s','Fontsize',16,'Fontname','Times New Roman');
ylabel('Imaginary axis in rad/s','Fontsize',16,'Fontname','Times New Roman');
xlim([-3000 100])

end

