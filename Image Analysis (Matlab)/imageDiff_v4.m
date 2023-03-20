function imageDiff(params, all_paths, folder)
%%
% Calculates mean difference between pixels in consecutive images
% (zstacks).

% Calculates the mean difference between xy images for each z height
% so comparisons for different heights can be obtained.

% Normalizes mean diffference for number of particles by dividing by the
% average number of nonzero pixels in the two images being subtracted. For
% now, this saves to a separate mean xy image difference file.

%% Modification History:
% v3: remove otsu part for testing
% v4: bring back otsu. Switch to inputs from parameter list and folder
% path. then updated to pull otsu images from folder instead of single file

%% Declare names of files to save to
meanImageDiffCenterpath = [folder '\meanImageDiffCenter_otsu.csv'];
meanXYDiffpath = [folder '\meanXYDiff_otsu.csv'];
meanXYDiffNormalizedpath = [folder '\meanXYDiff_otsu_pnumberNorm.csv'];

%% Import sizes from params structure
numtframes = uint32(params.stack_size.T);
xsiz = uint32(params.stack_size.X);
ysiz = uint32(params.stack_size.Y);
zsiz = uint32(params.stack_size.Z);

%% Make new all_paths_otsu to get otsu file paths
otsuFolderPath = [folder '_otsu'];

all_paths_otsu = cellfun(@(f) {[otsuFolderPath '\' getFileName(f)]}, all_paths);

out_supersize = [zsiz numtframes];
all_paths_otsu_shaped = reshape(all_paths_otsu, out_supersize);

% Now all_paths_otsu_shaped{z,t} gives the path to the specified otsu
% filtered image

%% Declare data storage and results arrays

zini = 1;
dz = 1;
zfin = zsiz;
% Size of zstack. Can be different from 
% zfin if there is an excluded part in bottom or top of image.

A1 = zeros(ysiz, xsiz, zfin); 
A2 = zeros(ysiz, xsiz, zfin);
meanXYDiff = zeros(numtframes-1,(zfin+1-zini));
meanImageDiffCenter = zeros(numtframes-1,1);
meanXYDiffNormalized = zeros(numtframes-1,(zfin+1-zini));


%% Import initial image

% Set A1 to the initial zstack:
cnt = 1;
for zframe = zini:dz:zfin
    A1(:, :, cnt) = imread(all_paths_otsu_shaped{zframe, 1}); 
    cnt = cnt +1;
end

%% Iterate through times. For each time: import the unshifted image and 
% calculate the image shift.
% Start with tframe 2 since the first frame is already in A1 above
for tframe = 2:1:numtframes
    
    % Import unshifted image:
    cnt = 1;
    for zframe = zini:dz:zfin
        A2(:, :, cnt) = imread(all_paths_otsu_shaped{zframe, tframe});
        cnt = cnt + 1;
    end
    

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
    center_section = zini + uint32(zsiz/4):1:zfin - uint32(zsiz/4);
    meanImageDiffCenter((tframe-1)) = mean(meanXYDiff((tframe-1), center_section));
     
    % Set A1 to the unshifted image for the next calculation.
    A1 = A2;
end

%% Write image difference results to file
csvwrite(meanImageDiffCenterpath, meanImageDiffCenter);
csvwrite(meanXYDiffpath, meanXYDiff); 
csvwrite(meanXYDiffNormalizedpath, meanXYDiffNormalized);

%% Plot mean difference between images over time
figure;
cycles = 1:1:numtframes-1;
plot(cycles,meanImageDiffCenter(cycles),'b:o');
title('Mean difference between images vs cycle');
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