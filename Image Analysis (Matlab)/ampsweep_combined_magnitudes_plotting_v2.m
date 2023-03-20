% Plot image difference over the course of an amplitude sweep.
% Combined version looks at alternating untrained and trained. Modified
% from ampsweep_save_magnitudes_v4
%  5-28-19
%   Mod History:
%     v2: add separate filepaths for strains in x and y
%

% Manually written combined ampsweep data 
% % 0.6V 5-2-19 data
% strain_amps = 0.2:0.2:2.6;
% x_im_diff = [.0236 .0257 .0281 .0338 .0370 .0509 .0500 .0644 .0608 .0748 .0721 .0901 .0738];
% y_im_diff = [.0234 .0290 .0380 .0442 .0576 .0641 .0782 .0850 .0971 .1014 .1286 .1309 .1674];
% 
% % 1.0V 5-2-19 data
% x_im_diff = [.0258 .0281 .0290 .0364 .0370 .0471 .0478 .0583 .0543 .0682 .0639 .0855 .0742];
% y_im_diff = [.0265 .0313 .0386 .0456 .0578 .0594 .0756 .0759 .0943 .0961 .1203 .1213 .1592];

% importing data
folder = 'C:\Eric\Xerox Data\30um gap runs\6-11-19 data\';
ampV = 0.6;
fileList = {'0.6V y-train\ampsweep-pre-train'};
% fileList = {'0.6V\ampsweep-post-train', '0.6V\ampsweep-pre-train'};
% fileList = {'ampsweep_pre_train', 'ampsweep_post_train'};
% fileList = {'ampsweep-post-train-combined', 'ampsweep-pre-train-combined'};
% fileList = {'0.4V\ampsweep-post-train-combined', '0.6V\ampsweep-pre-train-combined'};

suffix = '_imageDiff';
fileNumbers = 1:1:length(fileList);
numfiles = length(fileList);

% Declare cell array sizes.
filename = cell(numfiles,1);
strainAmpFilepath_x = cell(numfiles,1);
strainAmps_x = cell(numfiles,1);
strainAmpFilepath_y = cell(numfiles,1);
strainAmps_y = cell(numfiles,1);
IDFilepath_x = cell(numfiles,1);
IDErrFilepath_x = cell(numfiles,1);
imageDiff_x = cell(numfiles,1);
imageDiffErr_x = cell(numfiles,1);
IDFilepath_y = cell(numfiles,1);
IDErrFilepath_y = cell(numfiles,1);
imageDiff_y = cell(numfiles,1);
imageDiffErr_y = cell(numfiles,1);
% legendInfo = cell(numfiles,1);

for i = 1:length(fileList)
    filename{i} = [folder, fileList{i}, suffix];
    
    % strain amplitude and image difference file paths
    strainAmpFilepath_x{i} = [filename{i} '\strainAmplitudes_x.csv'];
    strainAmpFilepath_y{i} = [filename{i} '\strainAmplitudes_y.csv'];
    IDFilepath_x{i} = [filename{i} '\imageDifferenceAmpsweep_x.csv'];
    IDErrFilepath_x{i} = [filename{i}, '\imageDifferenceAmpsweepErr_x.csv'];
    IDFilepath_y{i} = [filename{i} '\imageDifferenceAmpsweep_y.csv'];
    IDErrFilepath_y{i} = [filename{i}, '\imageDifferenceAmpsweepErr_y.csv'];
    
    strainAmps_x{i} = xlsread(strainAmpFilepath_x{i});
    strainAmps_y{i} = xlsread(strainAmpFilepath_y{i});
    imageDiff_x{i} = xlsread(IDFilepath_x{i});
    imageDiffErr_x{i} = xlsread(IDErrFilepath_x{i});
    imageDiff_y{i} = xlsread(IDFilepath_y{i});
    imageDiffErr_y{i} = xlsread(IDErrFilepath_y{i});
end

