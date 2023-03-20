%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Converts a lsm file to a tif.
% Makes a stack of images for zstacks. Should just make a bigger stack for
% time series (later times stacked on top).

% Occasionally gets an error where it doesn't have permission? Repeat and
% it should fix itself.

function lsmtiff

% z_size = 50; % Not needed
% bigpath = ['C:\Data\shear_cessation_650nm.mdb\Cessation_dz015_N200_dt0158s__'];
bigpath = ['C:\Users\Eric\Documents\Xerox Data\0.5Hz_1Amp_5-27-16.mdb\'];

% Add multiple parts to pathlist in order to convert multiple images at
% once
pathlist = ...
{   'zstack_1' ...
%     '002Hz_2' ...
%     '005Hz_1' ...
};
for pcnt = 1:1:length(pathlist)
filepath = [bigpath, char(pathlist(pcnt)) '.lsm'];
outpath = [bigpath, char(pathlist(pcnt)) '.tif'];
InfoImage=imfinfo(filepath);
numImgs=length(InfoImage);
% numImages = 7000;
for i = 1:2:length(InfoImage)
%     for j = 1:1:z_size  % Don't need this. Length should already stack
%     with z
        A = imread(filepath, i);     
        
        % if-else allows program to overwrite previous files.
        % Use only the if part if you don't want to overwrite
        if i ~= 1
            imwrite(A, outpath, 'WriteMode', 'append')
        else
        imwrite(A, outpath, 'WriteMode', 'overwrite')
        end
%     end
end
end
end


%%%%%%%%%%%%%%%%%%
% if i ~= 1
%     imwrite(A, outpath, 'WriteMode', 'append')
% else
%     imwrite(A, outpath, 'WriteMode', 'overwrite')
% end

% Writes to file. Won't overwrite so delete the prev. version first
% imwrite(A, outpath, 'WriteMode', 'append');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Quick and easy lsm to tiff for single image
file1 = [file_path];
K = imread(file1, 2*(ztot*(time-1)+zframe)-1);
file1 = [file_path, num2str(time), '_temp.tif'];
imwrite(K,file1);