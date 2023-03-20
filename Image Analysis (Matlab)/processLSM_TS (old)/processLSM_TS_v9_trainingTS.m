folder = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\0.5Hz combined gel runs 1-17-17\';
fileList = {'1.0V (2nd)\train_ts1.lsm', '1.0V (2nd)\train_ts2.lsm',...
    '0.6V\train_ts1.lsm', '0.6V\train_st2.lsm',...
    '1.0V (3rd)\train_ts1.lsm', '1.0V (3rd)\train_ts2.lsm',...
    '0.4V\train_ts1.lsm', '0.4V\train_ts2.lsm',...
    '1.4V\train_ts1.lsm', '1.4V\train_ts2.lsm'};


for i = 1:1:length(fileList)
    filename = [folder, fileList{i}];
    
%     % Band Pass filter
%     lsmTS_BPfilter_v7_50slice_300cycle(filename);
%     fprintf('%s\n %s\n', 'BP done', filename);
% 
%     % Otsu filter
%     tifstack_otsuFilter_v2_50slice_300cycle(filename);
%     fprintf('%s\n %s\n', 'otsuFilter done', filename);

    % Get image difference data
    imageDiff_v3_no_otsu(filename, 510, 50);
    fprintf('%s\n %s\n', 'bp imdiff done', filename);

end