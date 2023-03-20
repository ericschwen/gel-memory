%filename = 'C:\Data\XEROX\2016_04_27\0.05V_1Hz.mdb\Timeseries_Initial.lsm';

%1 Volt amplitude data
filename = ['C:\Users\Eric\Documents\Xerox Data\' ...
    '0.5Hz_1Amp_5-27-16.mdb\TimeSeries_2sec.lsm'];

zsiz = 80;
A1 = zeros(256,512, zsiz);
A2 = zeros(256,512, zsiz);
cnt = 1;
for i = 1:1:zsiz
    A1(:, :, cnt) = imread(filename, 2 * zsiz + 2*i -1);
    cnt = cnt +1;
end
 for i = 2:1:50
     cnt = 1;
     for j = 1:1:zsiz
         A2(:, :, cnt) = imread(filename, 2*(i*zsiz + j)-1);
         cnt = cnt + 1;
     end
     ImagDiff(i-1) = mean(mean(mean(abs(double(A1) -double(A2)))));
     A1 = A2;
 end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plotting ImagDiff
x = 1:1:49;
plot(x,ImagDiff(x),'b:o');
title('Image Difference vs frame (0.5Hz 1Amp 3D)');
xlabel('frame');
ylabel('ImageDiff');