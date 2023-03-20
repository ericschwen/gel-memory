% Plot image difference over the course of an amplitude sweep.
% Combined version looks at alternating untrained and trained. Modified
% from ampsweep_save_magnitudes_v4

% Mod History:
% v2: automating the process somewhat. Manually declare spacing between
%   separate amplitudes, but do so in a single file. 5-28-19


% Amp-sweeep data

folder = 'C:\Eric\Xerox Data\30um gap runs\5-24-19 data\0.6V\';
file = 'ampsweep-pre-train-combined';

imDiffFolder = [folder, file, '_imageDiff\'];

% Decalre files for saving strain amplitude and image difference to file
strainAmpFilepath = [imDiffFolder, 'strainAmplitudes.csv'];
IDFilepath_x = [imDiffFolder, 'imageDifferenceAmpsweep_x.csv'];
IDErrFilepath_x = [imDiffFolder, 'imageDifferenceAmpsweepErr_x.csv'];
IDFilepath_y = [imDiffFolder, 'imageDifferenceAmpsweep_y.csv'];
IDErrFilepath_y = [imDiffFolder, 'imageDifferenceAmpsweepErr_y.csv'];

% Import mean image difference (mid) data
midpath = [imDiffFolder, 'meanImageDiff_otsu.csv'];
mid = xlsread(midpath); % mid = mean image difference

mid_xy_path = [imDiffFolder, 'meanXYDiff_otsu.csv'];
mid_xy = xlsread(mid_xy_path); % mid = mean image difference


% Select points to fit (sets of 4) for each amplitude by declaring gaps
gaps = [4 7 8 7 7 7 7 8 8 7 7 7 7 7 7 8 8 7 7 5 5 7 7 8 7 9 8]';

% declare starting cycle for each amplitude
starts = zeros(length(gaps),1);
lasts = zeros(length(gaps),1);
im_diffs = zeros(length(gaps),1);
errs = zeros(length(gaps),1);

% STANDARD
% loop through all manually declared gaps. set starting cycles and
% calculate mean image difference and standard error
for i = 1:length(gaps)
    if i == 1
        starts(i) = gaps(i);
    else
        starts(i) = starts(i-1) + gaps(i);
    end
    lasts(i) = starts(i) +3;
    
    im_diffs(i) = mean(mid(starts(i): lasts(i)));
    errs(i) = std(mid(starts(i): lasts(i)));
end

% % ALTERNATIVE VERSION SKIPS FIRST CYCLE AT EACH AMPLITUDE FOR CALCULATION
% % loop through all manually declared gaps. set starting cycles and
% % calculate mean image difference and standard error
% for i = 1:length(gaps)
%     if i == 1
%         starts(i) = gaps(i);
%     else
%         starts(i) = starts(i-1) + gaps(i);
%     end
%     lasts(i) = starts(i) +3;
%     
%     im_diffs(i) = mean(mid(starts(i) + 1: lasts(i)));
%     errs(i) = std(mid(starts(i) + 1: lasts(i)));
% end




% Test plot mean image difference vs time with amplitude averaging data
% Makes sure my mean image difference vs strain amplitude graph has the
% right mean image difference numbers.
figure('units','normalized','outerposition',[0 0 1 1]);
t = 1:1:length(mid);
hold on
plot(t,mid,'b:o');

title('Mean image difference over time (OTSU)');
xlabel('Shear cycles');
ylabel('Mean difference between images');
axis([0 max(t) 0.0 0.4]);


% plot chosen im_diff to check
plot(starts, im_diffs, 'ro')
hold off

%% Separate x and y differences
strain_amps = 0.2:0.2:2.6;
x_indices = [1 4 5 8 9 12 13 16 17 20 21 24 25];
y_indices = [2 3 6 7 10 11 14 15 18 19 22 23 26];

% low voltage version
% strain_amps = [.1 .2 .3 .4 .5 .6 .8 1.0 1.4 1.8 2.2 2.6];
% x_indices = [1 4 5 8 9 12 13 16 17 20 21 24];
% y_indices = [2 3 6 7 10 11 14 15 18 19 22 23];

x_im_diffs = zeros(length(strain_amps),1);
y_im_diffs = zeros(length(strain_amps),1);
x_errs = zeros(length(strain_amps),1);
y_errs = zeros(length(strain_amps),1);

for i = 1:length(x_im_diffs)
    x_im_diffs(i) = im_diffs(x_indices(i));
    y_im_diffs(i) = im_diffs(y_indices(i));
    
    x_errs(i) = errs(x_indices(i));
    y_errs(i) = errs(y_indices(i));
end


% Plot mean image difference vs amplitude
% figure;
% hold on
% plot(strain_amps,x_im_diffs,'bo')
% % title('Image difference vs strain amplitude');
% xlabel('Strain amplitude');
% ylabel('Mean difference between images');
% % axis([0 max(t) 0.03 0.15]);
% hold off

% Plot mean image difference vs amplitude with error bars
figure;
hold on
errorbar(strain_amps,x_im_diffs, x_errs, 'bo')
errorbar(strain_amps,y_im_diffs, y_errs, 'ro')
xlabel('Strain amplitude');
ylabel('Mean difference between images');
% axis([0 max(t) 0.03 0.15]);
hold off

% % Save strain amplitudes and mean image difference data for later use
% csvwrite(strainAmpFilepath, strain_amps'); 
% csvwrite(IDFilepath_x, x_im_diffs);
% csvwrite(IDErrFilepath_x, x_errs);
% csvwrite(IDFilepath_y, y_im_diffs);
% csvwrite(IDErrFilepath_y, y_errs);
