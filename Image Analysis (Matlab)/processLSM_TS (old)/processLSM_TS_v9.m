% folder = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1V 0.5Hz 12-7-16\';
% fileList = {'ts1.lsm', 'ts2.lsm', 'ts3.lsm'};


folder = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\0.5Hz combined gel runs 1-17-17\';
fileList = {'1.0V (2nd)\ampsweep_pre_train.lsm', '1.0V (2nd)\ampsweep_post_train.lsm',...
    '0.6V\ampsweep_pre_train.lsm', '0.6V\ampsweep_post_train.lsm',...
    '2.4V\ampsweep_pre_train.lsm', '2.4V\ampsweep_post_train.lsm',...
    '1.4V\ampsweep_pre_train.lsm', '1.4V\ampsweep_post_train.lsm',...
    '0.4V\ampsweep_pre_train.lsm', '0.4V\ampsweep_post_train.lsm',...
    '1.0V (3rd)\ampsweep_pre_train.lsm', '1.0V (3rd)\ampsweep_post_train.lsm'};


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
    imageDiff_v3_no_otsu(filename, 300, 50);
    fprintf('%s\n %s\n', 'bp imdiff done', filename);

end