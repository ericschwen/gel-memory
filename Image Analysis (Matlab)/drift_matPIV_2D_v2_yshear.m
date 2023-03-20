function drift_matPIV_2D_v2_yshear(params, all_paths, folder)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculates the shifts dx and dy to match two images as best as possible.
% Designed to iterate through entire zstacks taken at regular intervals.
% Saves results in strainpathX and strainpathY files.

% v2: get and save timestamps (DID NOT IMPLEMENT YET)
% yshear: changed window size to work for y-axis shear

%% Import sizes from params structure
numtframes = uint32(params.stack_size.T);
xsiz = uint32(params.stack_size.X);
ysiz = uint32(params.stack_size.Y);
% zsiz = uint32(params.stack_size.Z);

% out_supersize = [numtframes];
% out_supersize = [zsiz numtframes];
% all_paths_shaped = reshape(all_paths, out_supersize);
% Now all_paths_shaped{z,t} gives the path to the specified image 
% Equivalent to all_paths{zframe + (tframe-1) * zsiz}

% % Can manually specify number of tframes shorter for testing
% numtframes = 3;

%% Parse inputs
if ~strcmp(folder(end),'\'), folder = [folder '\']; end

%% Make new output folder
folderParts = strsplit(folder, '\');
parent = strjoin(folderParts(1:end-2), '\');
newfolder = strcat(folderParts(end-1), '_drift_32x512');
mkdir(parent, newfolder{1});

outfolder = [parent, '\', newfolder{1}, '\'];

%% Declare names of files to save to

strainpathX = [outfolder '\v_fieldX.csv'];
strainpathY = [outfolder '\v_fieldY.csv'];

% zini = 1;
% dz = 1;
% zfin = zsiz;
% Size of zstack. Can be different from 
% zfin if there is an excluded part in bottom or top of image.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Declare data arrays

numFrames = (numtframes-1);
% numFrames = zsiz * (numtframes-1);
% total number of iterations using numtframes-1 since I need to compare
% subsequent images (so the number of data points I get is the total number
% of times - 1)

% dx = zeros(numtframes-1, zsiz);
% dy = zeros(numtframes-1, zsiz);
dx = zeros(numFrames, 1);
dy = zeros(numFrames, 1);

%% Algorithm definitions
windows = [32 512; 32 512];
overlap = 0.5;  %Defines overlap of interrogation regions for matpiv.m
method = 'multin';  %Defines evaluation mode for matpiv.m
warning off Images:isrgb:obsoleteFunction;  %Turn off annoying warning
Dt = 1;

%% Drift calculation loop

parfor ff = 1:numFrames
    % ff = zframe + (tframe-1) * zsiz
%     tframe = floor(double(ff-1)/double(zsiz)) + 1;
%     zframe = ff - (tframe-1)*double(zsiz);

    tframe = ff;

    A1 = zeros(ysiz, xsiz); 
    A2 = zeros(ysiz, xsiz);
    
    % Import first image as A1:
    A1(:,:) = imread(all_paths{tframe});
    
    % Import second image as A2:
    A2(:,:) = imread(all_paths{tframe+1});

    %%%%%%%%%% calculate the piv %%%%%%%%%%%%%%%%%
    [x,y,u,v] = matpiv_gpu(A1, A2, windows, Dt, overlap, method);

    % Saves shifts. Rows are consecutive times, columns are
    % consecutive images in zstack. Drift recorded in pixels.
    dx(ff) = mean(u);
    dy(ff) = mean(v);


end 


%% Write results to file
 csvwrite(strainpathX, dx);
 csvwrite(strainpathY, dy);

end