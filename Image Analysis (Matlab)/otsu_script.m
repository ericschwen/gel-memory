% Script for running shift, bpass and image difference calculations.

folder = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.2V 8-17-16.mdb';

% for i = 1:1:3
%     filename = [folder '\timeseries' num2str(i) '_bpass.tif'];
%     
%     % Get particle drift data
%     tifstack_otsuFilter_v1(filename);
% 
%     fprintf('%s\n %s\n', 'otsuFilter', filename);
% end

for i = 1:1:3
    filename = [folder '\timeseries' num2str(i) '.lsm'];
    
    % Get particle drift data
    ShiftedImageDiff_v13_otsu(filename);

    fprintf('%s\n %s\n', 'otsuFilter', filename);
end