%% script for plotting msd results for set of static zstacks
% Author: Eric Schwen
% Date: 7-11-17

% Modification history:


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
% folder = 'C:\Eric\Xerox Data\30um gap runs\6-22-17 0.3333Hz\1.4V sweep pauses\ampsweep_pre_train\';
% subfolders = {'0.2V', '0.4V', '0.6V', '0.8V', '1.0V', '1.2V', '1.4V', '1.8V', '2.0V', '2.2V', '2.4V', '2.6V', '2.8V','3.0V'};
% file = '\u_combined\msd3D.csv';

% file path for 6-22-17 ampsweep data post train
folder = 'C:\Eric\Xerox Data\30um gap runs\6-22-17 0.3333Hz\1.4V sweep pauses\ampsweep_post_train\';
subfolders = {'0.2V', '0.6V', '1.0V', '1.2V', '1.4V', '1.6V', '2.0V', '2.4V','2.8V'};
file = '\u_combined\msd3D.csv';

% declare data structures
file_paths = cell(length(subfolders),1);
msds = cell(length(subfolders),1);

% import data
for i = 1:length(subfolders)
    file_paths{i} = [folder, subfolders{i}, file];
    msds{i} = xlsread(file_paths{i});
    
    % Make single array of data
    if i == 1
        full_msd = msds{1};
        % msd for just time 1 cycle
        msd_t1 = msds{1}(1,2);
    else
        full_msd = [full_msd; msds{i}];
        msd_t1 = [msd_t1; msds{i}(1,2)];
        % Equivalent formulation
        % full_diffs = vertcat(full_diffs, imageDiffs{i});
    end
end

% plot data

%% Plot ampsweep data with vertical line at training amplitude

strains_post_train = [0.2, 0.6, 1.0, 1.2, 1.4, 1.6, 2.0, 2.4, 2.8];
strains_pre_train = [0.2, 0.4, 0.6, 0.8, 1.0, 1.2, 1.4, 1.8, 2.0, 2.2, 2.4, 2.6, 2.8,3.0];

v2s = 0.14;

figure;
hold on;

% % post-train plotting
% full_diffs_post = full_diffs;
% plot(v2s * strains_post_train, full_diffs_post,'r:o', 'MarkerFaceColor', 'r')
% legendInfo{1} = 'post train';

% % pre-train full msd plotting
% full_msd_pre = full_msd;
% plot(1:length(full_msd_pre), full_msd_pre(:,2), 'b:o', 'MarkerFaceColor', 'b')
% legendInfo{1} = 'pre train';

% % pre-train msd t1 plotting
% msd_t1_pre = msd_t1;

plot(strains_pre_train, msd_t1_pre, 'b:o', 'MarkerFaceColor', 'b')
legendInfo{1} = 'pre train';

% pre-train msd t1 plotting
% msd_t1_post = msd_t1;

plot(strains_post_train, msd_t1_post, 'r:o', 'MarkerFaceColor', 'r')
legendInfo{2} = 'post train';


% % Plot vertical line for training amplitude
% trainingAmplitude = 1.4*v2s;
% plot(ones(100,1) * trainingAmplitude, 0.002:0.002:0.2, 'g--');
% legendInfo{3} = 'Training strain';

title('MSD t1','FontSize', 20);
xlabel('strain','FontSize', 18);
ylabel('msd time1 (um)','FontSize', 18);

% xlim([0 3*v2s])
% ylim([0.00 0.2])

leg = legend(legendInfo, 'Location', 'northwest');
set(leg, 'FontSize', 16)

xt = get(gca,'XTick');
set(gca, 'FontSize', 16);

hold off