%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filteredImage

filepath = 'C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 1.4V 7-11-16.mdb\zstack1.lsm';
filebase = filepath(1:length(filepath)-4);
outpath = [filebase, '_bpass.tif'];

zsiz = 100;

imarray = zeros(512,512, zsiz);

cnt = 1;
for i = 1:1:zsiz
    imarray(:, :, cnt) = imread(filepath, 2*i -1);
    cnt = cnt +1;
end

filteredImage = bpass3D_ellipse_v2(imarray, 8, 2, 1);

% Changes the image from white particles on black background to black
% particles on white background.
filteredImage = imcomplement(filteredImage);

% imarray = uint8(imarray); % Needs to be uint8 to print correctly.
for z = 1:1:zsiz
    A = filteredImage(:,:,z);
    % if-else allows program to overwrite previous files.
    % Use only the if part if you don't want to overwrite
    if z ~= 1
        imwrite(A, outpath, 'WriteMode', 'append')
    else
    imwrite(A, outpath, 'WriteMode', 'overwrite')
    end
end

