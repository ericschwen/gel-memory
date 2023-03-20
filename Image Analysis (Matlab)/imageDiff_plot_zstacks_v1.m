%% script for plotting imageDiff results for set of static zstacks
% Author: Eric Schwen
% Date: 7-11-17

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


% file path for 6-22-17 ampsweep data pre train
folder = 'C:\Eric\Xerox Data\30um gap runs\6-22-17 0.3333Hz\1.4V sweep pauses\ampsweep_pre_train\';
subfolders = {'0.2V', '0.4V', '0.6V', '0.8V', '1.0V', '1.2V', '1.4V', '1.4V again', '1.8V', '2.0V', '2.2V', '2.4V', '2.6V', '2.8V','3.0V'};
file = '\u_imdiff2D\meanImageDiff_otsu.csv';

% % file path for 6-22-17 ampsweep data post train
% folder = 'C:\Eric\Xerox Data\30um gap runs\6-22-17 0.3333Hz\1.4V sweep pauses\ampsweep_post_train\';
% subfolders = {'0.2V', '0.6V', '1.0V', '1.2V', '1.4V', '1.6V', '2.0V', '2.4V','2.8V'};
% file = '\u_imdiff2D\meanImageDiff_otsu.csv';

% declare data structures
file_paths = cell(length(subfolders),1);
imageDiffs = cell(length(subfolders),1);

% import data
for i = 1:length(subfolders)
    file_paths{i} = [folder, subfolders{i}, file];
    imageDiffs{i} = xlsread(file_paths{i});
    
    % Make single array of data
    if i == 1
        full_diffs = imageDiffs{1};
    else
        full_diffs = [full_diffs; imageDiffs{i}];
        % Equivalent formulation
        % full_diffs = vertcat(full_diffs, imageDiffs{i});
    end
end

% plot data

%% Plot ampsweep data with vertical line at training amplitude

xpos = [0.2, 0.22, 0.24, 0.26, 0.28,...
    .6, .62, .64, .66, .68,...
    1.0, 1.02, 1.04, 1.06, 1.08,...
    1.20, 1.22, 1.24, 1.26, 1.28,...
    1.40, 1.42, 1.44, 1.46, 1.48,...
    1.60, 1.62, 1.64, 1.66, 1.68,...
    2.0, 2.02, 2.04, 2.06, 2.08,...
    2.40, 2.42, 2.44, 2.46, 2.48,...
    2.8, 2.82, 2.84, 2.86, 2.88];
    

hold on;
plot(0.04*(1:length(full_diffs)), full_diffs(1:end),'r:o', 'MarkerFaceColor', 'r')
legendInfo{1} = 'pre train (red)';

title('Image Difference','FontSize', 20);
xlabel('V','FontSize', 18);
ylabel('Mean image difference','FontSize', 18);

xlim([0 3])
% ylim([0.02 0.1])

leg = legend(legendInfo, 'Location', 'northwest');
set(leg, 'FontSize', 16)

xt = get(gca,'XTick');
set(gca, 'FontSize', 16);

hold off

