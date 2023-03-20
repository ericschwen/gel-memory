function drift_matPIV(params, all_paths, folder)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculates the shifts dx and dy to match two images as best as possible.
% Designed to iterate through entire zstacks taken at regular intervals.
% Saves results in strainpathX and strainpathY files.

%% Import sizes from params structure
numtframes = uint32(params.stack_size.T);
xsiz = uint32(params.stack_size.X);
ysiz = uint32(params.stack_size.Y);
zsiz = uint32(params.stack_size.Z);

%% Parse inputs
if ~strcmp(folder(end),'\'), folder = [folder '\']; end

%% Make new output folder
folderParts = strsplit(folder, '\');
parent = strjoin(folderParts(1:end-2), '\');
newfolder = strcat(folderParts(end-1), '_Drift');
mkdir(parent, newfolder{1});

outfolder = [parent, '\', newfolder{1}, '\'];

%% Declare names of files to save to

strainpathX = [outfolder '\v_fieldX.csv'];
strainpathY = [outfolder '\v_fieldY.csv'];

ztot = 50; % Size of zstack
dz = 1; % Step size for zstack
zini = 1; % Initial z position (in zstack)
zfin = 50;

% Choose how many frames to calculate for
numtframes = 3;

%%%%%%%%%%%%% set the data path %%%%%%%%%%%%%%%
% file_path = ['C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 0.1V 7-12-16.mdb\timeseries1.lsm'];
% file_path = ['G:\BackUp_Colloids_Data\2016_02_25\Gap_Uniaxial.mdb\Gap23_bottom6.lsm'];

%% Sets files to save the results to.
filebase = file_path(1:length(file_path)-4);
strainpathX = [filebase '_v_fieldX1.csv'];
strainpathY = [filebase '_v_fieldY1.csv'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Get image information
InfoImage = imfinfo(file_path);
N = length(InfoImage)/ztot;
dx = zeros(N/2-1, ztot);
dy = zeros(N/2-1, ztot);


%%
for zframe = zini : dz : zfin
    
    % Iterate through different times. Default = N/2-1
    % Can set a lower value for quicker test runs, etc.
    for time = 1:1:(numtframes-1)

        file1 = [file_path];
        K1 = imread(file1, 2*(ztot*(time-1)+zframe)-1);
%         file1 = [file_path, num2str(time), '_temp.tif'];
%         imwrite(K1,file1);

        file2 = [file_path];
        K2 = imread(file2, 2*(ztot*(time)+zframe)-1 );
%         file2 = [file_path, num2str(time+1), '_temp.tif'];
%                        
%             file2 = [file_path, num2str(time+1), '.tif'];
%             K = imread(file2,zframe);
%             file2 = [file_path, num2str(time+1), '_temp_2.tif'];
%         imwrite(K2,file2);

        %%%%%%%%%% calculate the piv %%%%%%%%%%%%%%%%%
        % Algorithm definitions
        windows = [512 32; 512 32];
        overlap = 0.5;  %Defines overlap of interrogation regions for matpiv.m
        method = 'multin';  %Defines evaluation mode for matpiv.m
        warning off Images:isrgb:obsoleteFunction;  %Turn off annoying warning

        Dt = 1;

        [x,y,u,v] = matpiv_gpu(K1, K2, windows, Dt, overlap, method);

        % Saves shifts. Rows are consecutive times, columns are
        % consecutive images in zstack.
        dx(time, zframe) = mean(u);
        dy(time, zframe) = mean(v);

    end

end 

%% Write results to file
 csvwrite(strainpathX, dx);
 csvwrite(strainpathY, dy);

end