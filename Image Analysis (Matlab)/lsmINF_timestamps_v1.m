% lsmINF_timestamps_v1

% uses lsm file toolbox to get timestamps for images
% output: image timestamps

function timestamps = lsmINF_timestamps_v1(Filename)


% filename = 'C:\Eric\Xerox Data\7-30-17 shift testing\xy ts cycles\1.8V.lsm';
filename = Filename;

fid = fopen(filename);
[lsminf,scaninf,imfinf] = lsminfo(filename);

lsminf = timestampsread(fid, lsminf);

timestamps = lsminf.TimeStamps.TimeStamps;
% timesteps = lsminf.TimeStamps.TimeSteps

end
