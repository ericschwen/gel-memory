% ampsweep plot magnitudes figures

% take files saved using ampsweep_save_magnitudes and plot the results
% v2: start adding in y-uncertainties
% v3: band errors added (filled)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Import amp-sweeep data
folder = 'C:\Eric\Xerox Data\30um gap runs\0.3333Hz 4-11-17\1.4V\';
% folder = 'C:\Eric\Xerox Data\30um gap runs\0.5Hz combined gel runs 1-17-17\0.4V\';
% folder = 'C:\Eric\Xerox Data\30um gap runs\5-1-19\0.6V\untrained-after\';
fileList = {'ampsweep_post_sweep', 'ampsweep_pre_train'};
% fileList = {'ampsweep-pre-train', 'ampsweep-post-train'};
% fileList = {'ampsweep'};
% folder = 'D:\Xerox Data\30um gap runs\7-3-18 data\0.9V\';
% fileList = {'ampsweep-pre-train', 'ampsweep-post-train'};
ampV = 1.4;

suffix = '_imageDiff';

fileNumbers = 1:1:length(fileList);
numfiles = length(fileList);

% Declare cell array sizes.
filename = cell(numfiles,1);
strainAmpFilepath = cell(numfiles,1);
strainAmps_x = cell(numfiles,1);
IDFilepath = cell(numfiles,1);
IDErrFilepath = cell(numfiles,1);
imageDiff_x = cell(numfiles,1);
imageDiffErr_x = cell(numfiles,1);

legendInfo = cell(numfiles,1);


for i = fileNumbers
    filename{i} = [folder, fileList{i}, suffix];
    
    % strain amplitude and image difference file paths
    strainAmpFilepath{i} = [filename{i} '\strainAmplitudes.csv'];
    IDFilepath{i} = [filename{i} '\imageDifferenceAmpsweep.csv'];
    IDErrFilepath{i} = [filename{i}, '\imageDifferenceAmpsweepErr.csv'];
    
    strainAmps_x{i} = xlsread(strainAmpFilepath{i});
    imageDiff_x{i} = xlsread(IDFilepath{i});
    imageDiffErr_x{i} = xlsread(IDErrFilepath{i});
end

%% Plot area error bar (test version)

% Conversion Volts to strain
v2s = 0.14;

options.x_axis{1} = strainAmps_x{1}*v2s;
options.x_axis{2} = strainAmps_x{2}*v2s;

red = [228,26,28]/255;
blu = [55,126,184]/255;
grn = [77,175,74]/255;
pur = [152,78,163]/255;
org = [255,127,0]/255;
brn = [166,86,40]/255;

options.color_area_x{1} = blu;
options.color_line_x{1} = blu;
options.color_area_x{2} = pur;
options.color_line_x{2} = pur;
options.alpha      = 0.2;
options.line_width = 1.5;
options.marker_size = 22;

figure;
hold on;
% Plot vertical line for training amplitude
trainingAmplitude = ampV*v2s;
plot_train = plot(ones(100,1) * trainingAmplitude, 0.002:0.002:0.2, 'k--',...
    'LineWidth', options.line_width);

% Plot image difference
x_vector{1} = [options.x_axis{1}', fliplr(options.x_axis{1}')];
patch_x{1} = fill(x_vector{1}, [imageDiff_x{1}'+imageDiffErr_x{1}',...
    fliplr(imageDiff_x{1}'-imageDiffErr_x{1}')], options.color_area_x{1});
set(patch_x{1}, 'edgecolor', 'none');
set(patch_x{1}, 'FaceAlpha', options.alpha);
plot_x{1} = plot(strainAmps_x{1}*v2s, imageDiff_x{1}, '-k.', ...
    'MarkerSize', options.marker_size, 'color', options.color_line_x{1}, ...
    'LineWidth', options.line_width);

x_vector{2} = [options.x_axis{2}', fliplr(options.x_axis{2}')];
patch_x{2} = fill(x_vector{2}, [imageDiff_x{2}'+imageDiffErr_x{2}',...
    fliplr(imageDiff_x{2}'-imageDiffErr_x{2}')], options.color_area_x{2});
set(patch_x{2}, 'edgecolor', 'none');
set(patch_x{2}, 'FaceAlpha', options.alpha);
plot_x{2} = plot(strainAmps_x{2}*v2s, imageDiff_x{2}, '-k.', ...
    'MarkerSize', options.marker_size, 'color', options.color_line_x{2}, ...
    'LineWidth', options.line_width);

xlabel('Strain \gamma','FontSize', 18);
ylabel('Mean image difference \langle\mid\DeltaI\mid\rangle','FontSize', 18);

lgd = legend([plot_x{1}, plot_x{2}, plot_train], ...
    'Trained', 'Untrained', 'Training strain',...
    'Location', 'northwest');
lgd.FontSize = 14;

axis([0 0.4 0.02 0.16]);

% xticks(0.0:0.1:0.3)
% yticks(0.02:0.02:0.16);
yticks(0.02:0.02:0.16);

% axis([0 max(strainAmps_x{1})*v2s 0.02 0.3]);

xt = get(gca,'XTick');
set(gca, 'FontSize', 16);
box on
hold off;



