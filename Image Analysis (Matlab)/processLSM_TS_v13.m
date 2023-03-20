% Master file for running all the necessary image processing code to
% analyze time series zstacks of sheared colloidal gel.

% v13: 4-18-17

% rootFolder = 'C:\Eric\Xerox Data\30um gap runs\6-14-19 data\';
% 
% subFolderList = {'0.6V y-train\ampsweep-pre-train','0.6V y-train\ampsweep-post-train','0.6V y-train\training',...
%     '0.6V\training', '0.6V\ampsweep-post-train', '0.6V\ampsweep-pre-train'};

rootFolder = 'C:\Eric\Xerox Data\30um gap runs\0.5Hz combined gel runs 1-17-17\0.4V\';
subFolderList = {'train_ts1'};

rootFolder = 'D:\Xerox Data\30um gap runs\0.2Hz combined runs 1-31-17\0.0V\';
subFolderList = {'training'};

rootFolder = 'D:\Xerox Data\30um gap runs\0.5Hz combined gel runs 1-17-17\1.8V\';
subFolderList = {'ampsweep_post_train', 'ampsweep_pre_train', 'train_ts1', 'train_ts2'};


% subFolderList = {'ampsweep-post-train', 'ampsweep-pre-train','training'};
% subFolderList = {'training'};
% subFolderList = {'ampsweep-pre-train'};
% subFolderList = {'ampsweep-post-train', 'training'};
% subFolderList = {'ampsweep-pre-train-combined', 'ampsweep-post-train-combined', 'training'};
folderEndList = {''};

% rootFolder = 'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\0.6V\';
% subFolderList = {'train0','train50','train100','train150','train200','train300','train400',};
% folderEndList = {''};
% % subFolderList = {'train'};
% % folderEndList = {'100', '150', '200', '300', '400'};


% folderEndList = {'0', '50', '100', '150', '200', '300', '400'};
% rootFolder = 'C:\Eric\Xerox Data\30um gap runs\8-11-17 0.3333Hz training\No training delay\';
% subFolderList = {'waiting_time_series'};
% folderEndList = {''};


for i = 1:1:length(subFolderList)
    for j = 1:1:length(folderEndList)
        
        folderPath = [rootFolder, subFolderList{i}, folderEndList{j}];
% 
        % import image from tiffs and make hyperstack
        [parameters, allPaths] = lsm_parallel_import_v3(folderPath);
        fprintf('%s%s\n', 'import done: ', subFolderList{i});

%         % drift calculation
%         drift_matPIV_v4(parameters, allPaths, folderPath);
%         fprintf('%s%s\n', 'drift calc done: ', subFolderList{i});

        % Band Pass filter
        lsmTS_BPfilter_v12(parameters, allPaths, folderPath);
        fprintf('%s%s\n', 'BP done: ', subFolderList{i});
    
        % Otsu filter
        tifstack_otsuFilter_v4(parameters, allPaths, folderPath);
        fprintf('%s%s\n', 'otsuFilter done: ', subFolderList{i});

        % Get image difference data
        imageDiff_v8(parameters, allPaths, folderPath);
        fprintf('%s%s\n', 'otsu imdiff done: ', subFolderList{i});
    end

end

%%
% % Testing code. run this part to set global variable as local variables
% % for running specfic functions.
% params = parameters;
% all_paths = allPaths;
% folder = folderPath;

%%
%%%%%%%%%%%%% NOTES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% For amsweep, follow with ampsweep_save_magnitudes to get and save the
% image difference amplitudes for each strain amplitude. Can then plot the
% results using amspweep_plot_magnitudes.

% Currently (as of 4-18-17) not using drift calculation for anything. Only
% drifts about 0.1 pixel between subsequent images (~1um per 100 cycles),
% so there isn't really anything to subtract if I'm rounding to whole
% integer nubmers.


% Maybe should clear parameters at end of each loop
% clear('parameters');