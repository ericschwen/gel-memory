%%%
% tiffStack_from_tiffs_v2.m
%
% Takes a set of tiffs exported by zen blue (zeiss software) and makes them
% into tiff stacks.
%
% v3: change to variable number of . 11-11-19
%
% Author: Eric
% Date: 11/30/17

% % folder = 'D:\Glass data\11-5-19 bidisperse 1p5-2\ts2-500ms';
% % file_name_start = 'ts2-500ms_t';
% % out_folder = [folder, '-stacked'];

folder = 'E:\Gardner Data\piezo 2-13-20\2-14-20 testing\ts-post-p25';
file_name_start = 'ts-post-p25_t';
out_folder = [folder, '-stacked'];

mkdir(out_folder);

% NOTE: MUST manually designate number of digits for t and z as well as
% range for z and t

for t = 1:1:120 
    % Number before d is number of t-digits
    time = num2str(t, '%03d');
    out_path = [out_folder, '\', 't', time, '.tif'];
    
    for z = 1:100
        % Number before d is number of z-digits
        zframe = num2str(z, '%03d');
        file_name = [file_name_start, time, 'z', zframe, '_ORG.tif'];
        file_path = [folder, '\', file_name];
        
        image = imread(file_path);
        if z ~= 1
            imwrite(image, out_path, 'WriteMode', 'append', 'Compression', 'none')
        else
            imwrite(image, out_path, 'WriteMode', 'overwrite','Compression', 'none')
        end
    end
end
