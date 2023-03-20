%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tifstack_otsuFilter_v5(Folder, Subfolder, Stack)

%% Modification History:
% v2: changed to take .lsm file path as input
% v3: take folder and parameters as inputs
% file_path: time series of ztacks that have been BP filtered
% v4: change to work with all_files input and parallelization
% v5: modified to take input from a folder full of 3D bp filtered images. A bit of a step
% back from v4 rather than an improvement. 7-10-17
% v5_mod1: gets rid of / before stack in file path

%%
% folder = 'C:\Eric\Xerox Data\30um gap runs\6-28-17 0.3333Hz\1.4V run2\';
% subfolder = 'zstacks_p100';
% stack = 'u1';

folder = Folder;
subfolder = Subfolder;
stack = Stack;

path_base = [folder, subfolder, '', stack, '_bpass3D', '\'];

otsu_folder = [folder, subfolder, '', stack, '_otsu2D'];
mkdir(otsu_folder)
out_folder = [otsu_folder, '\'];


% Number of slices in zstacks
xsiz = 512; % could get these from params produced by lsm_parallel_import
ysiz = 512;
zsiz = 50;

% delare paths cell array
paths = cell(zsiz, 1);

for z = 1:zsiz
    paths{z} = [path_base, 'z', num2str(z), '.tif'];
end

parfor ff = 1:zsiz
    % import bp image
    bp_image = imread(paths{ff});
    
    % run 2D otsu filter
    otsuImage = thresholdLocally(bp_image);
    
    % save to file
    imwrite(otsuImage, strcat(out_folder, 'z', num2str(ff), '.tif'), 'WriteMode', 'overwrite', 'Compression', 'none')
    
end

end