function imageDiff(params, all_paths, folder)
%%
% Calculates mean difference between pixels in consecutive images
% (zstacks).

% Calculates the mean difference between xy images for each z height.

% Normalizes mean difference for number of particles by dividing by the
% average number of nonzero pixels in the two images being subtracted. For
% now, this saves to a separate mean xy image difference file.

%% Modification History:
% v3: remove otsu part for testing
% v4: bring back otsu. Switch to inputs from parameter list and folder
% path. then updated to pull otsu images from folder instead of single file
% v5: preparation for parallelizing code
% v6: more preparation for parallelizing. Iterate over single variable
% instead of z and t separately.
% v7: parallelize

%% Import sizes from params structure
numtframes = uint32(params.stack_size.T);
xsiz = uint32(params.stack_size.X);
ysiz = uint32(params.stack_size.Y);
zsiz = uint32(params.stack_size.Z);

%% Parse inputs
if ~strcmp(folder(end),'\'), folder = [folder '\']; end

%% Make new output folder
folderParts = strsplit(folder, '\');
parent = strjoin(folderParts(1:end-2), '\');
newfolder = strcat(folderParts(end-1), '_imageDiff');
mkdir(parent, newfolder{1});

outfolder = [parent, '\', newfolder{1}, '\'];

%% Declare names of files to save to
meanImageDiffpath = [outfolder '\meanImageDiff_otsu.csv'];
meanXYDiffpath = [outfolder '\meanXYDiff_otsu.csv'];
meanXYDiffNormalizedpath = [outfolder '\meanXYDiff_otsu_pnumberNorm.csv'];

%% Make new all_paths_otsu to get otsu file paths
otsuFolderPath = [folder(1:end-1) '_otsu'];

all_paths_otsu = cellfun(@(f) {[otsuFolderPath '\' getFileName(f)]}, all_paths);

out_supersize = [zsiz numtframes];
all_paths_otsu_shaped = reshape(all_paths_otsu, out_supersize);

% Now all_paths_otsu_shaped{z,t} gives the path to the specified otsu
% filtered image 
% Equivalent to all_paths_otsu{zframe + (tframe-1) * zsiz}

%% Declare results arrays

zini = 1;
dz = 1;
zfin = zsiz;
% Size of zstack. Can be different from 
% zfin if there is an excluded part in bottom or top of image.

numFrames = zsiz * (numtframes-1);
% total number of iterations using numtframes-1 since I need to subtract
% subsequent images (so the number of data points I get is the total number
% of times - 1)

meanXYDiff = zeros(numFrames,1);
meanImageDiff = zeros(numtframes-1,1);
meanXYDiffNormalized = zeros(numFrames,1);

%% Iterate through z and t together

parfor ff = 1:numFrames
    % ff = zframe + (tframe-1) * zsiz
    tframe = floor(double(ff-1)/double(zsiz)) + 1;
    zframe = ff - (tframe-1)*double(zsiz);
    
    A1 = zeros(ysiz, xsiz); 
    A2 = zeros(ysiz, xsiz);
    
    % Import first image as A1:
    A1(:,:) = imread(all_paths_otsu_shaped{zframe, tframe}); 
    
    % Import second image as A2:
    A2(:,:) = imread(all_paths_otsu_shaped{zframe, tframe+1});
    
    meanXYDiff(ff) = mean(mean(abs(A1(:,:)-A2(:,:))));
    meanIntensity1 = mean(mean(A1(:,:)));
    meanIntensity2 = mean(mean(A2(:,:)));
    meanIntensity = (meanIntensity1 + meanIntensity2)/2;
    
    meanXYDiffNormalized(ff) = meanXYDiff(ff)/meanIntensity;
    
end

%% Reshape meanXY arrays
% Use to call meanXYDiff_shaped(tframe, zframe)
out_supersize = [zsiz (numtframes-1)];
meanXYDiff_shaped = reshape(meanXYDiff, out_supersize);
meanXYDiff_shaped = meanXYDiff_shaped.';
meanXYDiffNormalized_shaped = reshape(meanXYDiffNormalized, out_supersize);
meanXYDiffNormalized_shaped = meanXYDiffNormalized_shaped.';

%% Calculate meanImageDiff for each time frame
% Averaged over all zframes
for tframe = 1:1:numtframes-1
%     center_section = zini + uint32(zsiz/4):1:zfin - uint32(zsiz/4);
    meanImageDiff(tframe) = mean(meanXYDiff_shaped(tframe, zini:dz:zfin));
end

%% Write image difference results to file
csvwrite(meanImageDiffpath, meanImageDiff);
csvwrite(meanXYDiffpath, meanXYDiff_shaped); 
csvwrite(meanXYDiffNormalizedpath, meanXYDiffNormalized_shaped);

%% Plot mean difference between images over time
figure;
cycles = 1:1:numtframes-1;
plot(cycles,meanImageDiff(cycles),'b:o');
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