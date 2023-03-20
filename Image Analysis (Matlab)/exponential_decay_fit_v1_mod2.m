% exponential_decay_fit
%
% Fit the decay of image difference as a gel is trained to exponential
% decay.
% 
% Mod History:
% v1_mod1: change start point to work with data without pauses 4-11-17,
% etc. (1-29-18)
% v1_mod2: change file reading to work with data without pauses 1-17-17,
% etc. (1-29-18)
%
% Date: 1-19-18
% Author: Eric Schwen

%% Import image difference data
% folder = 'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\';
% folder = 'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\1.0\';
% fileList = {'train0', 'train50', 'train100', 'train150', 'train200', 'train300', 'train400'};

% folder = 'C:\Eric\Xerox Data\30um gap runs\0.3333Hz 4-11-17\1.4V\';
% fileList = {'training'};

% folder = 'F:\30um gap runs 1-17 -- 2-17\0.5Hz combined gel runs 1-17-17\0.4V\';
% fileList = {'train_ts1', 'train_ts2'};

folderEnd = '_imageDiff';

fileNumbers = 1:1:length(fileList);
numfiles = length(fileList);

% Declare cell array sizes.
filename = cell(numfiles,1);
filebase = cell(numfiles,1);
midpath = cell(numfiles,1);
mid = cell(numfiles,1);
legendInfo = cell(numfiles,1);

for i = fileNumbers
    filename{i} = [folder, fileList{i}, folderEnd];
    
%     midpath{i} = [filename{i} '\meanImageDiff_otsu.csv'];
    
    % edit for 1-17-17 data
    midpath{i} = [filename{i}, '\', fileList{i}, '_meanImageDiffCenter_otsu.csv'];
    
    mid{i} = xlsread(midpath{i});
%     mid{i} = mid{i}(3:length(mid{i})-2);
    
    if i == 1
        midtotal = mid{i};
    else
        midtotal = cat(1,midtotal,mid{i});
    end
end

% Trim off points before shear starts (mod1 edit)
% also trim end points
tstart = 20;
tend_trim = 500;
midtotal = midtotal(tstart:length(midtotal)-tend_trim);


%% Plot full data set
figure;
t = (1:1:length(midtotal))';
% t = t*2;
hold on
plot(t,midtotal,'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 12);

% %Plot vertical lines
% for i = 1:1:numfiles-1
%     plot(ones(100,1) * length(mid{1})*6*i, 1:1:100, 'r--')
% end 

title('Training','FontSize', 20);
xlabel('Shear cycles','FontSize', 18);
ylabel('Mean image difference','FontSize', 18);
ylim([0.02 0.07])
xlim([0 length(midtotal)])
% axis([0 max(t) 0.02 0.14]);

xt = get(gca,'XTick');
set(gca, 'FontSize', 16)

hold off

%% remove extreme outliers (not actual data points anyway)
midtrim = midtotal;
for i=length(midtotal):-1:1
    if midtotal(i) > 0.1
        midtrim(i) = [];
    end
end
tt = (1:1:length(midtrim))';

%% Curve fitting last points

% try fitting last few data points to get offset
start = length(midtotal) - 100;
flat_end = fit(tt(start:end-2)-start, midtrim(start:end-2), 'poly1');
flat_coeffs = coeffvalues(flat_end);
offset = flat_coeffs(2);

% Plot fit and data
figure;
hold on
plot(tt(start:end-2)-start,midtrim(start:end-2),'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 12);
plot(flat_end)

%%%%%%%%%%%% Plot imdiff without offset
figure;
hold on
plot(tt,midtrim - offset,'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 12);

title('Training','FontSize', 20);
xlabel('Shear cycles','FontSize', 18);
ylabel('Mean image difference','FontSize', 18);
% ylim([-0.005 0.05])
xlim([0 length(midtotal)])
% axis([0 max(t) 0.02 0.14]);

xt = get(gca,'XTick');
set(gca, 'FontSize', 16)
hold off

%% fit to exponential decay
exp_fit = fit(tt(1:end-2),midtrim(1:end-2)-offset,'exp1');
exp_coeffs = coeffvalues(exp_fit);
lifetime = -1/exp_coeffs(2);
man_exp_fit = exp_coeffs(1)*exp(exp_coeffs(2)*tt) + offset;

figure;
hold on
plot(tt, man_exp_fit, 'r', 'LineWidth', 2)
plot(tt(1:end),midtrim(1:end), 'b.', 'MarkerSize', 8)


title('Training','FontSize', 20);
xlabel('Shear cycles','FontSize', 18);
ylabel('Mean image difference','FontSize', 18);
% ylim([-0.005 0.05])
xlim([0 length(midtotal)])
% axis([0 max(t) 0.02 0.14]);

xt = get(gca,'XTick');
set(gca, 'FontSize', 16)
hold off

% %%%%%%%%%%%%%%%%% HAMPEL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Try removing outliers with Hampel function
% mid_hampel = hampel(midtotal, 40,5);
% 
% % Plot hampel data set
% figure;
% t = (1:1:length(midtotal))';
% % t = t*2;
% hold on
% plot(t,mid_hampel,'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 12);
% 
% title('Training','FontSize', 20);
% xlabel('Shear cycles','FontSize', 18);
% ylabel('Mean image difference','FontSize', 18);
% % ylim([0.02 0.07])
% xlim([0 500])
% % axis([0 max(t) 0.02 0.14]);
% 
% xt = get(gca,'XTick');
% set(gca, 'FontSize', 16)
% hold off
% %% Test fit to exponential decay with hampel
% last = 150;
% exp_fit_hampel = fit(t(1:end),mid_hampel(1:end)-offset,'exp1');
% exp_coeffs_hampel = coeffvalues(exp_fit_hampel);
% lifetime_hampel = -1/exp_coeffs(2);
% man_exp_fit_hampel = exp_coeffs_hampel(1)*exp(exp_coeffs_hampel(2)*t) + offset;
% 
% figure;
% hold on
% plot(t, man_exp_fit_hampel, 'r', 'LineWidth', 2)
% plot(t(1:end),mid_hampel(1:end), 'b.', 'MarkerSize', 8)
% 
% 
% title('Training','FontSize', 20);
% xlabel('Shear cycles','FontSize', 18);
% ylabel('Mean image difference','FontSize', 18);
% % ylim([-0.005 0.05])
% xlim([0 500])
% % axis([0 max(t) 0.02 0.14]);
% 
% xt = get(gca,'XTick');
% set(gca, 'FontSize', 16)
% hold off

%%%%%%%%%%%%%%%%%%%%% RESIDUALS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Check residuals
% 
% figure;
% residuals = midtrim-man_exp_fit;
% histogram(residuals, 30)
% title('Residuals histogram', 'FontSize', 20);
% 
% figure;
% hold on
% plot(tt, (midtrim -man_exp_fit), 'b.', 'MarkerSize', 8)
% 
% title('Residuals','FontSize', 20);
% xlabel('Shear cycles','FontSize', 18);
% ylabel('Data-Fit','FontSize', 18);
% % ylim([-0.005 0.05])
% xlim([0 500])
% % axis([0 max(t) 0.02 0.14]);
% 
% xt = get(gca,'XTick');
% set(gca, 'FontSize', 16)