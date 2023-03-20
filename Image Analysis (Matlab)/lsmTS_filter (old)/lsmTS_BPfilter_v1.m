%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function lsmTS_BPfilter(file_path)
% filteredImage for time series

% file_path = 'C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 1.3V 7-11-16.mdb\timeseries1.lsm';
filebase = file_path(1:length(file_path)-4);
outpath = [filebase, '_bpass.tif'];

xsiz = 512;
ysiz = 256;
zsiz = 100;

imarray3D = zeros(ysiz, xsiz, zsiz);
imarray2D = zeros(ysiz, xsiz);

zini = 1;
dz = 1;
zfin = 100;

% Choose how many time steps to run for
numtframes = 10;

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
        
        % Normalize intensity over columns
        intensityMean = mean(mean(imarray2D));
        columnIntensityMean = mean(imarray2D, 1);
        for x = 1:1:size(imarray2D,2)
            columnIntensityDiff = round(intensityMean - columnIntensityMean(x));
            for y = 1:1:size(imarray2D,1)
                imarray2D(y,x) = imarray2D(y,x) + columnIntensityDiff;
            end
        end
        
%         if (zframe ~= 1) || (tframe ~=1)
%             imwrite(imarray2D, outpath, 'WriteMode', 'append')
%         else
%         imwrite(imarray2D, outpath, 'WriteMode', 'overwrite')
%         end
        
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

