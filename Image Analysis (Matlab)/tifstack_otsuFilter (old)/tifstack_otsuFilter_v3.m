%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tifstack_otsuFilter(folder, params)

%Modification History:
% v2: changed to take .lsm file path as input
% v3: take folder and parameters as inputs
% file_path: time series of ztacks that have been BP filtered

% file_path = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\0.5Hz 0.2V 8-30-16.mdb\ts1.lsm';
bpfilepath = [folder, '\bpass.tif'];
outpath = [folder, '\bpass_otsu.tif'];

% Choose how many time steps to run for
numtframes = uint32(params.stack_size.T);
% Number of slices in zstacks
% xsiz = uint32(params.stack_size.X);
% ysiz = uint32(params.stack_size.Y);
zsiz = uint32(params.stack_size.Z);

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

