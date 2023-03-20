function imageDiff_v9(Folder, Subfolder, Stacks)
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
% v8: playing with parallelization 'broadcast variables'
% v9: restructure to take inputs from just a folder full of otsu filtered
% tiffs (for single stacks).
% v9_mod1: gets rid of / in file path


%%
% folder = 'C:\Eric\Xerox Data\30um gap runs\6-22-17 0.3333Hz\1.4V sweep pauses\ampsweep_pre_train\';
% subfolder = '2.0V';
% stacks = {'u1', 'u2', 'u3', 'u4', 'u5', 'u6'};

folder = Folder;
subfolder = Subfolder;
stacks = Stacks;

path_bases = cell(length(stacks), 1);

for i = 1:length(stacks)
    path_bases{i} = [folder, subfolder, '', stacks{i}, '_otsu2D', '\'];
end

imdiff_folder = [folder, subfolder, '', stacks{1}(1), '_imdiff2D'];
mkdir(imdiff_folder)
out_folder = [imdiff_folder, '\'];

% Number of slices in zstacks
xsiz = 512; % could get these from params produced by lsm_parallel_import
ysiz = 512;
zsiz = 50;
numtframes = length(stacks);

%% Declare names of files to save to
meanImageDiffpath = [out_folder '\meanImageDiff_otsu.csv'];
meanXYDiffpath = [out_folder '\meanXYDiff_otsu.csv'];
meanXYDiffNormalizedpath = [out_folder '\meanXYDiff_otsu_pnumberNorm.csv'];

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
%     A1(:,:) = imread(all_paths_otsu_shaped{zframe, tframe});
    path1 = [path_bases{tframe}, 'z', num2str(zframe), '.tif'];
    A1(:,:) = imread(path1); 
    
    % Import second image as A2:
%     A2(:,:) = imread(all_paths_otsu_shaped{zframe, tframe+1});
%     ff2 = ff + zsiz; %next time frame
    path2 = [path_bases{tframe+1}, 'z', num2str(zframe), '.tif'];
    A2(:,:) = imread(path2);
    
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

% %% Plot mean difference between images over time
% figure;
% cycles = 1:1:numtframes-1;
% plot(cycles,meanImageDiff(cycles),'b:o');
% title('Mean difference between images vs cycle');
% xlabel('Time (s)');
% ylabel('Mean difference between images'); 
end