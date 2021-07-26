%% Eigenvalue Resonant Mode Calculation
% ########################################################################
% Calculate resonant frequency and damping ratio of all eigenvalues
% Input:
%       - [obj] state-space model
% Output:
%       - [obj] eigenvalue
% Establishment:    25.07.2021 Zhiqing Yang, PGS, RWTH Aachen
% ########################################################################

function EV = EV_RES_cal(SSM)
%% Data pre-processing
format short g
EV.Value = eig(SSM.A);
n = length(EV.Value);

%% Resonant mode calculation
% resonant frequency
for i = 1:n
    EV.ResReq(i) = abs(imag(EV.Value(i)))/(2*pi);
end

% Damping ratio
for i = 1:n
    EV.DampRatio(i) = -real(EV.Value(i))/sqrt(real(EV.Value(i))^2+abs(imag(EV.Value(i))^2));
end

Index = find(EV.DampRatio==min(EV.DampRatio));
EV.Dominant = [EV.ResReq(Index),EV.DampRatio(Index)];
ResMode = [EV.ResReq',EV.DampRatio'];

%% Print and plot results
% define color
Color = Def_Color;

% print results
disp('          Eigenvalues')
disp(EV.Value)
disp('     Frequency   Damping ratio')
disp(ResMode)

% plot eigenvalues
figure
for i = 1:n
    s = scatter(real(EV.Value(i)),imag(EV.Value(i)),50);
    s.MarkerEdgeColor = Color.blue.p100;
    s.MarkerFaceColor = Color.blue.p75;
    s.LineWidth = 1.5;
    hold on
end

hold off
grid on
box on
set(gca, 'XLim', [-3000, get(gca, 'XLim') * [0; 1]])
%xlim([-2500 0])
set(gca,'FontSize',14,'Fontname', 'Times New Roman');
ylabel('Imaginary part in rad/s','FontSize',14,'Fontname', 'Times New Roman');
xlabel('Real part in rad/s','FontSize',14,'Fontname', 'Times New Roman');


end

