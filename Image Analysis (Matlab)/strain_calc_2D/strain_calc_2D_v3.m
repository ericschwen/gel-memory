% 2D strain calc
function [ampStrain] = strain_calc_2D(file_path)

% Strain calculation

% Takes a file path as an input and uses the results from
% shear_band_calculation_v6 to plot the total strain and calculate strain
% amplitude.

% Used on the bottom plate, this can calculate the strain for a particular
% applied voltage for the piezoelectric.

%% Modification History
% v2: Changed to take a modified number of time steps. 2/7/17
% v3: Try to remove drift in total strain. 2/8/17

%% Import matPIV results
% file_path = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.4V 8-17-16.mdb\xyts2_5075.lsm';
filebase = file_path(1:length(file_path)-4);
strainpathX = [filebase '_v_fieldX1.csv'];

shiftX= xlsread(strainpathX);
numtframes = 10000;
numSteps = numtframes-1;
totStrain = zeros(numSteps,1);

for t = 1:1:numSteps
    if t~=1
        totStrain(t) = shiftX(t) + totStrain(t-1);
    else
        totStrain(t) = shiftX(t);
    end
end

%% Plotting
time = 1:1:numSteps;
time = time';

% Plot the incremental strains over time
figure;
plot(time(1:numSteps), shiftX(1:numSteps),'b:o');

% Plot the total strain over time
figure;
plot(time, totStrain, 'r:o');
title('Total Displacement vs time');
xlabel('Time (s)');
ylabel('Displacement (pixels)');

% Subtract mean to get sine curve centered around y=0
totStrainNorm = totStrain - mean(totStrain);

% Plot the mean total displacement over time
figure;
plot(time, totStrainNorm, 'b:o');
title('Mean Total Displacement vs time');
xlabel('Time (s)');
ylabel('Displacement (pixels)');

%% Fit the normalized total strain to a sine curve
fitStrainDrift = fit(time(1:numSteps), totStrainNorm(1:numSteps), 'poly1');
coStrainDrift = coeffvalues(fitStrainDrift);


totStrainNorm_noDrift = zeros(length(totStrainNorm), 1);
for i = 1:length(totStrainNorm)
    totStrainNorm_noDrift(i) = totStrainNorm(i) - coStrainDrift(1) * (i) + coStrainDrift(2);
end

totStrainNorm_noDrift = totStrainNorm_noDrift - mean(totStrainNorm_noDrift);

fitStrain_noDrift = fit(time(1:numSteps), totStrainNorm_noDrift(1:numSteps), 'sin1');

% Plot the normalized total strain and the fit curve
figure;
plot(fitStrain_noDrift)
hold on
plot(time, totStrainNorm_noDrift, 'b:o');
title('Displacement vs time');
xlabel('Time (s)');
ylabel('Displacement (pixels)');
hold off

%% Set the strain amplitude for output
coStrain = coeffvalues(fitStrain_noDrift);

ampStrain= coStrain(1);
% cnf = confint(fitStrain);
end