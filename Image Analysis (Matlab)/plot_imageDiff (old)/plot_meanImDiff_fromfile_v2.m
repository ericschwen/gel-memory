%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Import and plot image difference data


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
file1base = file1(1:length(file1)-4);
file2base = file2(1:length(file1)-4);
file3base = file3(1:length(file1)-4);
% file4base = file4(1:length(file1)-4);
% file5base = file5(1:length(file1)-4);
% file6base = file6(1:length(file1)-4);
% file7base = file7(1:length(file1)-4);

mid1path = [file1base '_meanImageDiff.csv'];
mid2path = [file2base '_meanImageDiff.csv'];
mid3path = [file3base '_meanImageDiff.csv'];
% mid4path = [file4base '_meanImageDiff.csv'];
% mid5path = [file5base '_meanImageDiff.csv'];
% mid6path = [file6base '_meanImageDiff.csv'];
% mid7path = [file7base '_meanImageDiff.csv'];

mid1 = xlsread(mid1path);
mid2 = xlsread(mid2path);
mid3 = xlsread(mid3path);
% mid4 = xlsread(mid4path);
% mid5 = xlsread(mid5path);
% mid6 = xlsread(mid6path);
% mid7 = xlsread(mid7path);

mid1 = mid1(3:length(mid1));
mid2 = mid2(3:length(mid2));
mid3 = mid3(3:length(mid3));
% mid4 = mid4(3:length(mid4));
% mid5 = mid5(3:length(mid5));
% mid6 = mid6(3:length(mid6));
% mid7 = mid7(3:length(mid7));

midtotal = [mid1;mid2;mid3];%mid4];%mid5;mid6];%mid7];

figure;
t = 1:1:length(midtotal);
t = t*5;
plot(t,midtotal,'b:o');
title('Mean difference between images vs time');
xlabel('Time (s)');
ylabel('Mean difference between images');

figure;
t = 1:1:length(mid1);
t = t*5;
plot(t,mid1,'b:o');
hold on
plot(t,mid2,'c:o');
plot(t, mid3, 'r:o');
% plot(t, mid4, 'g:o');
title('Mean difference between images vs time');
xlabel('Time (s)');
ylabel('Mean difference between images');

% Other file sets.

% 30um gaps:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

file1 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.4V 8-17-16.mdb\timeseries1.lsm';
file2 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.4V 8-17-16.mdb\timeseries2.lsm';
file3 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.4V 8-17-16.mdb\timeseries3.lsm';
file4 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.4V 8-17-16.mdb\timeseries4.lsm';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

file1 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.2V 8-17-16.mdb\timeseries1.lsm';
file2 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.2V 8-17-16.mdb\timeseries2.lsm';
file3 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.2V 8-17-16.mdb\timeseries3.lsm';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Import and plot image difference data

file1 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.1V 8-2-16.mdb\Timeseries1.lsm';
file2 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.1V 8-2-16.mdb\Timeseries3.lsm';
file3 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.1V 8-2-16.mdb\Timeseries2.lsm';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Import and plot image difference data

file1 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.5V 8-2-16.mdb\Timeseries1.lsm';
file2 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.5V 8-2-16.mdb\Timeseries2.lsm';
file3 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.5V 8-2-16.mdb\Timeseries3.lsm';


% 55um gaps:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Import and plot image difference data

file1 = 'C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 0.1V 7-12-16.mdb\timeseries1.lsm';
file2 = 'C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 0.1V 7-12-16.mdb\timeseries2.lsm';
file3 = 'C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 0.1V 7-12-16.mdb\timeseries4.lsm';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Import and plot image difference data

file1 = 'C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 1.2V 7-10-16.mdb\timeseries1.lsm';
file2 = 'C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 1.2V 7-10-16.mdb\timeseries2.lsm';
file3 = 'C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 1.2V 7-10-16.mdb\timeseries3.lsm';
file4 = 'C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 1.2V 7-10-16.mdb\timeseries4.lsm';
file5 = 'C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 1.2V 7-10-16.mdb\timeseries5.lsm';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Import and plot image difference data

file1 = 'C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 1.3V 7-11-16.mdb\timeseries1.lsm';
file2 = 'C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 1.3V 7-11-16.mdb\timeseries2.lsm';
file3 = 'C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 1.3V 7-11-16.mdb\timeseries3.lsm';
file4 = 'C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 1.3V 7-11-16.mdb\timeseries4.lsm';
file5 = 'C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 1.3V 7-11-16.mdb\timeseries5.lsm';
file6 = 'C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 1.3V 7-11-16.mdb\timeseries6.lsm';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
file1 = 'C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 1.4V 7-11-16.mdb\timeseries1.lsm';
file2 = 'C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 1.4V 7-11-16.mdb\timeseries2.lsm';
file3 = 'C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 1.4V 7-11-16.mdb\timeseries3.lsm';
file4 = 'C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 1.4V 7-11-16.mdb\timeseries4.lsm';
file5 = 'C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 1.4V 7-11-16.mdb\timeseries5.lsm';
file6 = 'C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 1.4V 7-11-16.mdb\timeseries6.lsm';
file7 = 'C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 1.4V 7-11-16.mdb\timeseries7.lsm';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

file1 = 'C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 2.2V 7-11-16.mdb\timeseries1.lsm';
file2 = 'C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 2.2V 7-11-16.mdb\timeseries2.lsm';
file3 = 'C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 2.2V 7-11-16.mdb\timeseries3.lsm';
file4 = 'C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 2.2V 7-11-16.mdb\timeseries4.lsm';
file5 = 'C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 2.2V 7-11-16.mdb\timeseries5.lsm';
file6 = 'C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 2.2V 7-11-16.mdb\timeseries6.lsm';