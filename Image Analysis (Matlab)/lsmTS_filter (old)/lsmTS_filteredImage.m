%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filteredImage for time series

% Need to run bpass3D for each frame and save the result each time.

filepath = 'C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 1.4V 7-11-16.mdb\timeseries1.lsm';
filebase = filepath(1:length(filepath)-4);
outpath = [filebase, '_bpass.tif'];

xsiz = 512;
ysiz = 256;
zsiz = 100;

imarray = zeros(ysiz, xsiz, zsiz);
A = zeros(ysiz, xsiz);

zini = 1;
dz = 1;
zfin = 100;


numtframes = 2;

for tframe = 1:1:numtframes
    cnt = 1;
    for zframe = zini:dz:zfin
        imarray(:, :, cnt) = imread(filepath, 2*((tframe-1)*zsiz + zframe)-1);
        cnt = cnt +1;
    end

    filteredImage = bpass3D_ellipse_v2(imarray, 8, 2, 1);

    % Changes the image from white particles on black background to black
    % particles on white background.
    filteredImage = imcomplement(filteredImage);

    % imarray = uint8(imarray); % Needs to be uint8 to print correctly.
    for zframe = zini:dz:zfin
        A(:,:) = filteredImage(:,:,zframe);
        A = uint8(A);
        % if-else allows program to overwrite previous files.
        % Use only the if part if you don't want to overwrite
        if (zframe ~= 1) || (tframe ~=1)
            imwrite(A, outpath, 'WriteMode', 'append')
        else
        imwrite(A, outpath, 'WriteMode', 'overwrite')
        end
    end
end

