%%%
% tiffStack_from_tiffs_v2.m
%
% Takes a set of tiffs exported by zen blue (zeiss software) and makes them
% into tiff stacks.
%
% Author: Eric
% Date: 11/30/17

folder = 'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\Untrained delayed short\waiting';
file_name_start = 'waiting_t';

out_folder = 'C:\Eric\Xerox\Python\peri\128x128x50_static';

for t = 300:1:305 
    time = num2str(t);
    out_path = [out_folder, '\', 't', time, '.tif'];
    
    for z = 1:50
        if z < 10
            zframe = ['0', num2str(z)];
        else
            zframe = num2str(z);
        end
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
