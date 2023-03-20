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
% v5: preparation for parallelizing code
% v6: more preparation for parallelizing. Iterate over single variable
% instead of z and t separately.

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

meanXYDiff = zeros(numtframes-1,(zfin+1-zini));
meanImageDiff = zeros(numtframes-1,1);
meanXYDiffNormalized = zeros(numtframes-1,(zfin+1-zini));

%% Iterate through z and t together
% total number of iterations using numtframes-1 since I need to subtract
% subsequent images (so the number of data points I get is the total number
% of times - 1)
numFrames = zsiz * (numtframes-1);

for ff = 1:numFrames
    % ff = zframe + (tframe-1) * zsiz
    tframe = floor(double(ff-1)/double(zsiz)) + 1;
    zframe = ff - (tframe-1)*double(zsiz);
    
    A1 = zeros(ysiz, xsiz); 
    A2 = zeros(ysiz, xsiz);
    
    % Import first image as A1:
    A1(:,:) = imread(all_paths_otsu_shaped{zframe, tframe}); 
    
    % Import second image as A2:
    A2(:,:) = imread(all_paths_otsu_shaped{zframe, tframe+1});
    
    meanXYDiff(tframe, zframe) = mean(mean(abs(A1(:,:)-A2(:,:))));
    meanIntensity1 = mean(mean(A1(:,:)));
    meanIntensity2 = mean(mean(A2(:,:)));
    meanIntensity = (meanIntensity1 + meanIntensity2)/2;
    
    meanXYDiffNormalized(tframe, zframe) = meanXYDiff(tframe, zframe)/meanIntensity;
    
end

%% Calculate meanImageDiff for each time frame
% Averaged over all zframes
for tframe = 1:1:numtframes-1
%     center_section = zini + uint32(zsiz/4):1:zfin - uint32(zsiz/4);
    meanImageDiff(tframe) = mean(meanXYDiff(tframe, zini:dz:zfin));
end


%% Write image difference results to file
csvwrite(meanImageDiffpath, meanImageDiff);
csvwrite(meanXYDiffpath, meanXYDiff); 
csvwrite(meanXYDiffNormalizedpath, meanXYDiffNormalized);

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