%% Plot ampsweep data with vertical line at training amplitude

figure;
hold on;
% plot(strainAmps{1}*v2s,imageDiff{1},'b:^', 'MarkerFaceColor', 'b')
errorbar(strainAmps_x{1}(1:end)*v2s,imageDiff_x{1}(1:end), imageDiffErr_x{1}(1:end), 'b:^', 'MarkerFaceColor', 'b')
legendInfo{1} = 'Untrained';
% plot(strainAmps{2}*v2s,imageDiff{2},'r:o','MarkerFaceColor', 'r')
errorbar(strainAmps_x{2}*v2s,imageDiff_x{2},imageDiffErr_x{2}, 'r:o','MarkerFaceColor', 'r')
legendInfo{2} = 'Trained';

% title('Strain Sweeps','FontSize', 20);
% title('Orth Strain Sweep','FontSize', 20);
xlabel('Strain \gamma','FontSize', 18);
ylabel('\langle\mid\DeltaI\mid\rangle','FontSize', 18);

% % Plot vertical line for training amplitude
trainingAmplitude = ampV*v2s;
plot(ones(100,1) * trainingAmplitude, 0.002:0.002:0.2, 'g--');
legendInfo{3} = 'Training strain';

axis([0 0.35 0.02 0.1]);

% xticks([0.0:0.1:0.3])
% yticks([0.02:0.02:0.16]);
yticks([0.02:0.02:0.18]);

% axis([0 max(strainAmps{1})*v2s 0.02 0.3]);
leg = legend(legendInfo, 'Location', 'northwest');
set(leg, 'FontSize', 16)


xt = get(gca,'XTick');
set(gca, 'FontSize', 16);
box on

hold off


% %% Plot many ampsweep data with vertical line at training amplitude
% 
% % Conversion Volts to strain
% v2s = 0.14;
% map = colormap(jet);
% 
% % Colors. Should make this a cell array
% c1 = map(1,:);
% c2 = map(50,:);
% c3 = map(10,:);
% c4 = map(60,:);
% c5 = map(20,:);
% c6 = map(45,:);
% 
% c7 = map(30,:);
% c8 = map(35,:);
% 
% % should plot these as a loop
% hold on;
% plot(strainAmps{1}*v2s,imageDiff{1}, ':^', 'Color', c1, 'MarkerFaceColor', c1)
% legendInfo{1} = 'Before 1';
% plot(strainAmps{2}*v2s,imageDiff{2}, ':o', 'Color', c2, 'MarkerFaceColor', c2)
% legendInfo{2} = 'After 1';
% 
% plot(strainAmps{3}*v2s,imageDiff{3}, ':^', 'Color', c3, 'MarkerFaceColor', c3)
% legendInfo{3} = 'Before 2';
% plot(strainAmps{4}*v2s,imageDiff{4}, ':o', 'Color', c4, 'MarkerFaceColor', c4)
% legendInfo{4} = 'After 2';
% 
% plot(strainAmps{5}*v2s,imageDiff{5}, ':^', 'Color', c5, 'MarkerFaceColor', c5)
% legendInfo{5} = 'Before 3';
% plot(strainAmps{6}*v2s,imageDiff{6}, ':o', 'Color', c6, 'MarkerFaceColor', c6)
% legendInfo{6} = 'After 3';
% 
% plot(strainAmps{7}*v2s,imageDiff{7}, ':^', 'Color', c7, 'MarkerFaceColor', c7)
% legendInfo{7} = 'Before 1.0V';
% plot(strainAmps{8}*v2s,imageDiff{8}, ':o', 'Color', c8, 'MarkerFaceColor', c8)
% legendInfo{8} = 'After 1.0V';
% 
% title('Strain Amplitude Sweeps','FontSize', 20);
% xlabel('Strain \gamma','FontSize', 18);
% ylabel('Mean image difference','FontSize', 18);
% 
% % % Plot vertical line for training amplitude
% trainingAmplitude = 1.4*v2s;
% plot(ones(100,1) * trainingAmplitude, 0.002:0.002:0.2, 'g--');
% legendInfo{9} = 'Training strain 1.4V';
% 
% axis([0 max(strainAmps{1})*v2s 0.02 0.17]);
% leg = legend(legendInfo, 'Location', 'northwest');
% set(leg, 'FontSize', 12)
% 
% 
% xt = get(gca,'XTick');
% set(gca, 'FontSize', 16);
% 
% hold off
% 
% %% Plot ampsweep data with vertical line at training amplitude with loop
% figure;
% map = colormap(jet);
% plotStyle = ':o';
% 
% hold on;
% for i = 1:1:length(fileList)
%     plot(strainAmps{i},imageDiff{i},plotStyle, 'Color', map(i*6,:))
%     legendInfo{i} = ['file ' num2str(i)];
% end
% title('Image difference vs strain amplitude');
% xlabel('Strain amplitude');
% ylabel('Mean difference between images');
% 
% % Plot vertical line for training amplitude
% trainingAmplitude = 1.3;
% plot(ones(100,1) * trainingAmplitude, 0.002:0.002:0.2, 'r--');
% 
% axis([0 3 0.02 0.18]);
% legend(legendInfo, 'Location', 'northwest');
% 
% hold off
