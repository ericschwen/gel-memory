% ampsweep plot magnitudes

% take files saved using ampsweep_save_magnitudes and plot the results
% v2: Allows input of multiple files to plot together.
% v3: Takes inputs from parallel processed images
% v4: takes input from different folder created for image difference data
% (4-18-17)
% v4 mod1: put more than 2 files together 7-10-17

%% Import amp-sweeep data
folder = 'C:\Eric\Xerox Data\30um gap runs\';
% fileList = {'0.6V\ampsweep-pre-train', '0.6V\ampsweep-post-train'};

% fileList = {'0.6V\ampsweep-pre-train', '0.6V\ampsweep-post-train', '1.0V\ampsweep-post-train', '0.4V\ampsweep-post-train','0.8V\ampsweep-post-train'};

fileList = {'6-3-18 data\0.6V\ampsweep-pre-train', '6-3-18 data\0.8V\ampsweep-post-train',  '6-3-18 data\1.0V\ampsweep-post-train'};
suffix = '_imageDiff';

fileNumbers = 1:1:length(fileList);
numfiles = length(fileList);

% Declare cell array sizes.
filename = cell(numfiles,1);
strainAmpFilepath = cell(numfiles,1);
strainAmps = cell(numfiles,1);
IDFilepath = cell(numfiles,1);
imageDiff = cell(numfiles,1);

legendInfo = cell(numfiles,1);


for i = fileNumbers
    filename{i} = [folder, fileList{i}, suffix];
    
    % strain amplitude and image difference file paths
    strainAmpFilepath{i} = [filename{i} '\strainAmplitudes.csv'];
    IDFilepath{i} = [filename{i} '\imageDifferenceAmpsweep.csv'];
    
    strainAmps{i} = xlsread(strainAmpFilepath{i});
    imageDiff{i} = xlsread(IDFilepath{i});
end


%% Plot ampsweep data with vertical line at training amplitude

% Conversion Volts to strain
v2s = 0.14;
% Leave in volts version
v2s = 1;

map = lines;

figure;
hold on;
plot(strainAmps{1}*v2s,imageDiff{1}, ':^', 'Color', map(1,:), 'MarkerFaceColor', map(1,:))
legendInfo{1} = 'Untrained';
plot(strainAmps{2}*v2s,imageDiff{2},':o', 'Color', map(2,:), 'MarkerFaceColor', map(2,:))
legendInfo{2} = '0.8V';

plot(strainAmps{3}*v2s,imageDiff{3},':o', 'Color', map(3,:), 'MarkerFaceColor', map(3,:))
legendInfo{3} = '1.0V';
% plot(strainAmps{4}*v2s,imageDiff{4},':o', 'Color', map(4,:), 'MarkerFaceColor', map(4,:))
% legendInfo{4} = '0.4V';
% 
% plot(strainAmps{5}*v2s,imageDiff{5},':o', 'Color', map(5,:), 'MarkerFaceColor', map(5,:))
% legendInfo{5} = '0.8V';

title('Strain Sweeps','FontSize', 20);
% title('Orth Strain Sweep','FontSize', 20);
xlabel('Strain \gamma','FontSize', 18);
ylabel('Mean image difference','FontSize', 18);

% % % Plot vertical line for training amplitude
% trainingAmplitude = 0.5*v2s;
% plot(ones(100,1) * trainingAmplitude, 0.002:0.002:0.2, 'g--');
% legendInfo{3} = 'Training strain';

axis([0 max(strainAmps{1})*v2s 0.02 0.1]);
leg = legend(legendInfo, 'Location', 'northwest');
set(leg, 'FontSize', 16)


xt = get(gca,'XTick');
set(gca, 'FontSize', 16);

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
