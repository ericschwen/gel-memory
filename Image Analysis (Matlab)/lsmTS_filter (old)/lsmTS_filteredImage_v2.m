%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filteredImage for time series

% Need to run bpass3D for each frame and save the result each time.

filepath = 'C:\Users\Eric\Documents\Glass Data\glass sample 1 10-13-16 (Data 10-19-16)\timeseries5.lsm';
filebase = filepath(1:length(filepath)-4);
outpath = [filebase, '_bpass.tif'];

xsiz = 256;
ysiz = 256;
zsiz = 60;

imarray = zeros(ysiz, xsiz, zsiz);


zini = 1;
dz = 1;
zfin = 60;


numtframes = 2;

for tframe = 1:1:numtframes
    cnt = 1;
    for zframe = zini:dz:zfin
        imarray(:, :, cnt) = imread(filepath, 2*((tframe-1)*zsiz + zframe)-1);
        cnt = cnt +1;
    end
    
    % PROBLEM %
    % These zstacks are during shear. I need to use a 2D bandpass filter
    % not a 3D since the z slices don't actually line up.
    
    filteredImage = bpass3D_ellipse_v2(imarray, 8, 2, 1);

    % Changes the image from white particles on black background to black
    % particles on white background.
    filteredImage = imcomplement(filteredImage);

    % imarray = uint8(imarray); % Needs to be uint8 to print correctly.
    for zframe = zini:dz:zfin
        % if-else allows program to overwrite previous files.
        % Use only the if part if you don't want to overwrite
        if (zframe ~= 1) || (tframe ~=1)
            imwrite(filteredImage(:,:,zframe), outpath, 'WriteMode', 'append')
        else
        imwrite(filteredImage(:,:,zframe), outpath, 'WriteMode', 'overwrite')
        end
    end
end

