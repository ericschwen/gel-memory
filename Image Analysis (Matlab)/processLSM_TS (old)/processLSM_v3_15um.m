function processLSM(file_path)
% Process lsm file function

% Get particle drift data
shear_band_calculation_v5_15um(file_path);

fprintf('%s\n %s\n', 'shift calc done', file_path);

% Band Pass filter
lsmTS_BPfilter_v3_15um(file_path);

fprintf('%s\n %s\n', 'BP done', file_path);

% Calculate image difference
ShiftedImageDiff_v10_15um(file_path);

fprintf('%s\n %s\n', 'ImDiff done', file_path);
end

