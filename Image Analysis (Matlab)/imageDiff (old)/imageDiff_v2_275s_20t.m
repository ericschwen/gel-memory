function imageDiff(file_path)

% file_path: .lsm file path for time series.

% Calculates mean difference between pixels in consecutive images
% (zstacks).

% Calculates the mean difference between xy images for each z height
% so comparisons for different heights can be obtained.

% Normalizes mean diffference for number of particles by dividing by the
% average number of nonzero pixels in the two images being subtracted. For
% now, this saves to a separate mean xy image difference file.

% Modification History:

% Example file_path:
% file_path = ['C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 1.2V 7-10-16.mdb\timeseries1.lsm'];

filebase = file_path(1:length(file_path)-4);
% Save image difference to file
meanImageDiffCenterpath = [filebase '_meanImageDiffCenter_otsu.csv'];
meanXYDiffpath = [filebase '_meanXYDiff_otsu.csv'];
meanXYDiffNormalizedpath = [filebase '_meanXYDiff_otsu_pnumberNorm.csv'];

otsufilepath = [filebase '_bpass_otsu.tif'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Choose how many time steps to calculate image difference for:
numtframes = 20;
% Designate number of slices in zstack
zsiz = 275;
% Imaging frequency
freq = 1;
% row, column, height = y, x, z
xsiz = 512;
ysiz = 256;

zini = 1;
dz = 1;
zfin = zsiz;
% Size of zstack. Can be different from 
% zfin if there is an excluded part in bottom or top of image.

A1 = zeros(ysiz, xsiz, zfin); 
A2 = zeros(ysiz, xsiz, zfin);

% Set A1 to the initial zstack:
cnt = 1;
for zframe = zini:dz:zfin
    A1(:, :, cnt) = imread(otsufilepath, zframe); 
    cnt = cnt +1;
end

meanXYDiff = zeros(numtframes-1,(zfin+1-zini));
meanImageDiffCenter = zeros(numtframes-1,1);
meanXYDiffNormalized = zeros(numtframes-1,(zfin+1-zini));

% Iterate through times. For each time: import the unshifted image and 
% calculate the image shift.
% Start with tframe 2 siince the first frame is already in A1 above
for tframe = 2:1:numtframes
    
    % Import unshifted image:
    cnt = 1;
    for zframe = zini:dz:zfin
        A2(:, :, cnt) = imread(otsufilepath, (tframe-1)*zsiz + zframe);
        cnt = cnt + 1;
    end
    
    
        
    % Generate shifted image: (Could make more efficient by moving if
    % statement)
    cnt = 1;
    for zframe = zini:dz:zfin
        % Just calculate meanXYDiff
        meanXYDiff((tframe-1),cnt) = mean(mean(abs(A1(:,:,cnt)-A2(:,:,cnt))));
        
        meanIntensity1 = mean(mean(A1(:,:,cnt)));
        meanIntensity2 = mean(mean(A2(:,:,cnt)));
        meanIntensity = (meanIntensity1 + meanIntensity2)/2;
        
        meanXYDiffNormalized((tframe-1),cnt) = meanXYDiff((tframe-1),cnt)/meanIntensity;
        
        cnt = cnt + 1;
    end
    
    % Calculate meanImageDiff for center section of zstack for each
    % timestep
    center_section = zini + int32(zsiz/4):1:zfin - int32(270/4);
    meanImageDiffCenter((tframe-1)) = mean(meanXYDiff((tframe-1), center_section));
     
    % Set A1 to the unshifted image for the next calculation.
    A1 = A2;
end
 
csvwrite(meanImageDiffCenterpath, meanImageDiffCenter);
csvwrite(meanXYDiffpath, meanXYDiff); 
csvwrite(meanXYDiffNormalizedpath, meanXYDiffNormalized);

% Plot mean difference between images over time
figure;
x = 1:1:numtframes-1;
t = x/freq;
plot(t,meanImageDiffCenter(x),'b:o');
title('Mean difference between images vs time');
xlabel('Time (s)');
ylabel('Mean difference between images');

% % Plot with time from first few times subtracted.
% figure;
% startCut = 3;
% x = startCut:1:numtframes-1;
% t = (x - (startCut-1)) /freq;
% plot(t,meanImageDiff(x),'b:o');
% title('Mean difference between images vs time');
% xlabel('Time (s)');
% ylabel('Mean difference between images');
 
end