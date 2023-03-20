% Bond angle plotting

% Take bond angle data made by python analysis and make a pretty plot.
fig = gcf;
set(gcf, 'renderer', 'opengl')
% import data
data = readtable('C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\p500\u_combined_o5\bond_angles_2p1.csv');

% data = readtable('C:\Eric\Xerox\Python\peri\1-6-18 data\128x128x50 p500\bond_dist_50nm.csv');
% data2 = readtable('C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\p0\u_combined_o5\bond_angles_2p1.csv');

red = [228,26,28]/255;
blu = [55,126,184]/255;
grn = [77,175,74]/255;
pur = [152,78,163]/255;
org = [255,127,0]/255;
brn = [166,86,40]/255;

% Standard plot
% plot(data.centers_a, data.pdf_a, 'b:o')

% polar plot azimuthal angles
plt = polarplot(data.centers_a([1:end 1])*pi/180., data.pdf_a([1:end 1]), ...
    'Color','b', 'LineStyle', '-', 'Marker', 'o', 'MarkerFaceColor', 'b',...
    'MarkerSize', 4);
ax = gca;
ax.RGrid = 'on';
ax.FontSize = 18;
ax.RLim = ([0 0.05]);
% ax.RTick = [0.04];

ax.TickLength = [0.1 0];
ax.ThetaMinorTick = 'on';
ax.ThetaAxis.TickValues = 0:90:360;
% ax.ThetaAxis.TickLabels = [0:90:360];
ax.RAxis.TickValues = [0.01:0.01:0.05];
ax.RAxis.MinorTick = 'on';
ax.RAxis.MinorTickValues = [0.01 0.02 0.03];
ax.RAxis.FontSize = 14;
ax.ThetaAxis.MinorTick = 'on';
ax.ThetaAxis.MinorTickValues = 0:30:360;
% ax.OuterPosition = [0 0 1 1];
ax.Position = [0.13 0.11 .775 .815];
ax.LineWidth = 1;
% ax.GridColor = [0 0 0];
% ax.GridAlpha = 1;

%set figure size
% t = title('Shear-vorticity plane');
fig.PaperUnits = 'inches';
fig.PaperPosition = [ 1 1 3.375 3.375];

print('C:\Eric\Xerox\Figures\1-6-18 figures\bond angle plots 2.1 um\p500_azi.eps', '-depsc', '-r800')
% print('Testplot', '-dtiffn', '-r800')
print('C:\Eric\Xerox\Figures\1-6-18 figures\bond angle plots 2.1 um\p500_azi.tif', '-dtiffn', '-r800')


%% polar plot xz - plane
plt = polarplot(data.centers_xz([1:end 1])*pi/180., data.pdf_xz([1:end 1]), ...
    'Color', grn, 'LineStyle', '-', 'Marker', 'o', 'MarkerFaceColor', grn,...
    'MarkerSize', 4);
ax = gca;
ax.RGrid = 'on';
ax.FontSize = 18;
ax.RLim = ([0 0.05]);
% ax.RTick = [0.04];

ax.TickLength = [0.1 0];
ax.ThetaMinorTick = 'on';
ax.ThetaAxis.TickValues = 0:90:360;
% ax.ThetaAxis.TickLabels = [0:90:360];
ax.RAxis.TickValues = [0.01:0.01:0.05];
ax.RAxis.MinorTick = 'on';
ax.RAxis.MinorTickValues = [0.01 0.02 0.03];
ax.RAxis.FontSize = 14;
ax.ThetaAxis.MinorTick = 'on';
ax.ThetaAxis.MinorTickValues = 0:30:360;
% ax.OuterPosition = [0 0 1 1];
ax.Position = [0.13 0.11 .775 .815];
ax.LineWidth = 1;
% ax.GridColor = [0 0 0];
% ax.GridAlpha = 1;

%set figure size
% t = title('Shear-vorticity plane');
fig.PaperUnits = 'inches';
fig.PaperPosition = [ 1 1 3.375 3.375];

print('C:\Eric\Xerox\Figures\1-6-18 figures\bond angle plots 2.1 um\p500_xz.eps', '-depsc', '-r800')
% print('Testplot', '-dtiffn', '-r800')
print('C:\Eric\Xerox\Figures\1-6-18 figures\bond angle plots 2.1 um\p500_xz.tif', '-dtiffn', '-r800')

%% polar plot yz - plane
plt = polarplot(data.centers_yz([1:end 1])*pi/180., data.pdf_yz([1:end 1]), ...
    'Color', red, 'LineStyle', '-', 'Marker', 'o', 'MarkerFaceColor', red,...
    'MarkerSize', 4);
ax = gca;
ax.RGrid = 'on';
ax.FontSize = 18;
ax.RLim = ([0 0.05]);
% ax.RTick = [0.04];

