% Plot image difference over the course of an amplitude sweep.
% Plot both image difference vs time and image difference vs shear amplitude.

% Amp-sweeep data
folder = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\0.2Hz combined runs 1-31-16\1.0V (2)\';
file = 'training\training.lsm';

filename = [folder, file];
filebase = filename(1:length(filename)-4);

% Save strain amplitude and image difference to file
strainAmpFilepath = [filebase, '_strainAmplitudes.csv'];
IDFilepath = [filebase, '_imageDifferenceAmpsweep.csv'];

% Import mean image difference (mid) data
midpath = [filebase, '_meanImageDiffCenter_otsu.csv'];
mid = xlsread(midpath);

% Plot raw image difference vs time
figure;
t = 1:1:length(mid);
% t = t*2;
hold on
plot(t,mid,'b:o');

title('Mean image difference over time (OTSU)');
xlabel('Shear cycles');
ylabel('Mean difference between images');
axis([0 max(t) 0.03 0.06]);
hold off


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sort time axis into different amplitudes. Note that the starting point
% will be different for different runs.
% Manually enter starting point (first data point to be used) and check
% results.
start = 10;

numAmplitudes = 16; %Dont change by accident! (change if needed!)
ppa = 10; % data Points Per Amplitude
for i = 1:1:numAmplitudes
    meandiff(i) = mean(mid(start + (i-1)*12: start + (i-1) *12 +(ppa-1)));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Have to manually enter strain amplitudes used
strainAmps = 0.05:0.05:0.8;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Plot mean image difference vs amplitude
figure;
hold on
plot(strainAmps,meandiff,'bo')
title('Image difference vs strain amplitude');
xlabel('Strain amplitude');
ylabel('Mean difference between images');
% axis([0 max(t) 0.03 0.15]);
hold off

% Test plot mean image difference vs time with amplitude averaging data
% Makes sure my mean image difference vs strain amplitude graph has the
% right mean image difference numbers.
figure;
t = 1:1:length(mid);
% t = t*2;
hold on
plot(t,mid,'b:o');
plot(start + uint8(ppa/2):12:start + (numAmplitudes-1)*12 + uint8(ppa/2), meandiff, 'ro');

title('Mean image difference over time');
xlabel('Shear cycles');
ylabel('Mean difference between images');
% axis([0 max(t) 0.03 0.15]);
hold off

% 
% Save strain amplitudes and mean image difference data for later use
csvwrite(strainAmpFilepath, strainAmps.'); 
csvwrite(IDFilepath, meandiff.'); 
