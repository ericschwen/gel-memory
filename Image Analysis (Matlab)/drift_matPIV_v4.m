function drift_matPIV(params, all_paths, folder)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculates the shifts dx and dy to match two images as best as possible.
% Designed to iterate through entire zstacks taken at regular intervals.
% Saves results in strainpathX and strainpathY files.

% v2: take inputs from parameters and paths read from xml file by
% lsm_parallel_import_v3.
% v3: parallel processing preparation
% v4: implement parallel processing

%% Import sizes from params structure
numtframes = uint32(params.stack_size.T);
xsiz = uint32(params.stack_size.X);
ysiz = uint32(params.stack_size.Y);
zsiz = uint32(params.stack_size.Z);

out_supersize = [zsiz numtframes];
all_paths_shaped = reshape(all_paths, out_supersize);
% Now all_paths_shaped{z,t} gives the path to the specified image 
% Equivalent to all_paths{zframe + (tframe-1) * zsiz}

% % Can manually specify number of tframes shorter for testing
% numtframes = 3;

%% Parse inputs
if ~strcmp(folder(end),'\'), folder = [folder '\']; end

%% Make new output folder
folderParts = strsplit(folder, '\');
parent = strjoin(folderParts(1:end-2), '\');
newfolder = strcat(folderParts(end-1), '_drift');
mkdir(parent, newfolder{1});

outfolder = [parent, '\', newfolder{1}, '\'];

%% Declare names of files to save to

strainpathX = [outfolder '\v_fieldX.csv'];
strainpathY = [outfolder '\v_fieldY.csv'];

zini = 1;
dz = 1;
zfin = zsiz;
% Size of zstack. Can be different from 
% zfin if there is an excluded part in bottom or top of image.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Declare data arrays

numFrames = zsiz * (numtframes-1);
% total number of iterations using numtframes-1 since I need to compare
% subsequent images (so the number of data points I get is the total number
% of times - 1)

% dx = zeros(numtframes-1, zsiz);
% dy = zeros(numtframes-1, zsiz);
dx = zeros(numFrames, 1);
dy = zeros(numFrames, 1);

%% Algorithm definitions
windows = [512 32; 512 32];
overlap = 0.5;  %Defines overlap of interrogation regions for matpiv.m
method = 'multin';  %Defines evaluation mode for matpiv.m
warning off Images:isrgb:obsoleteFunction;  %Turn off annoying warning
Dt = 1;

%% Drift calculation loop

parfor ff = 1:numFrames
    % ff = zframe + (tframe-1) * zsiz
    tframe = floor(double(ff-1)/double(zsiz)) + 1;
    zframe = ff - (tframe-1)*double(zsiz);

    A1 = zeros(ysiz, xsiz); 
    A2 = zeros(ysiz, xsiz);
    
    % Import first image as A1:
    A1(:,:) = imread(all_paths_shaped{zframe, tframe});
    
    % Import second image as A2:
    A2(:,:) = imread(all_paths_shaped{zframe, tframe+1});

    %%%%%%%%%% calculate the piv %%%%%%%%%%%%%%%%%
    [x,y,u,v] = matpiv_gpu(A1, A2, windows, Dt, overlap, method);

    % Saves shifts. Rows are consecutive times, columns are
    % consecutive images in zstack. Drift recorded in pixels.
    dx(ff) = mean(u);
    dy(ff) = mean(v);


end 

%% Reshape dx and dy arrays
% Use to call dx_shaped(tframe, zframe)
out_supersize = [zsiz (numtframes-1)];
dx_shaped = reshape(dx, out_supersize);
dx_shaped = dx_shaped.';
dy_shaped = reshape(dy, out_supersize);
dy_shaped = dy_shaped.';

%% Write results to file
 csvwrite(strainpathX, dx_shaped);
 csvwrite(strainpathY, dy_shaped);

end