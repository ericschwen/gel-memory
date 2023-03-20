folder = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\0.5V 0.5Hz 12-7-16\';

fileList = {'delayed_ts8.lsm'};

for i = 1:1:length(fileList)
    filename = [folder, fileList{i}];
%     
%     % Band Pass filter
%     lsmTS_BPfilter_v7_275s(filename);
%     fprintf('%s\n %s\n', 'BP done', filename);

    % Otsu filter
    tifstack_otsuFilter_v2_275s_20t(filename);
    fprintf('%s\n %s\n', 'otsuFilter done', filename);

    % Get image difference data
    imageDiff_v2_275s_20t(filename);
    fprintf('%s\n %s\n', 'otsu imdiff done', filename);

end