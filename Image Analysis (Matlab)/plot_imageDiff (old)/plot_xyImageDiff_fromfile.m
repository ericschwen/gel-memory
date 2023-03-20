

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Import and plot image difference data
file1 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.2V 8-17-16.mdb\timeseries1.lsm';
file2 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.2V 8-17-16.mdb\timeseries2.lsm';
file3 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.2V 8-17-16.mdb\timeseries3.lsm';
% Pretty decreasing pattern.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
file1 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.4V 8-17-16.mdb\timeseries1.lsm';
file2 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.4V 8-17-16.mdb\timeseries2.lsm';
file3 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.4V 8-17-16.mdb\timeseries3.lsm';
file4 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.4V 8-17-16.mdb\timeseries4.lsm';
% Not a lot of decrease (still pretty high shear--not close to reversible).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

file1 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.1V 8-2-16.mdb\Timeseries1.lsm';
file2 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.1V 8-2-16.mdb\Timeseries3.lsm';
file3 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.1V 8-2-16.mdb\Timeseries2.lsm';
% Reasonable decreasing mean. Individual planes have most motion in lower
% heights (Actually fewer partilces lower in this run anyway).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
file1 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.5V 8-2-16.mdb\Timeseries1.lsm';
file2 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.5V 8-2-16.mdb\Timeseries2.lsm';
file3 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.5V 8-2-16.mdb\Timeseries3.lsm';
% General decreasing trend in mean. Individual planes sometimes decrease,
% some lower parts increase.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
file1 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.5V 8-15-16.mdb\timeseries1.lsm';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

folder = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.5V 8-15-16.mdb';


folder = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.2V 8-17-16.mdb';
numfiles = 3;

for i = 1:1:numfiles
    file{i} = [folder '\timeseries' num2str(i) '.lsm'];
    filebase{i} = file{i}(1:length(file{i})-4);
    midpath{i} = [filebase{i} '_meanImageDiff.csv'];
    mid{i} = xlsread(midpath{i});
    mid{i} = mid{i}(3:length(mid{i}));
    
    if i == 1
        midtotal = mid{i};
    else
        midtotal = cat(1,midtotal,mid{i});
    end
end

figure;
t = 1:1:length(midtotal);
t = t*5;
plot(t,midtotal,'b:o');
title('Mean difference between images vs time');
xlabel('Time (s)');
ylabel('Mean difference between images');

figure;
t = 1:1:length(mid{1});
t = t*5;
hold on
% for i = 1:1:numfiles
%     plot(t, mid{i}, ':o')
% end
plot(t,mid{1},'b:o');
plot(t,mid{2},'c:o');
plot(t, mid{3}, 'r:o');
% plot(t, mid{4}, 'g:o');
title('Mean difference between images vs time');
xlabel('Time (s)');
ylabel('Mean difference between images');
hold off


% XY difference over time for different heights

xyd1path = [filebase{1} '_meanXYDiff.csv'];
xyd2path = [filebase{2} '_meanXYDiff.csv'];
xyd3path = [filebase{3} '_meanXYDiff.csv'];
% xyd4path = [file4base '_meanXYDiff.csv'];
% xyd5path = [file5base '_meanXYDiff.csv'];
% xyd6path = [file6base '_meanXYDiff.csv'];


xyd1 = xlsread(xyd1path);
xyd2 = xlsread(xyd2path);
xyd3 = xlsread(xyd3path);
% xyd4 = xlsread(xyd4path);
% xyd5 = xlsread(xyd5path);
% xyd6 = xlsread(xyd6path);
% xyd1(tframe, zframe)

xyd1 = xyd1(3:size(xyd1,1), :);
xyd2 = xyd2(3:size(xyd2,1), :);
xyd3 = xyd3(3:size(xyd3,1), :);
% xyd4 = xyd4(3:size(xyd4,1), :);
% xyd5 = xyd5(3:size(xyd5,1), :);
% xyd6 = xyd6(3:size(xyd6,1), :);


xydtotal = [xyd1;xyd2;xyd3];%xyd4];%xyd5;xyd6];

figure;
t = 1:1:size(xydtotal,1);
t = t*5;
plot(t, xydtotal(:,50),'b:o')
hold on
plot(t,xydtotal(:,100),'c:o')
plot(t,xydtotal(:,150),'r:o')
plot(t,xydtotal(:,200),'g:o')
title('Mean difference between images vs time');
xlabel('Time (s)');
ylabel('Mean difference between images');
hold off
% Changes with height. Significant difference for lower heights, as
% expected for more stable lower 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%