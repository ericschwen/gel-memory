%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tifstack_otsuFilter(file_path)

%Modification History:
% v2: changed to take .lsm file path as input
% file_path: time series of ztacks that have been BP filtered

% file_path = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\0.5Hz 0.2V 8-30-16.mdb\ts1.lsm';
filebase = file_path(1:length(file_path)-4);
bpfilepath = [filebase, '_bpass.tif'];
outpath = [filebase, '_bpass_otsu.tif'];

% Choose how many time steps to run for
numtframes = 60;
% Number of z slices
zsiz = 275;

zini = 1;
dz = 1;
zfin = zsiz;



for tframe = 1:1:numtframes
        
    % Normalize intensity over columns, overall normalization, and band pass filter.
    for zframe = zini:dz:zfin
        
        % Note: unfilteredImage expects a BP filtered image. Just not otsu
        % filtered yet.
        unfilteredImage = imread(bpfilepath, (tframe-1)*zsiz + zframe);
        
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

