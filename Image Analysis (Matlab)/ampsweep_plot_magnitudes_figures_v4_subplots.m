% ampsweep plot magnitudes figures

% take files saved using ampsweep_save_magnitudes and plot the results
% v2: start adding in y-uncertainties
% v3: band errors added (filled)
% v4: add effective zero (filled)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Import amp-sweeep data
folder = 'C:\Eric\Xerox Data\30um gap runs\0.5Hz combined gel runs 1-17-17\0.4V\';
fileList = {'ampsweep_post_train', 'ampsweep_pre_train'};
% folder = 'C:\Eric\Xerox Data\30um gap runs\0.3333Hz 4-11-17\1.4V\';
% fileList = {'ampsweep_post_sweep', 'ampsweep_pre_train'};
% folder = 'C:\Eric\Xerox Data\30um gap runs\0.3333Hz 4-11-17\1.5V\';
% fileList = {'ampsweep_post_train', 'ampsweep_pre_train'};
% fileList = {'ampsweep-pre-train', 'ampsweep-post-train'};
% fileList = {'ampsweep'};
% folder = 'D:\Xerox Data\30um gap runs\7-3-18 data\0.9V\';
% fileList = {'ampsweep-pre-train', 'ampsweep-post-train'};
ampV = 0.4;
noise_max = 0.0254;

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

% % Trim a point (for 1.5V)
% strainAmps_x{2} = strainAmps_x{2}(2:end);
% imageDiff_x{2} = imageDiff_x{2}(2:end);
% imageDiffErr_x{2} = imageDiffErr_x{2}(2:end);

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
ax1 = gca;
hold(ax1, 'on')

% Plot a zone of effective zero
zero_x_vector = [0:0.2:4.2, fliplr(0:0.2:4.2)];
% zero_x_vector = [options.x_axis{1}', fliplr(options.x_axis{1}')];
patch_zero = fill(zero_x_vector, [noise_max*ones(length(zero_x_vector)/2.,1)', ...
    0.02*ones(length(zero_x_vector)/2.,1)'], org, 'FaceAlpha', 0.2);
set(patch_zero, 'edgecolor', 'none');
% set(patch_zero, 'FaceAlpha', 0.2);

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

% [lgd, lgd_icons] = legend([plot_x{1}, plot_x{2}, plot_train, patch_zero], ...
%     {'Trained', 'Untrained', 'Training strain', 'Noise floor'},...
%     'Location', 'northwest', 'FontSize', 16);
% 
% % lgd = legend([plot_x{1}, plot_x{2}], {'train', 'trained'}, 'FontSize', 12);
% 
% patch_in_legend = findobj(lgd_icons, 'type', 'patch');
% set(patch_in_legend, 'FaceAlpha', 0.3);
% % lgd.Box = 'off';

axis([0 0.4 0.02 0.16]);

xticks(0.0:0.1:0.4)
% yticks(0.02:0.01:0.05);
yticks(0.02:0.02:0.16);

% axis([0 max(strainAmps_x{1})*v2s 0.02 0.3]);

xt = get(gca,'XTick');
set(gca, 'FontSize', 16);
box on

ax2 = axes('Position',[.4 .4 .46 .46]);
hold(ax2,'on')
axis([0 0.12 0.02 0.05]);

% Plot a zone of effective zero
zero_x_vector = [0:0.2:4.2, fliplr(0:0.2:4.2)];
% zero_x_vector = [options.x_axis{1}', fliplr(options.x_axis{1}')];
patch_zero = fill(zero_x_vector, [noise_max*ones(length(zero_x_vector)/2.,1)', ...
    0.02*ones(length(zero_x_vector)/2.,1)'], org, 'FaceAlpha', 0.2);
set(patch_zero, 'edgecolor', 'none');
% set(patch_zero, 'FaceAlpha', 0.2);

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
box on
xticks(0:0.04:0.12)
yticks(0.02:0.01:0.05);

% %% Plot ampsweep data with vertical line at training amplitude
% 
% figure;
% hold on;
% % plot(strainAmps{1}*v2s,imageDiff{1},'b:^', 'MarkerFaceColor', 'b')
% errorbar(strainAmps_x{1}(1:end)*v2s,imageDiff_x{1}(1:end), imageDiffErr_x{1}(1:end), 'b:^', 'MarkerFaceColor', 'b')
% legendInfo{1} = 'Untrained';
% % plot(strainAmps{2}*v2s,imageDiff{2},'r:o','MarkerFaceColor', 'r')
% errorbar(strainAmps_x{2}*v2s,imageDiff_x{2},imageDiffErr_x{2}, 'r:o','MarkerFaceColor', 'r')
% legendInfo{2} = 'Trained';
% 
% % title('Strain Sweeps','FontSize', 20);
% % title('Orth Strain Sweep','FontSize', 20);
% xlabel('Strain \gamma','FontSize', 18);
% ylabel('\langle\mid\DeltaI\mid\rangle','FontSize', 18);
% 
% % % Plot vertical line for training amplitude
% trainingAmplitude = ampV*v2s;
% plot(ones(100,1) * trainingAmplitude, 0.002:0.002:0.2, 'g--');
% legendInfo{3} = 'Training strain';
% 
% axis([0 0.35 0.02 0.1]);
% 
% % xticks([0.0:0.1:0.3])
% % yticks([0.02:0.02:0.16]);
% yticks([0.02:0.02:0.18]);
% 
% % axis([0 max(strainAmps{1})*v2s 0.02 0.3]);
% leg = legend(legendInfo, 'Location', 'northwest');
% set(leg, 'FontSize', 16)
% 
% 
% xt = get(gca,'XTick');
% set(gca, 'FontSize', 16);
% box on
% 
% hold off