ax.TickLength = [0.1 0];
ax.ThetaMinorTick = 'on';
ax.ThetaAxis.TickValues = 0:90:360;
% ax.ThetaAxis.TickLabels = [0:90:360];
ax.RAxis.TickValues = [0.01:0.01:0.05];
ax.RAxis.MinorTick = 'on';
ax.RAxis.MinorTickValues = [0.01 0.02 0.03];
ax.RAxis.FontSize = 14;
ax.ThetaAxis.MinorTick = 'on';
ax.ThetaAxis.MinorTickValues = 0:30:360;
% ax.OuterPosition = [0 0 1 1];
ax.Position = [0.13 0.11 .775 .815];
ax.LineWidth = 1;
% ax.GridColor = [0 0 0];
% ax.GridAlpha = 1;

%set figure size
% t = title('Shear-vorticity plane');
fig.PaperUnits = 'inches';
fig.PaperPosition = [ 1 1 3.375 3.375];

print('C:\Eric\Xerox\Figures\1-6-18 figures\bond angle plots 2.1 um\p500_yz.eps', '-depsc', '-r800')
% print('Testplot', '-dtiffn', '-r800')
print('C:\Eric\Xerox\Figures\1-6-18 figures\bond angle plots 2.1 um\p500_yz.tif', '-dtiffn', '-r800')

%% Polar angles

% repeat 180 degrees for other side of circle
polar_centers = zeros(2*length(data.centers_p),1);
polar_norm_pdf = zeros(2*length(data.centers_p),1);
for i =1:length(data.centers_p)
    polar_centers(i) = data.centers_p(i);
    polar_norm_pdf(i) = data.norm_pdf_p(i);
end
for i = 1:length(data.centers_p)
    polar_centers(i + length(data.centers_p)) = data.centers_p(i) + 180;
    polar_norm_pdf(i + length(data.centers_p)) = data.norm_pdf_p(i);
end

figure;
% polar plot polar angles
plt = polarplot(polar_centers([1:end 1])*pi/180., polar_norm_pdf([1:end 1]), ...
    'Color',grn, 'LineStyle', '-', 'Marker', 'o', 'MarkerFaceColor', grn,...
    'MarkerSize', 4);
ax = gca;
ax.RGrid = 'on';
ax.RLim = ([0 0.05]);
% ax.RTick = [0.04];
ax.FontSize = 18;
ax.TickLength = [0.1 0];
ax.ThetaMinorTick = 'on';
ax.ThetaAxis.TickValues = 0:90:360;
ax.ThetaAxis.Direction = 'reverse';
ax.ThetaZeroLocation = 'top';
% ax.ThetaAxis.TickLabels = [0:90:360];

% ax.RAxis.TickValues = 0.04;
ax.RAxis.MinorTick = 'on';
ax.RAxis.MinorTickValues = [0.01 0.02 0.03];
ax.RAxis.FontSize = 14;
ax.ThetaAxis.MinorTick = 'on';
ax.ThetaAxis.MinorTickValues = 0:30:360;
% ax.OuterPosition = [0 0 1 1];
ax.Position = [0.13 0.11 .775 .815];
ax.LineWidth = 1;

% ax.GridColor = [0 0 0];
% ax.GridAlpha = 1;

%set figure size
fig.PaperUnits = 'inches';
fig.PaperPosition = [ 1 1 3.375 3.375];

print('C:\Eric\Xerox\Figures\1-6-18 figures\bond angle plots 2.1 um\p500_polar.eps', '-depsc', '-r800')
% print('Testplot', '-dtiffn', '-r800')
print('C:\Eric\Xerox\Figures\1-6-18 figures\bond angle plots 2.1 um\p500_polar.tif', '-dtiffn', '-r800')

% %% polar histogram azimuthal angles
% % make full edges plot
% diff = data.l_edges_a(2)- data.l_edges_a(1);
% edges_a = [data.l_edges_a; data.l_edges_a(end) + diff];
% 
% figure;
% ph = polarhistogram('BinEdges', edges_a'*pi/180., 'BinCounts', data.pdf_a');
% ph.DisplayStyle = 'stairs';
% 


% %% Test
% figure;
% theta = linspace(0,2*pi, 1000);
% rho = sin(theta);
% polarplot(theta,rho)
% % print('Testplot', '-depsc', '-r800')
% %% Test 2
% figure;
% plt2 = plot(0,0);
% ax1 =gca;
% ax1.XLim = [0 0.05];
% ax1.XTick = [];
% % ax1.XTick = [0.01:0.01:0.05];
% ax1.YLim = [0 0.05];
% ax1.YTick = [0.01:0.01:0.05];
