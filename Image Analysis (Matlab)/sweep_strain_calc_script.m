% sweep strain calculation script

root_folder = 'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\0.6\';
subfolders = {'p0', 'p50', 'p100', 'p150', 'p200', 'p300', 'p400', 'p500'};
strain_voltage = 0.6;
volts = ones(length(subfolders),1)*strain_voltage;
strain_path = [root_folder, 'effective_strain_pauses.csv'];

% % PAUSES VERSION
% root_folder = 'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\0.6V\';
% subfolders = {'p0', 'p50', 'p100', 'p150', 'p200', 'p300', 'p400', 'p500'};
% strain_voltage = 0.6;
% volts = ones(length(subfolders),1)*strain_voltage;
% strain_path = [root_folder, 'effective_strain_pauses.csv'];

% % AMPSWEEP VERSION
% root_folder = 'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\0.6V\ampsweep\';
% % Read all file names from folder
% files_dir = dir(root_folder);
% subfolders = cell(length(files_dir)-2, 1);
% for i = 3:length(files_dir)
%     subfolders{i-2} = files_dir(i).name;
% end
% strain_path = [root_folder(1:length(root_folder)-9), 'effective_strain_sweep.csv'];
% volts = str2double(subfolders);


%%%%%%%%%%%%%% SET TOP HEIGHT %%%%%%%%%%
h1 = 0;
% % 1-6-18 uses 13.4um for center height h2.
% h2 = 13.4;

% 8-29-17 uses 15um for center height h2.
h2 = 15.0;


amp_um = zeros(length(subfolders),1);
amp_px = zeros(length(subfolders),1);
max_to_zero = zeros(length(subfolders),1);
min_to_zero = zeros(length(subfolders),1);
eff_strain = zeros(length(subfolders),1);

% root_folder = 'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\1.0\';
% subfolders = {'shear_ts_bottom', 'shear_ts_middle', 'shear_ts_top'};

for i = 1:length(subfolders)
        path = [root_folder, subfolders{i}, '\xy_ts'];
    [amp_um(i), amp_px(i), max_to_zero(i), min_to_zero(i)] = strain_amp_calc_pcycle_v1(path, 0.3333);
end

% effective strain = (a2-a1)/(h2-h1) (or negative that)
% heights in microns
% could check center height better using center of zstacks pre and post
% train


% a2 will be amp_um
% using strain at bottom = 4.5um/V
v2um = 4.1;

% % PAUSES version for single amplitude
% a1 = v2um * strain_voltage; % in um
% for i = 1:length(amp_um)
%     eff_strain(i) = - (amp_um(i) - a1)/(h2-h1);
% end

% AMPSWEEEP version
a1 = volts * v2um;
for i = 1:length(amp_um)
    eff_strain(i) = - (amp_um(i) - a1(i))/(h2-h1);
end


data = [volts, amp_um, amp_px, max_to_zero, min_to_zero, eff_strain];

csvwrite(strain_path, data)