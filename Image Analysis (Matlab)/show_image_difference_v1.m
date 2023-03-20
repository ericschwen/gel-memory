%%%%%%%%%%%%%%%%%%%%
% show_image_difference
%
% Take two subsequent images. BP filter, otsu filter, and calculate image
% difference. Show image difference for making figures. Expects tif images,
% but could probably work for lsm as well.
%
% Author: Eric Schwen
% Date: 12/14/18

folder_path = 'C:\Eric\Xerox\Python\peri\1-6-18 data\256x256x50\';
image_path_1 = [folder_path, 'u0.tif'];
image_path_2 = [folder_path, 'u1.tif'];

% read images. Number selects which zframe to read
zframe = 15;
image1 = imread(image_path_1, zframe);
image2 = imread(image_path_2, zframe);

% band pass filter
bp_image_1 = bpass2D(image1,8,2,1);
bp_image_2 = bpass2D(image2,8,2,1);

% otsu filter
otsu_image_1 = thresholdLocally(bp_image_1);
otsu_image_2 = thresholdLocally(bp_image_2);

%image difference
difference_image = otsu_image_2 - otsu_image_1;
% make positive and multiply by 255 (binary image to 0-255 scale)
difference_image = abs(difference_image);
difference_image = difference_image * 255;

% make an image split along diagonal
diag = image1;
dim = length(diag);

% for i = 1:1:dim
%     diag(i, dim-i+1:dim) = difference_image(i, dim-i+1:dim);
% end
% imshow(diag)

% reverse diagonal
for i = 1:1:dim
    diag(i, i:dim) = difference_image(i, i:dim);
end
imshow(diag)


% split into 3 diagonals
% only written for 512 * 512
trip = image1;
full = 512;
% c1 = 170;
% c2 = 95;

for i = 1:1:full
    if i < 340
        trip(i, 340-i:full) = bp_image_1(i, 340-i:full);
    else
        trip(i, 1:full) = bp_image_1(i, 1:full);
    end
    
    if i > 172
        trip(i, full-i+172+1:full) = difference_image(i, full-i+172+1:full);
    end
end

figure; imshow(trip)

% write image difference image to file
write_path = strcat(folder_path, 'difference_z', char(string(zframe)), '.tif');
imwrite(difference_image, write_path,'WriteMode', 'overwrite', 'Compression', 'none');

% % % import peri model image
% model_path = 'C:/Eric/Xerox/Python/peri/1-6-18 data/128x128x50 p200/u0-finished-model.csv';
% peri_image = csvread(model_path);
% 
% % figure; imshow(peri_image)


% import peri image saved by scipy.misc.toimage
% same result as importing the csv image, but rounded to uint8
data_path = [folder_path, 'u0-finished-data.tif'];
data_image = imread(data_path);

model_path = [folder_path, 'u0-finished-model.tif'];
model_image = imread(model_path);

% figure; imshow(data_image);
% figure; imshow(model_image);

% % name smaller segment of difference image to match size of model image
% sdiff_image = model_image;
% for i =1:1:length(sdiff_image)
%     sdiff_image(i,:) = difference_image(i,1:length(sdiff_image));
% end
% 
% imshow(sdiff_image)

% % 128x128 VERSION
% % make triple image using data, model, difference
% strip = data_image;
% sfull = length(model_image);
% for i = 1:1:sfull
%         if i < 90
%         strip(i, 90-i:sfull) = model_image(i, 90-i:sfull);
%     else
%         strip(i, 1:sfull) = model_image(i, 1:sfull);
%     end
%     
%     if i > 38
%         strip(i, sfull-i+38+1:sfull) = difference_image(i, sfull-i+38+1:sfull);
%     end
% end
% 
% figure; imshow(strip);
% 
% write_path = [folder_path, 'triple_128.tif'];
% imwrite(strip, write_path,'WriteMode', 'overwrite', 'Compression', 'none');

% 256x256 VERSION triple image using data, model, difference
strip = data_image;
sfull = length(model_image);
for i = 1:1:sfull
        if i < 192
        strip(i, 192-i:sfull) = model_image(i, 192-i:sfull);
    else
        strip(i, 1:sfull) = model_image(i, 1:sfull);
    end
    
    if i > 64
        strip(i, sfull-i+64+1:sfull) = difference_image(i, sfull-i+64+1:sfull);
    end
end

figure; imshow(strip);

write_path = [folder_path, 'triple_256.tif'];
imwrite(strip, write_path,'WriteMode', 'overwrite', 'Compression', 'none');

