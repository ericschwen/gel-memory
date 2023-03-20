% folder = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1V 0.5Hz 12-7-16\';
% fileList = {'ts1.lsm', 'ts2.lsm', 'ts3.lsm'};


folder = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\0.5Hz combined gel runs 1-17-17\';
fileList = {'0.4V\train_ts2.lsm',...
    '1.8V\train_ts2.lsm',...
    '1.0V (3rd)\train_ts2.lsm'};

%Done

%'0.6V\train_st2.lsm'
%'1.4V\train_ts2.lsm'
%'1.0V (2nd)\train_ts2.lsm'


% note typo on 0.6V train_st2

for i = 1:1:length(fileList)
    filename = [folder, fileList{i}];
    
    % Band Pass filter
    lsmTS_BPfilter_v7_50slice_510cycle(filename);
    fprintf('%s\n %s\n', 'BP done', filename);

    % Otsu filter
    tifstack_otsuFilter_v2_50slice_510cycle(filename);
    fprintf('%s\n %s\n', 'otsuFilter done', filename);

    % Get image difference data
    imageDiff_v2_50slice_510cycle(filename);
    fprintf('%s\n %s\n', 'otsu imdiff done', filename);

end