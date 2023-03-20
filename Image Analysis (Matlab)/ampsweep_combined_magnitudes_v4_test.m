% Plot image difference over the course of an amplitude sweep.
% Combined version looks at alternating untrained and trained. Modified
% from ampsweep_save_magnitudes_v4

% Mod History:
% v2: automating the process somewhat. Manually declare spacing between
%   separate amplitudes, but do so in a single file. 5-28-19
% v3: alternating x and y version. 6-12-19
% v4: automatically find parts of image difference for each amplitude. May
% have to manually adjust cutoff_factor to find correctly. Can use
% skip_first option to skip the initial cycle at each amplitude. 6-18-19


% Amp-sweeep data
% 
% folder = 'C:\Eric\Xerox Data\30um gap runs\6-14-19 data\0.6V\';
% file = 'ampsweep-pre-train';
folder = 'D:\Xerox Data\30um gap runs\0.2Hz combined runs 1-31-17\0.0V\';
file = 'ampsweep_pre_train';

imDiffFolder = [folder, file, '_imageDiff\'];

% Import mean image difference (mid) data
midpath = [imDiffFolder, 'meanImageDiff_otsu.csv'];
mid = xlsread(midpath); % mid = mean image difference

% mid_xy_path = [imDiffFolder, 'meanXYDiff_otsu.csv'];
% mid_xy = xlsread(mid_xy_path); % mid = mean image difference

% Automatically find the start point for each amplitude
% num_amplitudes = 22;
num_amplitudes = 20;
firsts = zeros(num_amplitudes, 1);
im_diffs = zeros(num_amplitudes,1);
errs = zeros(num_amplitudes,1);

% Iterate through number of ampliutdes and find start index for each one
% Cutoff factor may need to be adjusted to group correctly.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cutoff_factor = 0.2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:num_amplitudes
    if i == 1
        iter = 17;
    else
        iter = firsts(i-1) + 1;
    end
    
    % loop through image difference and find groups of 4 with std below
    % a cutoff
    found = false;
    while found == false
        if std(mid(iter:iter+5)) > cutoff_factor*mean(mid(iter:iter+5))
            iter = iter+1;
        else
            firsts(i) = iter;
            found = true;
        end
    end
end

% Loop through amplitudes and find mean image difference for each.
% Alternate version skips first cycle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
skip_first = false;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:num_amplitudes
    if skip_first == false
        % STANDARD
        im_diffs(i) = mean(mid(firsts(i): firsts(i)+3));
        errs(i) = std(mid(firsts(i):firsts(i)+3));
    else
        % ALTERNATE -- SKIP FIRST
        im_diffs(i) = mean(mid(firsts(i)+1: firsts(i)+3));
        errs(i) = std(mid(firsts(i)+1:firsts(i)+3));
    end
end


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

box on
% plot chosen im_diff to check
plot(firsts, im_diffs, 'mo')
hold off

%% Separate x and y differences
% strain_amps_y = 0.2:0.2:2.6;
% strain_amps_x = 0.2:0.2:2.6;
% x_indices = [1 4 5 8 9 12 13 16 17 20 21 24 25];
% y_indices = [2 3 6 7 10 11 14 15 18 19 22 23 26];
% % x_indices = [1 4 5 8 9 12 13 16 17 20 22 25 26];
% % y_indices = [2 3 6 7 10 11 14 15 18 19 23 24 27];

% low voltage version
% strain_amps = [.1 .2 .3 .4 .5 .6 .8 1.0 1.4 1.8 2.2 2.6];
% x_indices = [1 4 5 8 9 12 13 16 17 20 21 24];
% y_indices = [2 3 6 7 10 11 14 15 18 19 22 23];

% % Alternating x and y
% strain_amps_x = 0.1:0.2:2.2;
% strain_amps_y = 0.2:0.2:2.2;
% x_indices = 1:2:22;
% y_indices = 2:2:22;

% % broken 6-11-19 0.6V y-train pre version
% x_indices = [1 3 5 7 9 11 13 15 18 20 22 24 26];
% y_indices = [2 4 6 8 10 12 14 17 19 21 23 25 27];

x_im_diffs = zeros(length(strain_amps_x),1);
y_im_diffs = zeros(length(strain_amps_y),1);
x_errs = zeros(length(strain_amps_x),1);
y_errs = zeros(length(strain_amps_y),1);

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
errorbar(strain_amps_x,x_im_diffs, x_errs, 'bo')
errorbar(strain_amps_y,y_im_diffs, y_errs, 'ro')
xlabel('Strain amplitude');
ylabel('Mean difference between images');
% axis([0 max(t) 0.03 0.15]);
hold off


% Save strain amplitudes and mean image difference data for later use
% Decalre files for saving strain amplitude and image difference to file
strainAmpFilepath_x = [imDiffFolder, 'strainAmplitudes_x.csv'];
strainAmpFilepath_y = [imDiffFolder, 'strainAmplitudes_y.csv'];
csvwrite(strainAmpFilepath_x, strain_amps_x');
csvwrite(strainAmpFilepath_y, strain_amps_y'); 


if skip_first == false
    % STANDARD
    % Version for writing image differences including all points
    IDFilepath_x = [imDiffFolder, 'imageDifferenceAmpsweep_x.csv'];
    IDErrFilepath_x = [imDiffFolder, 'imageDifferenceAmpsweepErr_x.csv'];
    IDFilepath_y = [imDiffFolder, 'imageDifferenceAmpsweep_y.csv'];
    IDErrFilepath_y = [imDiffFolder, 'imageDifferenceAmpsweepErr_y.csv'];
    csvwrite(IDFilepath_x, x_im_diffs);
    csvwrite(IDErrFilepath_x, x_errs);
    csvwrite(IDFilepath_y, y_im_diffs);
    csvwrite(IDErrFilepath_y, y_errs);
else
    % ALTERNATE -- SKIP FIRST
    % Version for writing image differences skipping first point at each amp.
    IDFilepath_x = [imDiffFolder, 'imageDifferenceAmpsweep_x_no1.csv'];
    IDErrFilepath_x = [imDiffFolder, 'imageDifferenceAmpsweepErr_x_no1.csv'];
    IDFilepath_y = [imDiffFolder, 'imageDifferenceAmpsweep_y_no1.csv'];
    IDErrFilepath_y = [imDiffFolder, 'imageDifferenceAmpsweepErr_y_no1.csv'];
    csvwrite(IDFilepath_x, x_im_diffs);
    csvwrite(IDErrFilepath_x, x_errs);
    csvwrite(IDFilepath_y, y_im_diffs);
    csvwrite(IDErrFilepath_y, y_errs);
end




