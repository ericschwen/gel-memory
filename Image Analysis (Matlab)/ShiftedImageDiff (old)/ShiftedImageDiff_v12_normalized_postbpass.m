function ShiftedImageDiff(file_path)

% Takes .lsm file as input.

% Calculates mean difference between pixels in consecutive images (zstacks)
% while subtracting off any shift from overall drift in the image due to
% improper syncing of piezo and confocal.

% Also calculates the mean difference between xy images for each z height
% so comparisons for different heights can be obtained.

% Modification History:
% v8: Changed tframe to tframe-1 to fix off by one issue (only 49
% differences in 50 frames)
% v9: Removed old StackDifference implementation and moved it into the
% zframe loop for calculating A2_shifted. 
% v10: Started using bpass.tif instead of lsm file.

%%%%%%%% Drift subtracted part %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Difference between consecutive images with drift subtracted.
% Assumes shear_band_calculation has already been run. Could also implement
% it here instead.

% Example file_path:
% file_path = ['C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 1.2V 7-10-16.mdb\timeseries1.lsm'];
% Example from external drive:
% file_path = ['F:\Xerox Data\2Hz Data Runs\2Hz 1.2V 7-10-16.mdb\timeseries1.lsm'];

% Import strain data generated by shear_band_calculation:
filebase = file_path(1:length(file_path)-4);
strainpathX = [filebase '_v_fieldX1.csv'];
% Ignore strainpathY. Negligible shift in 
% strainpathY = [file_path '_v_fieldY1.csv'];

% Save image difference to file
meanImageDiffpath = [filebase '_meanImageDiff_normalized_postbpass.csv'];
meanXYDiffpath = [filebase '_meanXYDiff_normalized_postbpass.csv'];


bpfilepath = [filebase '_bpass_normalized.tif'];

shiftX= xlsread(strainpathX);
% shiftX(time, z-height)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Choose how many time steps to calculate image difference for:
numtframes = 23;


zini = 1;
dz = 1;
zfin = 270;
% Size of zstack. Can be different from 
% zfin if there is an excluded part in bottom or top of image.
zsiz = 270;

freq = 1; % Imaging frequency

xsiz = 512;
ysiz = 256;
% row, column, height = y, x, z
A1 = zeros(ysiz, xsiz, zfin); 
A2 = zeros(ysiz, xsiz, zfin);
A2_shifted = zeros(ysiz, xsiz, zfin);

% Set A1 to the initial zstack:
cnt = 1;
for zframe = zini:dz:zfin
    A1(:, :, cnt) = imread(bpfilepath, zframe); 
    % 'Normalize' by setting mean to 128.
    A1(:,:,cnt) = uint8(A1(:,:,cnt) + (128 - mean(mean(A1(:,:,cnt)))));
    cnt = cnt +1;
end

meanXYDiff = zeros(numtframes-1,(zfin+1-zini));
meanImageDiff = zeros(numtframes-1,1);

% Iterate through times. For each time: import the unshifted image, create
% teh shifted image, and calculate the image shift.
% Start with tframe 2 siince the first frame is already in A1 above
for tframe = 2:1:numtframes
    
    % Import unshifted image:
    cnt = 1;
    for zframe = zini:dz:zfin
        A2(:, :, cnt) = imread(bpfilepath, (tframe-1)*zsiz + zframe);
        % 'Normalize' by setting mean to 128.
        A2(:,:,cnt) = uint8(A2(:,:,cnt) + (128 - mean(mean(A2(:,:,cnt))))); % Need uint8 to make integer and limit to 256;
        cnt = cnt + 1;
    end
        
    % Generate shifted image: (Could make more efficient by moving if
    % statement)
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

% Attempted method. Cant use imread for unmatched matrix sizes.
%          A2(y,x,cnt) = imread(file_path,...
%              2*(tframe*zsiz + zframe)-1,...
%              {[1,256],[1,512]})
