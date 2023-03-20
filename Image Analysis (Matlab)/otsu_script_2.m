%% Script for running otsu filter on many single zstacks

% folder = 'C:\Eric\Xerox Data\30um gap runs\6-28-17 0.3333Hz\1.0V\';
% subfolders = {'zstacks_p0', 'zstacks_p100', 'zstacks_p200', 'zstacks_p300', 'zstacks_p400', 'zstacks_p500'};
% stacks = {'u1', 'u2', 'u3', 's1', 's2'};

folder = 'C:\Eric\Xerox Data\30um gap runs\6-22-17 0.3333Hz\1.4V sweep pauses\ampsweep_pre_train\';
subfolders = {'1.4V', '1.6V', '2.0V', '2.4V', '2.8V'};
stacks = {'u1', 'u2', 'u3', 'u4', 'u5'};

for i = 1:length(subfolders)
    for j = 1:length(stacks)
        tifstack_otsuFilter_v5(folder, subfolders{i}, stacks{j})
    end
    fprintf('%s%s\n', 'otsu done: ', subfolders{i});
end

% %% 6-22-17 pauses version
% 
% folder = 'C:\Eric\Xerox Data\30um gap runs\6-22-17 0.3333Hz\1.4V with pauses\zstack_';
% subfolders = {'p100', 'p200', 'p300', 'p400', 'p500'};
% stacks = {'_1', '_2', '_3'};
% 
% for i = 1:length(subfolders)
%     for j = 1:length(stacks)
%         tifstack_otsuFilter_v5_mod1(folder, subfolders{i}, stacks{j})
%     end
%     fprintf('%s%s\n', 'otsu done: ', subfolders{i});
% end