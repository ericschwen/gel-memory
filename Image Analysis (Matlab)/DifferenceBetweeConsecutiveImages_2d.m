%filename = 'C:\Data\XEROX\2016_04_27\0.05V_1Hz.mdb\Timeseries_Initial.lsm';

%1 Volt amplitude data
% filename = ['C:\Users\Eric\Documents\Xerox Data\' ...
%    '0.5Hz_1Amp_5-27-16.mdb\XY_steadystate_TimeSeries_2sec.lsm'];

%3 Volt amplitude data
fileRoot = ['C:\Users\Eric\Documents\Xerox Data\' ...
    '0.5Hz_3Amp_6-2-16.mdb\xy_steadystate_timeseries'];

fileName = [fileRoot '.lsm'];

outPath = [fileRoot '.tif'];

A1 = zeros(512,512);
A2 = zeros(512,512);

A1(:, :) = imread(fileName, 1);

timesteps = 60;

 for i = 2:1:timesteps
     A2(:, :) = imread(fileName, 2*i -1);
     
%      % Try printing one of the image differences
%      if i == 23
%          img = imcomplement(mat2gray(abs(A1 - A2)));
%          imwrite(img, outPath);
%          imshow(img);
%      end
     ImagDiff(i-1) = mean(mean(abs(double(A1) -double(A2))));
     A1 = A2;

 end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plotting ImagDiff
x = 1:1:59;
plot(x,ImagDiff(x),'b:o');
title('Image Difference vs frame (0.5Hz 3V 2D)');
xlabel('frame');
ylabel('ImageDiff');

% This method doesn't account at all for the bit of drift in the images due
% to not being taken at exactly the same point in the shear cell. The
% difference between shifted images overestimates the level of movement of
% particles.
