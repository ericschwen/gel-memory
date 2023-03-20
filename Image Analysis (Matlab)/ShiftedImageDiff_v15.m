function ShiftedImageDiff(params, all_paths, folder)

% Takes inputs of parameters, file paths and the root folder read from 
% xml file by lsm_parallel_import_v3.

% Calculates mean difference between pixels in time series of consecutive 
% images in zstacks.

% Calculates the mean difference between xy images for each z height.
% Accounts from drift by shifting the second image using data from
% drift_matPIV.

% Normalizes mean difference for number of particles by dividing by the
% average number of nonzero pixels in the two images being subtracted. For
% now, this saves to a separate mean xy image difference file.

% Modification History:
% v8: Changed tframe to tframe-1 to fix off by one issue (only 49
% differences in 50 frames)
% v9: Removed old StackDifference implementation and moved it into the
% zframe loop for calculating A2_shifted. 
% v10: Started using bpass.tif instead of lsm file.
% v14: removed normalizing to 128 for otsu filtered difference calculation.
% v15: restructure to take inputs read from xml file by
% lsm_parallel_import_v3.

%% Savitzky-Golay filter?


%% Import sizes from params structure
numtframes = uint32(params.stack_size.T);
xsiz = uint32(params.stack_size.X);
ysiz = uint32(params.stack_size.Y);
zsiz = uint32(params.stack_size.Z);

