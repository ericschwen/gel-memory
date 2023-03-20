%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filteredImage for time series

% Need to run bpass3D for each frame and save the result each time.

filepath = 'C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 1.3V 7-11-16.mdb\timeseries1.lsm';
filebase = filepath(1:length(filepath)-4);
outpath = [filebase, '_bpass.tif'];

xsiz = 512;
ysiz = 256;
zsiz = 100;

imarray3D = zeros(ysiz, xsiz, zsiz);
imarray2D = zeros(ysiz, xsiz);

zini = 1;
dz = 1;
zfin = 100;


numtframes = 5;

for tframe = 1:1:numtframes
    cnt = 1;
    for zframe = zini:dz:zfin
        imarray3D(:, :, cnt) = imread(filepath, 2*((tframe-1)*zsiz + zframe)-1);
        cnt = cnt +1;
    end
    
    % imarray = uint8(imarray); % Needs to be uint8 to print correctly.
    for zframe = zini:dz:zfin
        % if-else allows program to overwrite previous files.
        % Use only the if part if you don't want to overwrite
        
        imarray2D(:,:) = imarray3D(:,:,zframe);
        
        filteredImage = bpass2D(imarray2D, 8, 2, 1);

        % Changes the image from white particles on black background to black
        % particles on white background.
%         filteredImage = imcomplement(filteredImage);
        
        
        if (zframe ~= 1) || (tframe ~=1)
            imwrite(filteredImage, outpath, 'WriteMode', 'append')
        else
        imwrite(filteredImage, outpath, 'WriteMode', 'overwrite')
        end
    end
end

