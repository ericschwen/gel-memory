%% script for plotting imageDiff results for set of static zstacks
% Author: Eric Schwen
% Date: 7-11-17

% Modification history:
% v2: modify to work for ampsweeps. average each set of points over the
% same voltage.

%%

%{
% Make file path to import image difference data (6-28-17 data)
folder = 'C:\Eric\Xerox Data\30um gap runs\6-28-17 0.3333Hz\1.4V run3\zstacks_';
subfolders = {'p0', 'p100', 'p200', 'p300', 'p400', 'p500'};
file = '\s_imdiff2D\meanImageDiff_otsu.csv';
%}

%{
% file path for 6-22-17 image difference data
folder = 'C:\Eric\Xerox Data\30um gap runs\6-22-17 0.3333Hz\1.4V with pauses\zstack_';
subfolders = {'p100', 'p200', 'p300', 'p400', 'p500'};
file = '__imdiff2D\meanImageDiff_otsu.csv';
%}


% % file path for 6-22-17 ampsweep data pre train
% folder = 'C:\Eric\Xerox Data\30um gap runs\6-22-17 0.3333Hz\1.4V sweep pauses\ampsweep_post_train\';
% subfolders = {'0.2V', '0.6V', '1.0V', '1.2V', '1.4V', '1.6V', '2.0V','2.4V','2.8V'};
% % subfolders = {'0.2V', '0.4V', '0.8V', '1.0V', '1.2V', '1.4V', '1.8V', '2.0V', '2.2V', '2.4V', '2.6V', '2.8V','3.0V'};
% file = '\u_imdiff2D\meanImageDiff_otsu.csv';

% file path for 7-13-17 ampsweep data post train
folder = 'C:\Eric\Xerox Data\30um gap runs\7-13-17 0.3333Hz\1.0V\ampsweep_post_train\';
subfolders = {'0.2V', '0.6V', '0.8V', '1.0V', '1.2V', '1.4V', '1.8V', '2.2V', '2.6V', '3.0V'};
% subfolders = {'0.2V', '0.6V', '1.0V', '1.2V', '1.4V', '1.6V', '2.0V', '2.4V', '2.8V'};
file = '\u_imdiff2D\meanImageDiff_otsu.csv';

% declare data structures
file_paths = cell(length(subfolders),1);
imageDiffs = cell(length(subfolders),1);

% import data
for i = 1:length(subfolders)
    file_paths{i} = [folder, subfolders{i}, file];
    imageDiffs{i} = xlsread(file_paths{i});
    
    % Make single array of data
    if i == 1
        mean_diffs = mean(imageDiffs{1});
        full_diffs = imageDiffs{1};
    else
        mean_diffs = [mean_diffs; mean(imageDiffs{i})];
        full_diffs = [full_diffs; imageDiffs{i}];
        % Equivalent formulation
        % full_diffs = vertcat(full_diffs, imageDiffs{i});
    end
end

% plot data
plot(1:length(full_diffs), full_diffs, 'b:o', 'MarkerFaceColor', 'b')
title('Image Difference','FontSize', 20);
xlabel('pause','FontSize', 18);
ylabel('Mean image difference','FontSize', 18);

%% Plot ampsweep data with vertical line at training amplitude

xpts_post_train = [0.2, 0.6, 1.0, 1.2, 1.4, 1.6, 2.0, 2.4, 2.8];
xpts_pre_train = [0.2, 0.6, 1.0, 1.2, 1.4, 1.6, 2.0, 2.4, 2.8];

v2s = 0.14;

% temporarily rewritten to plot both pre and post sweep results
hold on;

% post-train plotting
full_diffs_post_u = mean_diffs;
plot(v2s * xpts_post_train, full_diffs_post_u,'r:o', 'MarkerFaceColor', 'r')
legendInfo{1} = 'post train u';

% % post-train plotting
% full_diffs_post_s = full_diffs;
% plot(v2s * xpts_post_train, full_diffs_post_s,'k:o', 'MarkerFaceColor', 'k')
% legendInfo{2} = 'post train s';

% % pre-train plotting
% full_diffs_pre_u = full_diffs;
plot(v2s *xpts_pre_train, full_diffs_pre_u, 'b:o', 'MarkerFaceColor', 'b')
legendInfo{2} = 'pre train u';

% % pre-train plotting
% full_diffs_pre_s = full_diffs;
% plot(v2s *xpts_pre_train, full_diffs_pre_s, 'g:o', 'MarkerFaceColor', 'g')
% legendInfo{4} = 'pre train s';


% Plot vertical line for training amplitude
trainingAmplitude = 1.4*v2s;
plot(ones(100,1) * trainingAmplitude, 0.002:0.002:0.2, 'g--');
legendInfo{3} = 'Training strain';

title('Image Difference','FontSize', 20);
xlabel('strain','FontSize', 18);
ylabel('Mean image difference','FontSize', 18);

xlim([0 3*v2s])
ylim([0.00 0.2])

leg = legend(legendInfo, 'Location', 'northwest');
set(leg, 'FontSize', 16)

xt = get(gca,'XTick');
set(gca, 'FontSize', 16);

hold off