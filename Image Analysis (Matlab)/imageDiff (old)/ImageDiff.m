function [ImDiff] = ImageDiff(file_path)
% Calculates mean difference between pixels in consecutive images (zstacks)

% file_path = ['C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 0.1V 7-12-16.mdb\timeseries4.lsm'];
% 'C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 0.1V 7-12-16.mdb\timeseries4.lsm'

% 'C:\Users\Eric\Documents\Xerox Data\2Hz Combined Runs 7-18-16\2Hz 0.1V.mdb\timeseries1.lsm'

% Meera's Data (test)
% file_path = ['C:\Users\Eric\Documents\Xerox Data\Meeras Data\'...
%     '2016_04_27\0.5V_1Hz.mdb\InitialTimeseries.lsm'];

%%%%%%%% Drift subtracted part %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Difference between consecutive images with drift subtracted.
% file_path = ['C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 1.2V 7-10-16.mdb\timeseries1.lsm'];
% strainpathX = [file_path '_v_fieldX1.csv'];
% strainpathY = [file_path '_v_fieldY1.csv'];
% 
% shiftX= xlsread(strainpathX);
% % shiftX(time, z-height)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
zini = 1;
dz = 1;
zsiz = 100;

freq = 1; % Imaging frequency

xsiz = 512;
ysiz = 256;
% row, column, height = y, x, z
A1 = zeros(ysiz, xsiz, zsiz); 
A2 = zeros(ysiz, xsiz, zsiz); 

% Set A1 to 
cnt = 1;
for zframe = zini:dz:zsiz
    A1(:, :, cnt) = imread(file_path, 2*zframe -1); 
    cnt = cnt +1;
end

numtframes = 50;
ImDiff = zeros(numtframes,1);
 for tframe = 1:1:numtframes
     cnt = 1;
     for zframe = zini:dz:zsiz
         A2(:, :, cnt) = imread(file_path, 2*(tframe*zsiz + zframe)-1);
         cnt = cnt + 1;
     end
     ImDiff(tframe) = mean(mean(mean(abs(double(A1) -double(A2)))));
     A1 = A2;
 end
 
% Plot mean difference between images over time
figure;
x = 1:1:numtframes-1;
t = x/freq;
plot(t,ImDiff(x),'b:o');
title('Mean difference between images vs time');
xlabel('Time (s)');
ylabel('Mean difference between images');

% Plot with time from first few times subtracted.
figure;
startCut = 3;
x = startCut:1:numtframes-1;
t = (x - (startCut-1)) /freq;
plot(t,ImDiff(x),'b:o');
title('Mean difference between images vs time');
xlabel('Time (s)');
ylabel('Mean difference between images');
 
end