%% script for running imageDiff on otsu-filtered images from static zstacks
% Author: Eric Schwen
% Date: 7-10-17

%%

folder = 'C:\Eric\Xerox Data\30um gap runs\6-28-17 0.3333Hz\1.0V\';
subfolders = {'zstacks_p0', 'zstacks_p100', 'zstacks_p200', 'zstacks_p300', 'zstacks_p400', 'zstacks_p500'};
stacks = {'s1', 's2'};

% folder = 'C:\Eric\Xerox Data\30um gap runs\6-22-17 0.3333Hz\1.4V sweep pauses\ampsweep_post_train\';
% subfolders = {'0.2V', '0.6V', '1.0V', '1.2V', '1.4V', '1.6V', '2.0V', '2.4V','2.8V'};
% stacks = {'s1', 's2', 's3', 's4', 's5'};

for i = 1:length(subfolders)
    imageDiff_v9(folder, subfolders{i}, stacks);
end

%% 6-22-17 pauses version

folder = 'C:\Eric\Xerox Data\30um gap runs\6-22-17 0.3333Hz\1.4V with pauses\zstack_';
subfolders = {'p100', 'p200', 'p300', 'p400', 'p500'};
stacks = {'_1', '_2', '_3'};

for i = 1:length(subfolders)
    imageDiff_v9_mod1(folder, subfolders{i}, stacks);
end