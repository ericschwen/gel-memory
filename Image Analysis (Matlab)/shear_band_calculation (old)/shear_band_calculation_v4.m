function shear_band_calculation(file_path)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculates the shifts dx and dy to match two images as best as possible.
% Designed to iterate through entire zstacks taken at regular intervals.
% Saves results in strainpathX and strainpathY files.

ztot = 100; % Size of zstack
dz = 1; % Step size for zstack
zini = 1; % Initial z position (in zstack)

% Choose how many frames to calculate for
numtframes = 10;

%%%%%%%%%%%%% set the data path %%%%%%%%%%%%%%%
% file_path = ['C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 0.1V 7-12-16.mdb\timeseries1.lsm'];
% file_path = ['G:\BackUp_Colloids_Data\2016_02_25\Gap_Uniaxial.mdb\Gap23_bottom6.lsm'];
% Meera's data 1Hz 0.023 Strain
% file_path = ['C:\Users\Eric\Documents\Xerox Data\Meeras Data\2016_04_27\0.05V_1Hz.mdb\Timeseries_Initial.lsm'];

% Example from external drive:
% file_path = ['F:\Xerox Data\2Hz Data Runs\2Hz 1.2V 7-10-16.mdb\timeseries1.lsm'];

% Sets files to save the results to.
filebase = file_path(1:length(file_path)-4);
strainpathX = [filebase '_v_fieldX1.csv'];
strainpathY = [filebase '_v_fieldY1.csv'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
InfoImage = imfinfo(file_path);
N = length(InfoImage)/ztot;
dx = zeros(N/2-1, ztot);
dy = zeros(N/2-1, ztot);



% Iterate through zstack. Default = ztot.
% Can set a lower value for testing, etc, if you want.
for zframe = zini : dz : ztot
    
    % Iterate through different times. Default = N/2-1
    % Can set a lower value for quicker test runs, etc.
    for time = 1:1: numtframes %N/2-1 for all

        file1 = [file_path];
        K = imread(file1, 2*(ztot*(time-1)+zframe)-1);
        file1 = [file_path, num2str(time), '_temp.tif'];
        imwrite(K,file1);

        file2 = [file_path];
        K = imread(file2, 2*(ztot*(time)+zframe)-1 );
        file2 = [file_path, num2str(time+1), '_temp.tif'];
%                        
%             file2 = [file_path, num2str(time+1), '.tif'];
%             K = imread(file2,zframe);
%             file2 = [file_path, num2str(time+1), '_temp_2.tif'];
        imwrite(K,file2);

        %%%%%%%%%% calculate the piv %%%%%%%%%%%%%%%%%
        % Algorithm definitions
        windows = [512 32; 512 32];
        overlap = 0.5;  %Defines overlap of interrogation regions for matpiv.m
        method = 'multin';  %Defines evaluation mode for matpiv.m
        warning off Images:isrgb:obsoleteFunction;  %Turn off annoying warning

        Dt = 1;

        [x,y,u,v] = matpiv_gpu(file1, file2, windows, Dt, overlap, method);

        % Saves shifts. Rows are consecutive times, columns are
        % consecutive images in zstack.
        dx(time, zframe) = mean(u);
        dy(time, zframe) = mean(v);

        delete(file1); 
        delete(file2);

    end
%     Not sure why this is in. Prints the last file name used? But also
%     just gives an error because there are backslashes in the file name.
%     fprintf(['\n\n\n\n\n' file1 '\n']);

end 

 csvwrite(strainpathX, dx);
 csvwrite(strainpathY, dy);

end