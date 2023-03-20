% Difference Between Consecutive Images
% Calculates the mean difference in pixel values at each timestep.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Meera's data
filename = ['C:\Users\Eric\Documents\Xerox Data\Meeras Data\'...
    '2016_04_27\0.5V_1Hz.mdb\InitialTimeseries.lsm'];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Eric's Data
% filename = ['C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\'...
%     '2Hz 1.2V 7-10-16.mdb\timeseries1.lsm'];

% filename = ['C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\'...
%     '2Hz 0.1V 7-12-16.mdb\timeseries1.lsm'];



zsiz = 100;
% Make sure figure dimensions are correct (errors otherwise).
% I think it reverses x and y for some reason?
A1 = zeros(256, 512, 100); 
A2 = zeros(256, 512, 100); 
cnt = 1;
freq = 1; % Frequency of zstacks (may not be same as oscillation).
for i = 1:1:zsiz
    A1(:, :, cnt) = imread(filename, 2*i -1); % Previously included "2*zsiz +"
    cnt = cnt +1;
end

numPoints = 50;
 for i = 1:1:numPoints % Previously start from 2 (if ignoring first frame)
     cnt = 1;
     for j = 1:1:zsiz
         A2(:, :, cnt) = imread(filename, 2*(i*zsiz + j)-1);
         cnt = cnt + 1;
     end
     ImagDiff(i) = mean(mean(mean(abs(double(A1) -double(A2))))); % Previously i-1
     A1 = A2;
 end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Plotting ImagDiff
% x = 1:1:numPoints-1;
% plot(x,ImagDiff(x),'b:o');
% title('Image Difference vs frame (0.5Hz 0.5V 3D)');
% xlabel('frame');
% ylabel('ImageDiff');

% Plot mean difference between images over time
figure;
x = 1:1:numPoints-1;
t = x/freq;
plot(t,ImagDiff(x),'b:o');
title('Mean difference between images vs time');
xlabel('Time (s)');
ylabel('Mean difference between images');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Log-linear plot
% logt = log(t);
% logy = log(ImagDiff(x));
% plot(t,logy,'b:o');
% % Not particularly linear suggesting not a great exponential decay fit.
% 
% % Exponential fit (with final value subtracted off to get rid of offset
% % term)
% expfit = fit(t(1:numPoints-1)',(ImagDiff(1:numPoints-1)-mean(ImagDiff(numPoints-11:numPoints-1)))','exp1');
% % Fit isn't awful, but y-intercept is like 30% off. Not great.
% 
% x = 1:1:numPoints-1;
% plot(t(1:numPoints-1)',...
%     ImagDiff(1:numPoints-1) - mean(ImagDiff(numPoints-11:numPoints - 1))','b:o');
% hold on
% plot(expfit)
% hold off
% title('Image Difference vs time)');
% xlabel('time (s)');
% ylabel('ImageDiff (with steady state value subtracted)');