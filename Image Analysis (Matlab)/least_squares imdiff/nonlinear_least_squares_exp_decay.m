% nonlinear_least_squares_exp_decay
% 
% Fit variables for exponential decay with offset using nonlinear least
% squares.
% 
% Model: y = a * exp(-lamb * t) + b
% 
% Author: Eric
% Date: 6-6-18

%%%%%%%%%%%%%%%%%%%%%%%%%%%% IMPORTING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
folder = 'C:\Eric\Xerox Data\30um gap runs\5-21-18 data\1.0V run4\';
fileList = {'training'};
folderEnd = '_imageDiff';

% Trim off points before shear starts and after it ends (mod1 edit)
%%%%%%%%%%%%%%%%%%%%%%% MANUAL INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tstart = 8;
tend_trim = 70;
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
xlim([0 550])
% axis([0 max(t) 0.02 0.14]);

xt = get(gca,'XTick');
set(gca, 'FontSize', 16)

hold off

%% remove extreme outliers (not actual data points anyway)
midtrim = midtrim_init;
for i=length(midtrim_init):-1:1
    if midtrim_init(i) > 0.2
        midtrim(i) = [];
    end
end
tt = (1:1:length(midtrim))';

%% Minimization
midtrim = midtrim.';
% Set estimates
b_0 = mean(midtrim(length(midtrim)-20: end)); % offset estimate
a_0 = mean(midtrim(1:5)) - b_0; % start point estimate
lamb_0 = 1/50.;
vars_0 = [a_0 lamb_0 b_0];

% Set bounds

lb = [0 0 0];
ub = [.1 .05 .1];


x = fmincon(@(x)sum_squares_exp_decay(x, midtrim), vars_0, [], [], [], [], lb, ub);
lifetime = 1/x(2)
%% Plot comparison


% Plot full data set
figure;
t = (1:1:length(midtrim))';
% t = t*2;
hold on
plot(t,midtrim,'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 12);

plot(t,x(1)*exp(-x(2)*t.') + x(3), 'r.');


title('Training','FontSize', 20);
xlabel('Shear cycles','FontSize', 18);
ylabel('Mean image difference','FontSize', 18);
% ylim([0.02 0.05])
% xlim([0 550])
% axis([0 max(t) 0.02 0.14]);

xt = get(gca,'XTick');
set(gca, 'FontSize', 16)

hold off
