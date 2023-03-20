% Import a .lsm image and save it as a tif
% Author: Eric Schwen
% Date: 9/27/17

folder = 'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\p50';
filename = 'u1.lsm';
filenames = 

% initiate image array of the correct size.
xsiz = 512;
ysiz = 512;
zsiz = 150;

filepath = [folder, '\', filename];
% filepath = [folder, filename];
filebase = filepath(1:length(filepath)-4);

% Make new output folder
writepath = [filebase, '.tif'];

imarray = zeros(ysiz, xsiz, zsiz);

zini = 1;
dz = 1;
zfin = zsiz;

% Import entire tif image
cnt = 1;
for zframe = zini:dz:zfin
    imarray(:, :, cnt) = imread(filepath, 2*zframe-1);
    cnt = cnt +1;
end

% convert to uint8 so matlab will save correctly
imarray = uint8(imarray);

% Write bandpass filtered image to file:
for zframe = zini:dz:zfin
    if zframe ~= 1
        imwrite(imarray(:,:,zframe), writepath, 'WriteMode', 'append', 'Compression', 'none')
    else
        imwrite(imarray(:,:,zframe), writepath, 'WriteMode', 'overwrite', 'Compression', 'none')
    end
end