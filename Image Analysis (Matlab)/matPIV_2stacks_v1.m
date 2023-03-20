% MatPIV drift for just two images

% function [dx_mean, dy_mean] = matPIV_2stacks_v1(File_path_1, File_path_2, zsiz)

%%%%%%%%%%%%% set the data path %%%%%%%%%%%%%%%

File_path_1 = 'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\0.6\p100\u1.lsm';
File_path_2 = 'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\0.6\p100\u2.lsm';
zsiz = 50;

file_path_1 = File_path_1;
file_path_2 = File_path_2;
ztot = zsiz;


% Outputs for saving

% % Sets files to save the results to.
% filebase_1 = file_path_1(1:length(file_path_1)-4);
% filebase_2 = file_path_2(1:length(file_path_2)-4);
% 
% % strainpathX = [filebase '_v_fieldX1.csv'];
% % strainpathY = [filebase '_v_fieldY1.csv'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% file sizes
dz = 1; % Step size for zstack
zini = 1; % Initial z position (in zstack)
zfin = ztot;

dx = zeros(ztot, 1);
dy = zeros(ztot, 1);



% Iterate through zstack. Default = ztot.
% Can set a lower value for testing, etc, if you want.
for zframe = zini : dz : zfin
    
    file1 = file_path_1;
    K = imread(file1, 2*(zframe)-1);
    file1 = [file_path_1, '_temp.tif'];
    imwrite(K,file1);

    file2 = file_path_2;
    K = imread(file2, 2*(zframe)-1 );
    file2 = [file_path_2, '_temp.tif'];
    imwrite(K,file2);

    %%%%%%%%%% calculate the piv %%%%%%%%%%%%%%%%%
    % Algorithm definitions
%     windows = [512 32; 512 32];
    windows = [128 32; 128 32];
    overlap = 0.5;  %Defines overlap of interrogation regions for matpiv.m
    method = 'multin';  %Defines evaluation mode for matpiv.m
    warning off Images:isrgb:obsoleteFunction;  %Turn off annoying warning

    Dt = 1;

    [x,y,u,v] = matpiv_gpu(file1, file2, windows, Dt, overlap, method);

    % Saves shifts. Rows are consecutive times, columns are
    % consecutive images in zstack.
%     dx(zframe) = mean(u);
%     dy(zframe) = mean(v);

    delete(file1); 
    delete(file2);

end

dx_mean = mean(dx);
dy_mean = mean(dy);

% 
%  csvwrite(strainpathX, dx);
%  csvwrite(strainpathY, dy);

% end