%% Parse inputs
if ~strcmp(folder(end),'\'), folder = [folder '\']; end

%% Import strain data
strainPathX = [folder '_drift\v_fieldX.csv'];
shiftX= xlsread(strainPathX);
% access as shiftX(tframe, zframe). (The tframe is calculated by
% transition number. tframe 1 is between 1st and 2nd image, etc.)
strainPathY = [folder '_drift\v_fieldY.csv'];
shiftY= xlsread(strainPathY);

%% Make new output folder
folderParts = strsplit(folder, '\');
parent = strjoin(folderParts(1:end-2), '\');
newfolder = strcat(folderParts(end-1), '_imageDiffwoDrift');
mkdir(parent, newfolder{1});

outfolder = [parent, '\', newfolder{1}, '\'];

%% Declare names of files to save to
meanImageDiffpath = [outfolder '\meanImageDiff.csv'];
meanXYDiffpath = [outfolder '\meanXYDiff.csv'];
% meanXYDiffNormalizedpath = [outfolder '\meanXYDiff_pnumberNorm.csv'];

%% Make new all_paths_otsu to get otsu file paths
otsuFolderPath = [folder(1:end-1) '_otsu'];

all_paths_otsu = cellfun(@(f) {[otsuFolderPath '\' getFileName(f)]}, all_paths);

out_supersize = [zsiz numtframes];
all_paths_otsu_shaped = reshape(all_paths_otsu, out_supersize);
all_paths_otsu_shaped = all_paths_otsu_shaped.';

% Now all_paths_otsu_shaped{t,z} gives the path to the specified otsu
% filtered image 
% Equivalent to all_paths_otsu{zframe + (tframe-1) * zsiz}

%% Set sizes
zini = 1;
dz = 1;
zfin = zsiz;

numFrames = zsiz * (numtframes-1);
% total number of iterations using numtframes-1 since I need to subtract
% subsequent images (so the number of data points I get is the total number
% of times - 1)

meanXYDiff = zeros(numFrames,1);
meanImageDiff = zeros(numtframes-1,1);
% meanXYDiffNormalized = zeros(numFrames,1);

%% Iterate through times. For each time: import the unshifted image, create
% the shifted image, and calculate the image shift.

for ff = 1:numFrames
    % ff = zframe + (tframe-1) * zsiz
    tframe = floor(double(ff-1)/double(zsiz)) + 1;
    zframe = ff - (tframe-1)*double(zsiz);
    
    A1 = zeros(ysiz, xsiz); 
    A2 = zeros(ysiz, xsiz);

    % Import first image as A1:
    A1(:,:) = imread(all_paths_otsu_shaped{tframe, zframe}); 
    % Import second image as A2:
    A2(:,:) = imread(all_paths_otsu_shaped{tframe+1, zframe});
    
    % Read the calculated drift in x and y. Round to whole pixel number.
    dx = round(shiftX(tframe, zframe));
    dy = round(shiftY(tframe, zframe));
    
    if dx == 0 && dy == 0
        % Don't need to generate a shifted image.
        meanXYDiff(ff) = mean(mean(abs(A1(:,:)-A2(:,:))));
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Generate shifted image: (Could make more efficient by moving if
    % statement)
    
    % USE IMTRANSLATE
    cnt = 1;
    for zframe = zini:dz:zfin
        % X Shift for this tframe rounded to nearest integer:
        dx = round(shiftX((tframe-1), zframe)); % Need to use tframe-1 since we are using a difference for each one.
        % A2_shifted = A2 if no shift
        if dx ==0
%             A2_shifted(:,:,cnt) = A2(:,:,cnt);
            % Don't need to generate A2_shifted because no shift necessary.
            % Just calculate meanXYDiff
            meanXYDiff((tframe-1),cnt) = mean(mean(abs(A1(:,:,cnt)-A2(:,:,cnt))));
            
        else
            % Calculate the shifted image. Set any sites off the edge to
            % zero.
            for y = 1:1:ysiz
                for x = 1:1:xsiz
                    if (x + dx) > 0 && (x + dx) < (xsiz+1)
                        A2_shifted(y, x, cnt) = A2(y, x + dx, cnt);
                    else
                        A2_shifted(y,x,cnt) = 0;
                    end
                end
            end
            % Calculate meanXYDiff for the shifted frame.
            if dx < 0
                meanXYDiff((tframe-1), cnt) = mean(mean(abs(...
                A1(:,(1-dx):xsiz,cnt)-A2_shifted(:,(1-dx):xsiz,cnt))));
            elseif dx > 0
                meanXYDiff((tframe-1), cnt) = mean(mean(abs(...
                    A1(:, 1:(xsiz-dx), cnt)-A2_shifted(:, 1:(xsiz-dx), cnt))));
            else
                fprintf('%s\n', 'Error. In dx somewhere.');
            end
            
        end
        cnt = cnt + 1;
    end
    
    % Calculate meanImageDiff
    meanImageDiff((tframe-1)) = mean(meanXYDiff((tframe-1),:));
    
%     % Old Implementation
%     % Calculate image difference ignoring the zeros in A2_shifted:
%     StackDifference = A1-A2_shifted;
%     % Need to iterate through dx for different z heights.
%     for zframe = zini:dz:zfin
%         dx = round(shiftX((tframe-1),zframe));
%         if dx < 0
%             meanXYDiff((tframe-1), zframe) = mean(mean(abs(StackDifference(:, (1-dx):xsiz, zframe))));
%         elseif dx > 0
%             meanXYDiff((tframe-1), zframe) = mean(mean(abs(StackDifference(:, 1:(xsiz-dx), zframe))));
%         else
%             meanXYDiff((tframe-1), zframe) = mean(mean(abs(StackDifference(:,:,zframe))));
%         end
%     end
%     meanImageDiff((tframe-1)) = mean(meanXYDiff((tframe-1),:));
%     
%     % Old implemnetation
%     % ImagDiff(tframe) = mean(mean(mean(abs(double(A1) -double(A2)))));
     
    % Set A1 to the unshifted image for the next calculation.
    A1 = A2;
end

%%
csvwrite(meanImageDiffpath, meanImageDiff);
csvwrite(meanXYDiffpath, meanXYDiff); 

% Plot mean difference between images over time
figure;
x = 1:1:numtframes-1;
t = x/freq;
plot(t,meanImageDiff(x),'b:o');
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