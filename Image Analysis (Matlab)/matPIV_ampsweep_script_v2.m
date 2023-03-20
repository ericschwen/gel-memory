
%  Calculate shifts throughout amplitude sweep
% 8-2-17


folder = 'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\1.0\ampsweep\2.4\';
zsiz = 50;

% % Read all file names from folder
% files_dir = dir(folder);
% filenames = cell(length(files_dir)-2, 1);
% filepaths = cell(length(filenames),1);
% for i = 3:length(files_dir)
%     filenames{i-2} = files_dir(i).name;
%     filepaths{i-2} = [folder, filenames{i-2}];
% end

filenames = {'u0.lsm', 'u1.lsm', 'u2.lsm', 'u3.lsm', 'u4.lsm', 'u5.lsm'};
filepaths = cell(length(filenames),1);
for i = 1:length(filenames)
    filepaths{i} = [folder, filenames{i}];
end


% % reorder for ampsweep down
% filenames_ord = cat(1, filenames(end-3:end), filenames(7:9), filenames(4:6), filenames(1:3));
% for i = 1:length(filenames)
%     filepaths_ord{i} = [folder, filenames_ord{i}];
% end

% % ignore folders at end
% filepaths = filepaths(1:end-2);

dx = zeros(length(filepaths)-1,1);

for i = 1:(length(filepaths)-1)
    [dx(i), dy] = matPIV_2stacks_v1(filepaths{i}, filepaths{i+1}, zsiz);
end

figure;
plot(1:length(filepaths)-1, dx,'b:o');
title('Shift vs file');
xlabel('file');
ylabel('Shift (pixels)');
% axis([0 length(filepaths) -1 1]);

figure;
plot(1:length(filepaths)-1, .125*dx,'b:o');
title('Shift vs file');
xlabel('file');
ylabel('Shift (um)');
% axis([0 length(filepaths) -1 1]);

% Calculate total shift
shift_sum_x = zeros(length(dx),1);
shift_sum_x(1) = dx(1);
for i = 2:length(dx)
    shift_sum_x(i) = dx(i) + shift_sum_x(i-1);
end

figure;
plot(1:length(shift_sum_x), shift_sum_x,'b:o');
title('Total Shift vs file');
xlabel('file');
ylabel('Shift (pixels)');
% axis([0 max(timesteps) -5 5]);

% amps_up = [0.5, 1.3, 2.1, 3.9, 5.1, 6.3];
% shifts_up = [dx(1), dx(4), dx(7), dx(10), dx(13), dx(16)];

% amps_down = [4.8, 3.1, 1.9, 0.3];
% shifts_down = [dx(1), dx(4), dx(7), dx(10)];
% 
% figure;
% plot(amps_down, shifts_down, 'b:o');
% title('Shift vs amplitude');
% xlabel('amplitude (V)');
% ylabel('Shift (pixels)');