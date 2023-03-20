%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Converts a lsm file to a tif.
% Makes a stack of images for zstacks. Should just make a bigger stack for
% time series (later times stacked on top).

% Occasionally gets an error where it doesn't have permission? Repeat and
% it should fix itself.

function lsmtiff(filepath)


% filepath = 'C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 1.4V 7-11-16.mdb\zstack1.lsm';
filebase = filepath(1:length(filepath)-4);
outpath = [filebase, '.tif'];

% Pull number of images from the file data.
ImageInfo=imfinfo(filepath);
% numImgs=length(ImageInfo);

% Iterate through z frames in images. Go by 2 for lsm images.
for z = 1:2:length(ImageInfo)
    A = imread(filepath, z);     

    % if-else allows program to overwrite previous files.
    % Use only the if part if you don't want to overwrite
    if z ~= 1
        imwrite(A, outpath, 'WriteMode', 'append')
    else
    imwrite(A, outpath, 'WriteMode', 'overwrite')
    end
end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Quick and easy lsm to tiff for single image
% file1 = [file_path];
% K = imread(file1, 2*(ztot*(time-1)+zframe)-1);
% file1 = [file_path, num2str(time), '_temp.tif'];
% imwrite(K,file1);