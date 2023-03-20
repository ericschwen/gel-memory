% Plot image difference over the course of an amplitude sweep.
% Plot both image difference vs time and image difference vs shear amplitude.

% v2: works for new multi-image file parallel processing data
% v3: updated for imageDiff_v8 where image data


%% Amp-sweeep data
folder = 'D:\Xerox Data\30um gap runs\7-3-18 data\0.9V\';
% file = 'ampsweep-post-train';
file = 'ampsweep-pre-train';


imDiffFolder = [folder, file, '_imageDiff\'];

% filebase = filename(1:length(filename)-4);

%% Decalre files for saving strain amplitude and image difference to file
strainAmpFilepath = [imDiffFolder, 'strainAmplitudes.csv'];
IDFilepath = [imDiffFolder, 'imageDifferenceAmpsweep.csv'];

%% Import mean image difference (mid) data
midpath = [imDiffFolder, 'meanImageDiff_otsu.csv'];
mid = xlsread(midpath); % mid = mean image difference

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
start = 4;

%%%%%%%%%%%%%%%%%%%% CHANGE PRE TO POST SWEEP %%%%%%%%%%%
% numAmplitudes = 13; %Dont change by accident! (change if needed!)
numAmplitudes = 7;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
meandiff = zeros(1, numAmplitudes);

ppa = 4; % data Points Per Amplitude (to average over)
skip = ppa + 3; % data points to jump over between consecutive starting of averaging
for i = 1:1:numAmplitudes
    meandiff(i) = mean(mid(start + (i-1)*skip: start + (i-1) *skip +(ppa-1)));
end

%% Have to manually enter strain amplitudes used
%%%%%%%%%%%%%%%%%%%% CHANGE PRE TO POST SWEEP %%%%%%%%%%%
% strainAmps = 0.2:0.2:2.6;
strainAmps = 0.2:0.4:2.6;

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
plot((start + uint8(ppa/2)):skip:(start + (numAmplitudes-1)*skip + uint8(ppa/2)), meandiff, 'ro');

% plot((start + uint8(ppa/2)):skip:(start + (numAmplitudes-1)*skip + uint8(ppa/2)), meandiffTotal, 'ro');

title('Mean image difference over time');
xlabel('Shear cycles');
ylabel('Mean difference between images');
% axis([0 max(t) 0.02 0.15]);
hold off

%% Plot mean image difference vs amplitude
figure;
hold on
plot(strainAmps,meandiff,'bo')
title('Image difference vs strain amplitude');
xlabel('Strain amplitude');
ylabel('Mean difference between images');
% axis([0 max(t) 0.03 0.15]);
hold off
%  
%% Save strain amplitudes and mean image difference data for later use
csvwrite(strainAmpFilepath, strainAmps.'); 
csvwrite(IDFilepath, meandiff.'); 
