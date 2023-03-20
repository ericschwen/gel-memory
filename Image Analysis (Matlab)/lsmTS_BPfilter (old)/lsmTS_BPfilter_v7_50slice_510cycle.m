%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modification History:
% v2: change size to 270 frames to work with bigger zstacks.
% v3: remove (comment out) normalization over columns. doesn't do what i
% want it to do.
% v4: divide out background illumination.
% v5: overall normalization of image
% v6: remove the normalization from v5. Not actually correct. Need to
% normalize by number of particles too.
% v7: remove dividing out background illumination for now. Not sure it is
% working as intended and I don't think it is necessarily necessary.

function lsmTS_BPfilter(file_path)
% filteredImage for time series

% Choose how many time steps to run for
numtframes = 510;
% Number of slices in zstacks
zsiz = 50;

% file_path = 'C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 1.3V 7-11-16.mdb\timeseries1.lsm';
filebase = file_path(1:length(file_path)-4);
outpath = [filebase, '_bpass.tif'];

xsiz = 512;
ysiz = 256;


zini = 1;
dz = 1;
zfin = zsiz;

imarray3D = zeros(ysiz, xsiz, zsiz);
imarray2D = zeros(ysiz, xsiz);
% gwarray2D = zeros(ysiz,xsiz);
% 
% % Import glycerol-water background picture (to divide out)
% gwfile_path = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\Glycerol-Water 8-10-16.mdb\preshear_hyperfine_3.tif';
% gwarray2D(:,:) = imread(gwfile_path, 37);
% % gwarray2D = uint8(gwarray2D);
% % imshow(gwarray2D(:,:));



for tframe = 1:1:numtframes
    
    % Import the full zstack as a 3D image array
    cnt = 1;
    for zframe = zini:dz:zfin
        imarray3D(:, :, cnt) = imread(file_path, 2*((tframe-1)*zsiz + zframe)-1);
        cnt = cnt +1;
    end
    
    % Normalize intensity over columns, overall normalization, and band pass filter.
    for zframe = zini:dz:zfin
        imarray2D(:,:) = imarray3D(:,:,zframe);
        
%         % Divide image by background glycerol-water image to remove
%         % background illumination differences. 
%         imarray2D_norm1 = imarray2D./gwarray2D * mean(mean(gwarray2D));
        
%         % Overall normalization of image. Make mean 128.
%         imageMean = mean(mean(imarray2D_norm1));
%         imarray2D_norm2 = uint8(imarray2D_norm1 + (128-imageMean));

        % Need to normalize correctly. Can't just be mean of pixels for the 
        % entire image because I want to account for the number of 
        % particles. 
        
        % Apply bandpass filter
        filteredImage = bpass2D(imarray2D,8,2,1);      
        
        % Can get image complement for dark particles on light background
%         filteredImage = imcomplement(filteredImage);
        
        if (zframe ~= 1) || (tframe ~=1)
            imwrite(filteredImage, outpath, 'WriteMode', 'append')
        else
            imwrite(filteredImage, outpath, 'WriteMode', 'overwrite')
        end

    end
end

