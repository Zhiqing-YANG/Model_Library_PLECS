%% Define Color Object
% ########################################################################
% Refer to the color template from RWTH Aachen University
% https://www9.rwth-aachen.de/global/show_document.asp?id=aaaaaaaaaadpbhq
% Establishment: 24.07.2021 Zhiqing Yang, PGS, RWTH Aachen
% ########################################################################

function Color = Def_Color()
%% Blue
Color.blue.p100 = [0,84,159]/255;
Color.blue.p75 = [64,127,183]/255;
Color.blue.p50 = [142,186,229]/255;

%% red
Color.red.p100 = [204,7,30]/255;
Color.red.p75 = [216,92,65]/255;
Color.red.p50 = [230,150,121]/255;

%% other colors
Color.black.p50 = [156,158,159]/255;
Color.magenta.p75 = [233,96,136]/255;
Color.green.p75 = [141,192,96]/255;
Color.orange.p75 = [250,190,80]/255;
Color.violett.p75 = [131,78,117]/255;

end