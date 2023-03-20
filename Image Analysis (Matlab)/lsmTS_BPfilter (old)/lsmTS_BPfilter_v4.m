%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modification History:
% v2: change size to 270 frames to work with bigger zstacks.
% v3: remove (comment out) normalization over columns. doesn't do what i
% want it to do.
% v4: divide out background illumination.

function lsmTS_BPfilter(file_path)
% filteredImage for time series

% file_path = 'C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 1.3V 7-11-16.mdb\timeseries1.lsm';
filebase = file_path(1:length(file_path)-4);
outpath = [filebase, '_bpass_test.tif'];

xsiz = 512;
ysiz = 256;
zsiz = 270;

zini = 1;
dz = 1;
zfin = 270;

imarray3D = zeros(ysiz, xsiz, zsiz);
imarray2D = zeros(ysiz, xsiz);
gwarray2D = zeros(ysiz,xsiz);

% Import glycerol-water background picture (to divide out)
gwfile_path = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\Glycerol-Water 8-10-16.mdb\preshear_hyperfine_3.tif';
gwarray2D(:,:) = imread(gwfile_path, 37);
% gwarray2D = uint8(gwarray2D);
% imshow(gwarray2D(:,:));

% Choose how many time steps to run for
numtframes = 5;

for tframe = 1:1:numtframes
    
    % Import the full zstack as a 3D image array
    cnt = 1;
    for zframe = zini:dz:zfin
        imarray3D(:, :, cnt) = imread(file_path, 2*((tframe-1)*zsiz + zframe)-1);
        cnt = cnt +1;
    end
    
    % Normalize intensity over columns and band pass filter.
    for zframe = zini:dz:zfin
        imarray2D(:,:) = imarray3D(:,:,zframe);
        
        % Divide image by background glycerol-water image to remove
        % background illumination differences. 
        imarray2D_norm = imarray2D./gwarray2D * mean(mean(gwarray2D));
        
        % Apply bandpass filter
        filteredImage = bpass2D(imarray2D_norm,8,2,1);

% %         % Check to get column normalization without bpass
%         filteredImage = uint8(imarray2D);
%         filteredImage(:,:) = adapthisteq(filteredImage(:,:));
        
        
        % Can get image complement for dark particles on light background
%         filteredImage = imcomplement(filteredImage);
        
        if (zframe ~= 1) || (tframe ~=1)
            imwrite(filteredImage, outpath, 'WriteMode', 'append')
        else
            imwrite(filteredImage, outpath, 'WriteMode', 'overwrite')
        end

    end
end

