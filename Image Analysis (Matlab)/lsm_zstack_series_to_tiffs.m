%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Converts a lsm file to a bunch of tiffs.
% Makes a new folder for each z height for use with particle tracking.

function lsm_zstack_series_to_tiffs(folderpath,filename)

% folderpath = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.1V 8-2-16.mdb';
% filename = 'Timeseries1.lsm';

filepath = [folderpath, '\', filename];
% filebase = filepath(1:length(filepath)-4);
filename_noext = filename(1:length(filename)-4);
% outpath = [filebase, '.tif'];

% Pull number of images from the file data.
% ImageInfo=imfinfo(filepath);
% numImgs=length(ImageInfo);

numtframes = 50;
zsiz = 270;

zini = 1;
zfin = zsiz;
dz = 1;

% Maybe add if statement to see if directory already exists.
mkdir(folderpath, filename_noext);


% Iterate through z frames in images. Go by 2 for lsm images.
for zframe = zini:dz:zfin
    for tframe = 1:1:numtframes
        
        A = imread(filepath, 2 * ((tframe - 1)*zsiz + zframe) -1);     
        
        outpath = [folderpath, '\', filename_noext, '\', 'z', num2str(zframe), '\', 't', num2str(tframe),'.tif'];

        if tframe == 1
            mkdir([folderpath, '\', filename_noext], ['z', num2str(zframe)]);
            imwrite(A, outpath, 'WriteMode', 'overwrite')
        else
            imwrite(A, outpath, 'WriteMode', 'overwrite')
        end
    end
end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Quick and easy lsm to tiff for single image
% file1 = [file_path];
% K = imread(file1, 2*(ztot*(time-1)+zframe)-1);
% file1 = [file_path, num2str(time), '_temp.tif'];
% imwrite(K,file1);