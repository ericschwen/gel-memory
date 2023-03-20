% ampsweep plot magnitudes

% take files saved using ampsweep_save_magnitudes and plot the results

% Amp-sweeep data
folder = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\0.5Hz combined gel runs 1-17-17\';
file = '0.6V\ampsweep_post_train.lsm';

filename = [folder, file];
filebase = filename(1:length(filename)-4);

% strain amplitude and image difference file paths
strainAmpFilepath = [filebase, '_strainAmplitudes.csv'];
IDFilepath = [filebase, '_imageDifferenceAmpsweep.csv'];

strainAmps = xlsread(strainAmpFilepath);
imageDiff = xlsread(IDFilepath);

figure;
hold on;
plot(strainAmps,imageDiff,'bo')
title('Image difference vs strain amplitude');
xlabel('Strain amplitude');
ylabel('Mean difference between images');
hold off

