% Plot image difference over the course of an amplitude sweep.
% Plot both image difference vs time and image difference vs shear amplitude.

% Amp-sweeep data
folder = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\0.5Hz combined gel runs 1-17-17\';
fileList = {'0.6V\ampsweep_pre_train.lsm'};

% Declare data storage
fileNumbers = 1:1:length(fileList);
numfiles = length(fileList);

% Declare cell array sizes.
filename = cell(numfiles,1);
filebase = cell(numfiles,1);
midpath = cell(numfiles,1);
mid = cell(numfiles,1);
legendInfo = cell(numfiles,1);

xydpath = cell(numfiles,1);
xyd = cell(numfiles,1);

% Import data
for i = fileNumbers
    filename{i} = [folder, fileList{i}];
    % May need to change name of file from timeseries to ts, etc.
    filebase{i} = filename{i}(1:length(filename{i})-4);
%     midpath{i} = [filebase{i} '_meanImageDiff_normalized_postbpass.csv'];
    midpath{i} = [filebase{i} '_meanImageDiffCenter_otsu.csv'];
    mid{i} = xlsread(midpath{i});
%     mid{i} = mid{i}(3:length(mid{i})-2);
    
    if i == 1
        midtotal = mid{i};
    else
        midtotal = cat(1,midtotal,mid{i});
    end
end

% Plot raw image difference vs time
figure;
t = 1:1:length(midtotal);
% t = t*2;
hold on
plot(t,midtotal,'b:o');

title('Mean image difference over time');
xlabel('Shear cycles');
ylabel('Mean difference between images');
% axis([0 max(t) 0.03 0.15]);
hold off

% Sort time axis into different amplitudes. Note that the starting point
% will be different for different runs.
numAmplitudes = 16;
ppa = 10; % data Points Per Amplitude
start = 11;
for i = 1:1:numAmplitudes
    meandiff(i) = mean(midtotal(start + (i-1)*12: start + (i-1) *12 +(ppa-1)));
end

figure;
hold on
strainAmps = 0.1:0.1:1.6;
plot(strainAmps,meandiff,'bo')
title('Image difference vs strain amplitude');
xlabel('Strain amplitude');
ylabel('Mean difference between images');
% axis([0 max(t) 0.03 0.15]);
hold off


