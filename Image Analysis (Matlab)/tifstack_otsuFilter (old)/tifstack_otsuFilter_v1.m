%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tifstack_otsuFilter(file_path)
% file_path: time series of ztacks that have been BP filtered

% file_path = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\0.5Hz 0.2V 8-30-16.mdb\ts1_bpass.tif';
filebase = file_path(1:length(file_path)-10);
outpath = [filebase, '_otsu.tif'];

zsiz = 270;

zini = 1;
dz = 1;
zfin = 270;

% Choose how many time steps to run for
numtframes = 90;

for tframe = 1:1:numtframes
        
    % Normalize intensity over columns, overall normalization, and band pass filter.
    for zframe = zini:dz:zfin
        
        % Note: unfilteredImage expects a BP filtered image. Just not otsu
        % filtered yet.
        unfilteredImage = imread(file_path, (tframe-1)*zsiz + zframe);
        
        % Apply otsu filter
        filteredImage = thresholdLocally(unfilteredImage);      
        
        if (zframe ~= 1) || (tframe ~=1)
            imwrite(filteredImage, outpath, 'WriteMode', 'append', 'Compression', 'none')
        else
            imwrite(filteredImage, outpath, 'WriteMode', 'overwrite', 'Compression', 'none')
        end

    end
end
end

