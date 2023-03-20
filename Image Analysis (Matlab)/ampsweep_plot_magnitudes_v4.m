% ampsweep plot magnitudes

% take files saved using ampsweep_save_magnitudes and plot the results
% v2: Allows input of multiple files to plot together.
% v3: Takes inputs from parallel processed images
% v4: takes input from different folder created for image difference data
% (4-18-17)

%% Import amp-sweeep data
folder = 'C:\Eric\Xerox Data\30um gap runs\3-21-18 orthogonal\';
fileList = {'1.0V x-x run1\ampsweep', 'untrained ampsweep x\ampsweep'};
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

figure;
hold on;

% % Plot vertical line for training amplitude
trainingAmplitude = 1.4*v2s;
% p0 = plot(ones(100,1) * trainingAmplitude, 0.002:0.002:0.2, '--', 'LineWidth', 1.8, 'Color', [0, 204, 0]/255);

p1 = plot(strainAmps{1}*v2s,imageDiff{1},'b:^', 'MarkerFaceColor', 'b');
% p2 = plot(strainAmps{2}*v2s,imageDiff{2},'r:o','MarkerFaceColor', 'r');

title('Strain Amplitude Sweeps','FontSize', 20);
xlabel('Strain \gamma','FontSize', 18);
ylabel('Mean image difference','FontSize', 18);

axis([0 max(strainAmps{1})*v2s 0.02 0.17]);
% leg = legend([p1 p2 p0], 'Before training', 'After Training', 'Training Strain','Location', 'northwest');
set(leg, 'FontSize', 16)


xt = get(gca,'XTick');
set(gca, 'FontSize', 16);

hold off
%% Plot ampsweep data with vertical line at training amplitude with loop
figure;
map = colormap(jet);
plotStyle = ':o';

hold on;
for i = 1:1:length(fileList)
    plot(strainAmps{i},imageDiff{i},plotStyle, 'Color', map(i*10,:))
    legendInfo{i} = ['file ' num2str(i)];
end
title('Image difference vs strain amplitude');
xlabel('Strain amplitude');
ylabel('Mean difference between images');

% Plot vertical line for training amplitude
trainingAmplitude = 1.3;
plot(ones(100,1) * trainingAmplitude, 0.002:0.002:0.2, 'r--');

axis([0 3 0.02 0.18]);
legend(legendInfo, 'Location', 'northwest');

hold off


