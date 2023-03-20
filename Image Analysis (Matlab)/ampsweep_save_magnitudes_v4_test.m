% Plot image difference over the course of an amplitude sweep.
% Plot both image difference vs time and image difference vs shear amplitude.

% v2: works for new multi-image file parallel processing data
% v3: updated for imageDiff_v8 where image data
% v4: also save uncertainties (standard deviation)


%% Amp-sweeep data
% folder = 'C:\Eric\Xerox Data\30um gap runs\0.3333Hz 4-11-17\1.5V\';
% folder = 'C:\Eric\Xerox Data\30um gap runs\0.5Hz combined gel runs 1-17-17\0.4V\';
% folder = 'C:\Eric\Xerox Data\30um gap runs\5-24-19 data\0.8V\';
% file = 'ampsweep-post-train';
% file = 'ampsweep-pre-train';

folder = 'D:\Xerox Data\30um gap runs\0.5Hz combined gel runs 1-17-17\1.8V\';
file = 'ampsweep_pre_train';

% file = 'ampsweep';
% file = 'ampsweep_pre_train';


imDiffFolder = [folder, file, '_imageDiff\'];

% filebase = filename(1:length(filename)-4);

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
figure;
t = 1:1:length(mid);
% t = t*2;
hold on
plot(t,mid,'b:o');

title('Mean image difference over time (OTSU)');
xlabel('Shear cycles');
ylabel('Mean difference between images');
% axis([0 max(t) 0.025 0.1]);
hold off

%% Manually find the correct starting points
% Sort time axis into different amplitudes. Note that the starting point
% will be different for different runs.
% Manually enter starting point (first data point to be used) and check
% results.
% Start: first point after first spike
first = 14;

%%%%%%%%%%%%%%%%%%%% CHANGE PRE TO POST SWEEP %%%%%%%%%%%
numAmplitudes = 16; %Dont change by accident! (change if needed!)
% numAmplitudes = 7;
% numAmplitudes = 16;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
meandiff = zeros(1, numAmplitudes);
mean_diff_xy = zeros(1, numAmplitudes);
diff_std = zeros(1, numAmplitudes);

ppa = 10; % data Points Per Amplitude (to average over)
skip = ppa + 2; % data points to jump over between consecutive starting of averaging

% Select time steps to average over. Get meandiff from averaging mean image
% difference over timesteps. Get uncertainty by taking standard deviation
% from meanXYDiff over same timesteps
for i = 1:1:numAmplitudes
    tstart = first + (i-1)*skip;
    tend = first + (i-1) *skip +(ppa-1);
    meandiff(i) = mean(mid(tstart: tend));
    
    % make 2D array of all individual image mean diffs for selected times
    selected_image_diffs_mat = mid_xy(tstart:tend,:);
    % convert to single column (could make more efficient but not worth it)
    selected_image_diffs = reshape(selected_image_diffs_mat, [1, numel(selected_image_diffs_mat)]);
    % identical to meandiff except for rounding errors
    mean_diff_xy(i) = mean(selected_image_diffs); 
    diff_std(i) = std(selected_image_diffs);
    
end

% Have to manually enter strain amplitudes used
%%%%%%%%%%%%%%%%%%%% CHANGE PRE TO POST SWEEP %%%%%%%%%%%
% strainAmps = 0.2:0.2:2.6;
% strainAmps = 0.2:0.4:2.6;

% strainAmps = 0.1:0.1:2.0;

strainAmps = 0.3:0.3:4.8;

% strainAmps = 0.2:0.2:3.0;
% strainAmps = 0.1:0.2:2.9;

% strainAmps = 0.05:0.05:0.8;

% strainAmps = 0.1:0.2:2.5;
% strainAmps = 0.1:0.4:2.5;

% strainAmps = 0.3:0.3:3.9;
% strainAmps = 0.3:0.6:3.9;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Test plot mean image difference vs time with amplitude averaging data
% Makes sure my mean image difference vs strain amplitude graph has the
% right mean image difference numbers.
figure;
t = 1:1:length(mid);
% t = t*2;
hold on
plot(t,mid,'b:o');
plot((first + uint8(ppa/2)):skip:(first + (numAmplitudes-1)*skip + uint8(ppa/2)), meandiff, 'ro');

% plot((start + uint8(ppa/2)):skip:(start + (numAmplitudes-1)*skip + uint8(ppa/2)), meandiffTotal, 'ro');

title('Mean image difference over time');
xlabel('Shear cycles');
ylabel('Mean difference between images');
% axis([0 max(t) 0.02 0.15]);
hold off

%% Plot mean image difference vs amplitude
% figure;
% hold on
% plot(strainAmps,mean_diff_xy,'bo')
% % title('Image difference vs strain amplitude');
% xlabel('Strain amplitude');
% ylabel('Mean difference between images');
% % axis([0 max(t) 0.03 0.15]);
% hold off

% Plot mean image difference vs amplitude with error bars
figure;
hold on
errorbar(strainAmps, mean_diff_xy, diff_std, 'bo')
xlabel('Strain amplitude');
ylabel('Mean difference between images');
% axis([0 max(t) 0.03 0.15]);
hold off
%% Save strain amplitudes and mean image difference data for later use
csvwrite(strainAmpFilepath, strainAmps.'); 
csvwrite(IDFilepath, mean_diff_xy.');
csvwrite(IDErrFilepath, diff_std.');
