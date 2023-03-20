% nonlinear least squares exponential decay fit

% Define custom nonlinear fittype and use matlab's built in fit function
% for exponential decay with offset

% Author: Eric
% Date: 6-6-18


%%%%%%%%%%%%%%%%%%%%%%%%%%%% IMPORTING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
folder = 'C:\Eric\Xerox Data\30um gap runs\6-28-18 data\0.7V\';
fileList = {'training'};
% fileList = {'train0', 'train50', 'train100', 'train150', 'train200', 'train300', 'train400'};
% fileList = {'train_ts1', 'train_ts2'};
folderEnd = '_imageDiff';

% Trim off points before shear starts and after it ends (mod1 edit)
%%%%%%%%%%%%%%%%%%%%%%% MANUAL INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tstart = 12;
tend_trim = 40;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
    
    midpath{i} = [filename{i} '\meanImageDiff_otsu.csv'];
%     midpath{i} = [filename{i} '\' fileList{i} '_meanImageDiffCenter_otsu.csv'];
    
    mid{i} = xlsread(midpath{i});
%     mid{i} = mid{i}(3:length(mid{i})-2);
    
    if i == 1
        midtotal = mid{i};
    else
        midtotal = cat(1,midtotal,mid{i});
    end
end


midtrim_init = midtotal(tstart:length(midtotal)-tend_trim);

% Plot full data set
figure;
t = (1:1:length(midtrim_init))';
% t = t*2;
hold on
plot(t,midtrim_init,'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 12);

title('Training','FontSize', 20);
xlabel('Shear cycles','FontSize', 18);
ylabel('Mean image difference','FontSize', 18);
% ylim([0.02 0.05])
% xlim([0 550])
% axis([0 max(t) 0.02 0.14]);

xt = get(gca,'XTick');
set(gca, 'FontSize', 16)

hold off

%%% remove extreme outliers (not actual data points anyway)
midtrim = midtrim_init;
for i=length(midtrim_init):-1:1
    if midtrim_init(i) > 0.6
        midtrim(i) = [];
    end
end
tt = (1:1:length(midtrim))';

% % Plot full data set with outliers removed (checking)
% figure;
% % t = t*2;
% hold on
% plot(tt,midtrim,'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 12);
% 
% title('Training','FontSize', 20);
% xlabel('Shear cycles','FontSize', 18);
% ylabel('Mean image difference','FontSize', 18);
% % ylim([0.02 0.05])
% xlim([0 550])
% % axis([0 max(t) 0.02 0.14]);



%% Create Custom Nonlinear Models and Specify Problem Parameters and Independent Variables

% Set estimates
b_0 = mean(midtrim(length(midtrim)-20: end)); % offset estimate
a_0 = mean(midtrim(1:5)) - b_0; % start point estimate
lamb_0 = 1/50.;
vars_0 = [a_0 lamb_0 b_0];

% Set bounds
lb = [0 0 0];
ub = [.2 1/5. .1];


myfittype = fittype('a*exp(-lamb*t)+b', 'dependent', {'y'},'independent', {'t'},...
    'coefficients', {'a','lamb', 'b'});

myfit = fit(tt, midtrim, myfittype, 'Lower', lb, 'Upper', ub, 'StartPoint', vars_0)
fit_coeffs = coeffvalues(myfit);
lifetime = 1/fit_coeffs(2)

figure;
hold on
plot(tt, midtrim,'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 10)
plot(myfit)
title('Training','FontSize', 20);
xlabel('Shear cycles','FontSize', 18);
ylabel('Mean image difference','FontSize', 18);
xt = get(gca,'XTick');
set(gca, 'FontSize', 16)
hold off