% % extra version for old-school ampsweeps (not combined)
% for i = 2
%     filename{i} = [folder, fileList{i}, suffix];
%     % strain amplitude and image difference file paths
%     strainAmpFilepath{i} = [filename{i} '\strainAmplitudes.csv'];
%     IDFilepath_x{i} = [filename{i} '\imageDifferenceAmpsweep.csv'];
%     IDErrFilepath_x{i} = [filename{i}, '\imageDifferenceAmpsweepErr.csv'];
%     
%     strainAmps{i} = xlsread(strainAmpFilepath{i});
%     imageDiff_x{i} = xlsread(IDFilepath_x{i});
%     imageDiffErr_x{i} = xlsread(IDErrFilepath_x{i});
% end


% Basic plot mean image difference vs amplitude
figure;
hold on
plot(strainAmps_x{1}, imageDiff_x{1},'bo')
plot(strainAmps_y{1}, imageDiff_y{1}, 'ro')
xlabel('Strain amplitude');
ylabel('Mean difference between images');
% axis([0 max(t) 0.03 0.15]);
hold off

%% Plot ampsweep data with vertical line at training amplitude

% Colors
red = [255, 0, 0]/256;
brn = [153, 102, 0]/256.;
pur = [153, 0, 204]/256.;

% Conversion Volts to strain
v2s = 0.14;

figure;
hold on;

% errorbar(strainAmps_x{1}*v2s,imageDiff_x{1}, imageDiffErr_x{1}, ':o', 'Color', red, 'MarkerFaceColor', red, 'MarkerSize', 7)
% legendInfo{1} = 'Trained x';
% errorbar(strainAmps_y{1}*v2s,imageDiff_y{1},imageDiffErr_y{1}, ':o', 'Color', brn, 'MarkerFaceColor', brn, 'MarkerSize', 7)
% legendInfo{2} = 'Trained y';
% 
% errorbar(strainAmps_x{2}*v2s,imageDiff_x{2}, imageDiffErr_x{2}, ':o', 'Color', 'b', 'MarkerFaceColor', 'b', 'MarkerSize', 7)
% legendInfo{3} = 'Untrained x';
% errorbar(strainAmps_y{2}*v2s,imageDiff_y{2},imageDiffErr_y{2}, ':o', 'Color', pur, 'MarkerFaceColor', pur, 'MarkerSize', 7)
% legendInfo{4} = 'Untrained y';

% Untrained only version
errorbar(strainAmps_x{1}*v2s,imageDiff_x{1}, imageDiffErr_x{1}, ':o', 'Color', 'b', 'MarkerFaceColor', 'b', 'MarkerSize', 7)
legendInfo{1} = 'Untrained x';
errorbar(strainAmps_y{1}*v2s,imageDiff_y{1},imageDiffErr_y{1}, ':o', 'Color', pur, 'MarkerFaceColor', pur, 'MarkerSize', 7)
legendInfo{2} = 'Untrained y';

% errorbar(strainAmps{2}*v2s,imageDiff_x{2}, imageDiffErr_x{2}, ':o', 'Color', 'b', 'MarkerFaceColor', 'b', 'MarkerSize', 7)
% legendInfo{3} = 'Untrained x';

% plot(strainAmps{2}*v2s,imageDiff{2},'r:o','MarkerFaceColor', 'r')
% plot(strainAmps{1}*v2s,imageDiff{1},'b:^', 'MarkerFaceColor', 'b')

xlabel('Strain \gamma','FontSize', 18);
ylabel('Mean image difference \langle\mid\DeltaI\mid\rangle','FontSize', 18);

% % % Plot vertical line for training amplitude
% trainingAmplitude = ampV*v2s;
% plot(ones(100,1) * trainingAmplitude, 0.002:0.002:0.2, 'g--');
% legendInfo{3} = 'Training strain';

axis([0 0.25 0.02 0.12]);

% xticks([0.0:0.1:0.3])
% yticks([0.02:0.02:0.16]);
yticks([0.02:0.02:0.16]);

% axis([0 max(strainAmps{1})*v2s 0.02 0.3]);
leg = legend(legendInfo, 'Location', 'northwest');
set(leg, 'FontSize', 14)

xt = get(gca,'XTick');
set(gca, 'FontSize', 16);
box on

hold off

