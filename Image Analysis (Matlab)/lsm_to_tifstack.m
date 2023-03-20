%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modification History:

function lsm_to_tifstack(file_path)
% filteredImage for time series

% file_path = 'C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 1.3V 7-11-16.mdb\timeseries1.lsm';
filebase = file_path(1:length(file_path)-4);
outpath = [filebase, '.tif'];

xsiz = 512;
ysiz = 256;
zsiz = 270;

zini = 1;
dz = 1;
zfin = 270;

imarray3D = zeros(ysiz, xsiz, zsiz);
imarray2D = zeros(ysiz, xsiz);
gwarray2D = zeros(ysiz,xsiz);

% Choose how many time steps to run for
numtframes = 3;

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
        
        imarray2D = uint8(imarray2D);
        
        if (zframe ~= 1) || (tframe ~=1)
            imwrite(imarray2D, outpath, 'WriteMode', 'append')
        else
            imwrite(imarray2D, outpath, 'WriteMode', 'overwrite')
        end

    end
end

