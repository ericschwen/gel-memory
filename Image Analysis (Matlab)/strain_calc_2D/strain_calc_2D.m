% 2D strain calc
function [ampStrain] = strain_calc_2D(file_path)

% Strain calculation

% Takes an input lsm xy timeseries as an input. Calculates the displacement
% for that height.

% Used on the bottom plate, this can calculate the strain for a particular
% applied voltage for the piezoelectric.

% file_path = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.4V 8-17-16.mdb\xyts2_5075.lsm';
filebase = file_path(1:length(file_path)-4);
strainpathX = [filebase '_v_fieldX1.csv'];

shiftX= xlsread(strainpathX);
numtframes = 500;
numSteps = numtframes-1;
totStrain = zeros(numSteps,1);

for t = 1:1:numSteps
    if t~=1
        totStrain(t) = shiftX(t) + totStrain(t-1);
    else
        totStrain(t) = shiftX(t);
    end
end


time = 1:1:numSteps;
time = time';

figure;
plot(time(1:numSteps), shiftX(1:numSteps),'b:o');

figure;
plot(time, totShift, 'r:o');
title('Displacement vs time');
xlabel('Time (s)');
ylabel('Displacement (pixels)');

totStrainNorm = totStrain - mean(totStrain);

figure;
plot(time, totShiftNorm, 'b:o');
title('Displacement vs time');
xlabel('Time (s)');
ylabel('Displacement (pixels)');

fitStrain = fit(time(1:numSteps), totStrainNorm(1:numSteps), 'sin1');

figure;
plot(fitStrain)
hold on
plot(time, totStrainNorm, 'b:o');
title('Displacement vs time');
xlabel('Time (s)');
ylabel('Displacement (pixels)');
hold off

% fitStrain;
coStrain = coeffvalues(fitStrain);

ampStrain= coStrain(1);
% cnf = confint(fitStrain);