%% script for plotting imageDiff results for set of static zstacks
% Author: Eric Schwen
% Date: 7-11-17

% Modification history:
% v2: modify to work for ampsweeps. average each set of points over the
% same voltage.
% v3: read folders from dir

%%
% folder_list = {'C:\Eric\Xerox Data\30um gap runs\8-11-17 0.3333Hz training\1.4V\ampsweep\',...
%     'C:\Eric\Xerox Data\30um gap runs\8-11-17 0.3333Hz training\2.0V\ampsweep\',...
%     'C:\Eric\Xerox Data\30um gap runs\8-11-17 0.3333Hz training\2.8V\ampsweep\',...
%     'C:\Eric\Xerox Data\30um gap runs\8-11-17 0.3333Hz training\1.0V\ampsweep\',...
%     'C:\Eric\Xerox Data\30um gap runs\8-11-17 0.3333Hz training\No training delay\ampsweep\',...
%     'C:\Eric\Xerox Data\30um gap runs\8-11-17 0.3333Hz training\Untrained Amplitude Sweep 1\ampsweep\'};


folder_list = {'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\1.0\ampsweep\',...
    'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\0.6\ampsweep\',...
    'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\1.4\ampsweep\',...
    'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\2.0\ampsweep\',...
    'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\Untrained short\ampsweep\',...
    'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\Untrained long\ampsweep\',...
    'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\Untrained delayed short\ampsweep\'};


folder = folder_list{5};

% Read all file names from folder
files_dir = dir(folder);
subfolders = cell(length(files_dir)-2, 1);
for i = 3:length(files_dir)
    subfolders{i-2} = files_dir(i).name;
end

file = '\u_imdiff2D\meanImageDiff_otsu.csv';

% declare data structures
file_paths = cell(length(subfolders),1);
imageDiffs = cell(length(subfolders),1);
mean_diffs = cell(length(subfolders),1);
mean_diffs_no1 = cell(length(subfolders),1);

% import data
for i = 1:length(subfolders)
    file_paths{i} = [folder, subfolders{i}, file];
    imageDiffs{i} = xlsread(file_paths{i});
    
    % Make single array of data
    if i == 1
        mean_diffs = mean(imageDiffs{1});
        mean_diffs_no1 = mean(imageDiffs{1}(2:end));
        full_diffs = imageDiffs{1};
    else
        mean_diffs = [mean_diffs; mean(imageDiffs{i})];
        mean_diffs_no1 = [mean_diffs_no1; mean(imageDiffs{i}(2:end))];
        full_diffs = [full_diffs; imageDiffs{i}];
        % Equivalent formulation
        % full_diffs = vertcat(full_diffs, imageDiffs{i});
    end
end

% plot image differences vs. image #
figure;
plot(1:length(full_diffs), full_diffs, 'b:o', 'MarkerFaceColor', 'b')
title('Image Difference','FontSize', 20);
xlabel('pause','FontSize', 18);
ylabel('Mean image difference','FontSize', 18);

%% Plot ampsweep data with vertical line at training amplitude

subfolders_num = str2double(subfolders);
v2s = 0.14;
strains = subfolders_num * 0.14;


% % for saving untrained version
% s1 = strains;
% m1 = mean_diffs_no1;


figure;
hold on
plot(s1, m1, 'b:o', 'MarkerFaceColor', 'b')
legendInfo{1} = 'Untrained long';
plot(strains, mean_diffs_no1, 'r:o', 'MarkerFaceColor', 'r')
legendInfo{2} = 'Unrained short';
title('Image Difference vs Strain','FontSize', 20);
xlabel('strain','FontSize', 18);
ylabel('Mean image difference','FontSize', 18);
ylim([0 0.5])



% % Plot vertical line for training amplitude
% trainingAmplitude = 1.0*v2s;
% plot(ones(100,1) * trainingAmplitude, 0.002:0.002:0.2, 'g--');
% legendInfo{3} = 'Training strain';


leg = legend(legendInfo, 'Location', 'northwest');
set(leg, 'FontSize', 16)

xt = get(gca,'XTick');
set(gca, 'FontSize', 16);

hold off

% %%
% % temporarily rewritten to plot both pre and post sweep results
% hold on;
% 
% % post-train plotting
% % full_diffs_post_u = mean_diffs;
% plot(v2s * xpts_post_train, full_diffs_post_u,'r:o', 'MarkerFaceColor', 'r')
% legendInfo{1} = 'post train u';
% 
% % % post-train plotting
% % full_diffs_post_s = full_diffs;
% % plot(v2s * xpts_post_train, full_diffs_post_s,'k:o', 'MarkerFaceColor', 'k')
% % legendInfo{2} = 'post train s';
% 
% % % pre-train plotting
% % full_diffs_pre_u = full_diffs;
% plot(v2s *xpts_pre_train, full_diffs_pre_u, 'b:o', 'MarkerFaceColor', 'b')
% legendInfo{2} = 'pre train u';
% 
% % % pre-train plotting
% % full_diffs_pre_s = full_diffs;
% % plot(v2s *xpts_pre_train, full_diffs_pre_s, 'g:o', 'MarkerFaceColor', 'g')
% % legendInfo{4} = 'pre train s';
% 
% 
% % Plot vertical line for training amplitude
% trainingAmplitude = 1.4*v2s;
% plot(ones(100,1) * trainingAmplitude, 0.002:0.002:0.2, 'g--');
% legendInfo{3} = 'Training strain';
% 
% title('Image Difference','FontSize', 20);
% xlabel('strain','FontSize', 18);
% ylabel('Mean image difference','FontSize', 18);
% 
% xlim([0 3*v2s])
% ylim([0.00 0.2])
% 
% leg = legend(legendInfo, 'Location', 'northwest');
% set(leg, 'FontSize', 16)
% 
% xt = get(gca,'XTick');
% set(gca, 'FontSize', 16);
% 
% hold off