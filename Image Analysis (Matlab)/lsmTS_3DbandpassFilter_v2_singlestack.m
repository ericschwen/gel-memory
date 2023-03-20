%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BandPassFilter for a time series of zstacks in an lsm file.
% Creates one tiff file with all of the zstacks in it ordered by time.

% To run for only one time, set tframe to a single number.

% Can also be used for a single zstack if you set numtframes = 1

%v2: changes to a function. Inputs are the folder and filename (for .lsm file)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function lsmTS_3DbandpassFilter(folderpath, filename)

% Need to run bpass3D for each frame and save the result each time.

filepath = [folderpath, '\', filename];
filebase = filepath(1:length(filepath)-4);
outpath = [filebase, '_static_bpass_3D.tif'];

xsiz = 512;
ysiz = 256;
zsiz = 270;

% initiate image array of the correct size.
imarray = zeros(ysiz, xsiz, zsiz);


zini = 1;
dz = 1;
zfin = 270;

for tframe = 1 %1:1:numtframes %%%%%%% CHANGED HERE %%%%%%%%%%%%
    % Import the pixel numbers from 
    cnt = 1;
    for zframe = zini:dz:zfin
        imarray(:, :, cnt) = imread(filepath, 2*((tframe-1)*zsiz + zframe)-1);
        cnt = cnt +1;
    end
    
    % Parameters: image array, particle radius, noise, image complement
    
    filteredImage = bpass3D_ellipse_v2(imarray, 8, 1, 1);

    % Imcomplement:
    % Changes the image from white particles on black background to black
    % particles on white background.
    % filteredImage = imcomplement(filteredImage);

    % imarray = uint8(imarray); % Needs to be uint8 to print correctly.
    
    % Write bandpass filtered image to file:
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

end

