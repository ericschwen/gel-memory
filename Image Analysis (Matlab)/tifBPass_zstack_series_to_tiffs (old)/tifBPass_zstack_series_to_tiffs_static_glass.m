%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Converts a lsm file to a bunch of tiffs.
% Makes a new folder for each z height for use with particle tracking.

function tifBPass_zstack_series_to_tiffs_static(folderpath,filename)

% folderpath = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\0.5Hz 0.3V 9-12-16.mdb';
% filename = 'ts4_bpass_normalized.tif';

filepath = [folderpath, '\', filename];
% filebase = filepath(1:length(filepath)-4);
filename_noext = filename(1:length(filename)-4);
% outpath = [filebase, '.tif'];

% Pull number of images from the file data.
% ImageInfo=imfinfo(filepath);
% numImgs=length(ImageInfo);

% Select which tframe to save as a stack
tframe = 2;

zsiz = 60;

zini = 1;
zfin = zsiz;
dz = 1;

% Maybe add if statement to see if directory already exists.
% mkdir(folderpath, filename_noext);
mkdir([folderpath, '\', filename_noext '_static']);


% Iterate through z frames in images. Go by 2 for lsm images. (By 1 for
% tiffs)
for zframe = zini:dz:zfin
    
    A = imread(filepath, (tframe - 1)*zsiz + zframe);     

    outpath = [folderpath, '\', filename_noext, '_static', '\', 'z', num2str(zframe), '.tif'];

    if zframe == 1
        imwrite(A, outpath, 'WriteMode', 'overwrite')
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