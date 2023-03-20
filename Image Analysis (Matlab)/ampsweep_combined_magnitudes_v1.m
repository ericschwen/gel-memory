% Plot image difference over the course of an amplitude sweep.
% Combined version looks at alternating untrained and trained. Modified
% from ampsweep_save_magnitudes_v4


%% Amp-sweeep data

folder = 'C:\Eric\Xerox Data\30um gap runs\5-24-19 data\0.6V\';
file = 'ampsweep-post-train-combined';

imDiffFolder = [folder, file, '_imageDiff\'];

%% Decalre files for saving strain amplitude and image difference to file
strainAmpFilepath = [imDiffFolder, 'strainAmplitudes.csv'];
IDFilepath = [imDiffFolder, 'imageDifferenceAmpsweep.csv'];
IDErrFilepath = [imDiffFolder, 'imageDifferenceAmpsweepErr.csv'];

%% Import mean image difference (mid) data
midpath = [imDiffFolder, 'meanImageDiff_otsu.csv'];
mid = xlsread(midpath); % mid = mean image difference

mid_xy_path = [imDiffFolder, 'meanXYDiff_otsu.csv'];
mid_xy = xlsread(mid_xy_path); % mid = mean image difference

%% Plot raw image difference vs time
figure('units','normalized','outerposition',[0 0 1 1]);
t = 1:1:length(mid);
hold on
plot(t,mid,'b:o');

title('Mean image difference over time (OTSU)');
xlabel('Shear cycles');
ylabel('Mean difference between images');
axis([0 max(t) 0.0 0.4]);

% Select points to fit (sets of 4) for each amplitude
start = 108;
last = start + 3;

im_diff = mean(mid(start:last))
err = std(mid(start:last))

% plot chosen im_diff to check
plot(start, im_diff, 'ro')
hold off
% 
% 
% % 0.6V 5-2-19 data
% strain_amps = 0.2:0.2:2.6;
% x_im_diff = [.0236 .0257 .0281 .0338 .0370 .0509 .0500 .0644 .0608 .0748 .0721 .0901 .0738];
% y_im_diff = [.0234 .0290 .0380 .0442 .0576 .0641 .0782 .0850 .0971 .1014 .1286 .1309 .1674];


% % Plot mean image difference vs amplitude
% figure;
% hold on
% plot(strain_amps, x_im_diff,'bo')
% plot(strain_amps, y_im_diff, 'ro')
% % title('Image difference vs strain amplitude');
% xlabel('Strain amplitude');
% ylabel('Mean difference between images');
% % axis([0 max(t) 0.03 0.15]);
% hold off

% %% Manually find the correct starting points
% % Sort time axis into different amplitudes. Note that the starting point
% % will be different for different runs.
% % Manually enter starting point (first data point to be used) and check
% % results.
% % Start: first point after first spike
% first = 4;
% 
% %%%%%%%%%%%%%%%%%%%% CHANGE PRE TO POST SWEEP %%%%%%%%%%%
% % numAmplitudes = 13; %Dont change by accident! (change if needed!)
% numAmplitudes = 7;
% % numAmplitudes = 16;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% meandiff = zeros(1, numAmplitudes);
% mean_diff_xy = zeros(1, numAmplitudes);
% diff_std = zeros(1, numAmplitudes);
% 
% ppa = 4; % data Points Per Amplitude (to average over)
% skip = ppa + 3; % data points to jump over between consecutive starting of averaging
% 
% % Select time steps to average over. Get meandiff from averaging mean image
% % difference over timesteps. Get uncertainty by taking standard deviation
% % from meanXYDiff over same timesteps
% for i = 1:1:numAmplitudes
%     tstart = first + (i-1)*skip;
%     tend = first + (i-1) *skip +(ppa-1);
%     meandiff(i) = mean(mid(tstart: tend));
%     
%     % make 2D array of all individual image mean diffs for selected times
%     selected_image_diffs_mat = mid_xy(tstart:tend,:);
%     % convert to single column (could make more efficient but not worth it)
%     selected_image_diffs = reshape(selected_image_diffs_mat, [1, numel(selected_image_diffs_mat)]);
%     % identical to meandiff except for rounding errors
%     mean_diff_xy(i) = mean(selected_image_diffs); 
%     diff_std(i) = std(selected_image_diffs);
%     
% end
% 
% % Have to manually enter strain amplitudes used
% %%%%%%%%%%%%%%%%%%%% CHANGE PRE TO POST SWEEP %%%%%%%%%%%
% % strainAmps = 0.2:0.2:2.6;
% strainAmps = 0.2:0.4:2.6;
% 
% % strainAmps = 0.2:0.2:3.0;
% % strainAmps = 0.1:0.2:2.9;
% 
% % strainAmps = 0.05:0.05:0.8;
% 
% % strainAmps = 0.1:0.2:2.5;
% % strainAmps = 0.1:0.4:2.5;
% 
% % strainAmps = 0.3:0.3:3.9;
% % strainAmps = 0.3:0.6:3.9;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %% Test plot mean image difference vs time with amplitude averaging data
% % Makes sure my mean image difference vs strain amplitude graph has the
% % right mean image difference numbers.
% figure;
% t = 1:1:length(mid);
% % t = t*2;
% hold on
% plot(t,mid,'b:o');
% plot((first + uint8(ppa/2)):skip:(first + (numAmplitudes-1)*skip + uint8(ppa/2)), meandiff, 'ro');
% 
% % plot((start + uint8(ppa/2)):skip:(start + (numAmplitudes-1)*skip + uint8(ppa/2)), meandiffTotal, 'ro');
% 
% title('Mean image difference over time');
% xlabel('Shear cycles');
% ylabel('Mean difference between images');
% % axis([0 max(t) 0.02 0.15]);
% hold off
% 
% %% Plot mean image difference vs amplitude
% % figure;
% % hold on
% % plot(strainAmps,mean_diff_xy,'bo')
% % % title('Image difference vs strain amplitude');
% % xlabel('Strain amplitude');
% % ylabel('Mean difference between images');
% % % axis([0 max(t) 0.03 0.15]);
% % hold off
% 
% % Plot mean image difference vs amplitude with error bars
% figure;
% hold on
% errorbar(strainAmps, mean_diff_xy, diff_std, 'bo')
% xlabel('Strain amplitude');
% ylabel('Mean difference between images');
% % axis([0 max(t) 0.03 0.15]);
% hold off
% %% Save strain amplitudes and mean image difference data for later use
% csvwrite(strainAmpFilepath, strainAmps.'); 
% csvwrite(IDFilepath, mean_diff_xy.');
% csvwrite(IDErrFilepath, diff_std.');
