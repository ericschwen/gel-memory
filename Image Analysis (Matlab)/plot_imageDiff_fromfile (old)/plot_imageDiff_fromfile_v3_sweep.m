%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mean image difference
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

folder = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\Gel 1Hz 0.8V 11-8-16';

filename = [folder '\ampsweep.lsm'];

filebase = filename(1:length(filename)-4);
midpath = [filebase '_meanImageDiff.csv'];
mid = xlsread(midpath);

figure;
t = 1:1:length(mid);
t = t*3;
hold on
plot(t,mid,'b:o');
title('Mean difference between images vs time');
xlabel('Time (s)');
ylabel('Mean difference between images');
hold off
axis([0 270 3.4 4.6]);






figure;
t = 1:1:length(midtotal);
t = t*6;
hold on
plot(t,midtotal,'b:o');
for i = 1:1:numfiles-1
    plot(ones(100,1) * length(mid{1})*6*i, 1:1:100, 'r--')
end 
title('Mean difference between images vs time');
xlabel('Time (s)');
ylabel('Mean difference between images');
hold off
axis([0 108*numfiles 2 18]);

figure;
t = 1:1:length(mid{1});
t = t*6;
hold on
plotStyle = ':o';
% plotStyle = {'b:o', 'c:o', 'r:o', 'g:o', 'm:o', 'k:o', 'y:o'};

colorList = {[0 0 0], [0 0 1], [0 1 0], [0 1 1], [1 0 0], [1 0 1], [1 1 0],...
    [0.9412 0.4706 0], [0.251 0 0.502], [0.502 0.251 0], [0 0.251 0],...
    [0.502 0.502 0.502], [0.502 0.502 1], [0 0.502 0.502], [0.502 0 0], [1 0.502 0.502]};

for i = fileNumbers
    plot(t, mid{i}, plotStyle, 'Color', colorList{i});
    legendInfo{i} = ['mid ' num2str(i)];
end
% plot(t,mid{1},'b:o');
% plot(t,mid{2},'c:o');
% plot(t, mid{3}, 'r:o');

% plot(t, mid{4}, 'g:o');
title('Mean difference between images vs time');
xlabel('Time (s)');
ylabel('Mean difference between images');
legend(legendInfo);
% axis([0 108*numfiles 3.5 6]);
hold off


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% XY difference over time for different heights
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = fileNumbers
    xydpath{i} = [filebase{i} '_meanXYDiff_normalized_postbpass.csv'];
    xyd{i} = xlsread(xydpath{i});
    xyd{i} = xyd{i}(3:size(xyd{i},1)-2, :);
    
    if i == 1
        xydtotal = xyd{i};
    else
        xydtotal = cat(1,xydtotal,xyd{i});
    end
end

figure;
t = 1:1:size(xydtotal,1);
t = t*6;
heights = [50, 100, 150, 200];
labels = cell(length(heights),1);
hold on
for i = 1:1:length(heights)
    plot(t, xydtotal(:,heights(i)),plotStyle, 'Color', colorList{i})
    labels{i} = ['zframe' num2str(heights(i))];
end

for i = 1:1:numfiles-1
    plot(ones(100,1) * length(mid{1})*6*i, 1:1:100, 'r--')
end 
title('Mean difference between images vs time');
xlabel('Time (s)');
ylabel('Mean difference between images');
legend(labels, 'Location', 'northeast');
axis([0 108*numfiles 0 30]);
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Colors
% [1 1 0]	Yellow
% [0 0 0]	Black
% [0 0 1]	Blue
% [0 1 0]	Bright green
% [0 1 1]	Cyan
% [1 0 0]	Bright red
% [1 0 1]	Pink
% [1 1 1]	White
% [0.9412 0.4706 0]	Orange
% [0.251 0 0.502]	Purple
% [0.502 0.251 0]	Brown
% [0 0.251 0]	Dark green
% [0.502 0.502 0.502]	Gray
% [0.502 0.502 1]	Light purple
% [0 0.502 0.502]	Turquoise
% [0.502 0 0]	Burgundy 
% [1 0.502 0.502]	Peach


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% % Import and plot image difference data
% file1 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.2V 8-17-16.mdb\timeseries1.lsm';
% file2 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.2V 8-17-16.mdb\timeseries2.lsm';
% file3 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.2V 8-17-16.mdb\timeseries3.lsm';
% % Pretty decreasing pattern.
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% file1 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.4V 8-17-16.mdb\timeseries1.lsm';
% file2 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.4V 8-17-16.mdb\timeseries2.lsm';
% file3 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.4V 8-17-16.mdb\timeseries3.lsm';
% file4 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.4V 8-17-16.mdb\timeseries4.lsm';
% % Not a lot of decrease (still pretty high shear--not close to reversible).
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% file1 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.1V 8-2-16.mdb\Timeseries1.lsm';
% file2 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.1V 8-2-16.mdb\Timeseries3.lsm';
% file3 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.1V 8-2-16.mdb\Timeseries2.lsm';
% % Reasonable decreasing mean. Individual planes have most motion in lower
% % heights (Actually fewer partilces lower in this run anyway).
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% file1 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.5V 8-2-16.mdb\Timeseries1.lsm';
% file2 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.5V 8-2-16.mdb\Timeseries2.lsm';
% file3 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.5V 8-2-16.mdb\Timeseries3.lsm';
% % General decreasing trend in mean. Individual planes sometimes decrease,
% % some lower parts increase.