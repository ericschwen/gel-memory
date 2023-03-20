% plot lifetime vs amplitude
%
% Author: Eric
% Date: 6-8-18

% Conversion from volts to strain
v2s = 4.1/30.;

% 6-28-18 data
% amplitudes in V
amplitudes628 = [0.4 0.6 0.8 1.0 1.2];
% lifetimes in shear cycles
lifetimes628 = [48 68 64 106 179];

% 6-3-18 data
% lifetimes in shear cycles
lifetimes63 = [36 56 58 272 267];
% amplitudes in V
amplitudes63 = [0.4 0.5 0.6 0.8 1.0];

% 5-21-18 data
amplitudes521 = [0.1 0.4 0.6 0.6 0.8 1.0 1.0 1.0 1.4];
lifetimes521 = [31 110 17 31 248 78 85 118 224];

% 5-21-18 first 8 data taken
amplitudes521_8 = [0.1 0.6 0.6 1.0 1.0 1.0 1.4];
lifetimes521_8 = [31 17 31 78 85 110 224];

% 5-21-18 only triain well
amplitudes521_well = [0.1 0.6 1.0 1.0 1.0 1.4];
lifetimes521_well = [22 29 78 85 110 224];

figure;
hold on
plot(amplitudes63, lifetimes63,'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 16);
% plot(amplitudes521_8, lifetimes521_8,'r.', 'MarkerFaceColor', 'r', 'MarkerSize', 12);
plot(amplitudes521_well, lifetimes521_well,'r.', 'MarkerFaceColor', 'r', 'MarkerSize', 16);
plot(amplitudes628, lifetimes628,'g.', 'MarkerFaceColor', 'g', 'MarkerSize', 16);

% title('Training','FontSize', 20);
xlabel('Training strain (V)','FontSize', 18);
ylabel('lifetimes','FontSize', 18);
% ylim([0.02 0.05])
% xlim([0 550])
% axis([0 max(t) 0.02 0.14]);

% % Plot vertical line for training amplitude
trainingAmplitude = 0.9;
plot(ones(100,1) * trainingAmplitude, linspace(1, 500, 100), 'b--');
trainingAmplitude = 1.2;
plot(ones(100,1) * trainingAmplitude, linspace(1, 500, 100), 'r--');

trainingAmplitude = 1.4;
plot(ones(100,1) * trainingAmplitude, linspace(1, 500, 100), 'g--');

xt = get(gca,'XTick');
set(gca, 'FontSize', 16)

hold off

%%%%%%% Fixing volts to strain
figure;
hold on
plot(amplitudes63*v2s, lifetimes63,'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 16);
% plot(amplitudes521_8, lifetimes521_8,'r.', 'MarkerFaceColor', 'r', 'MarkerSize', 12);
plot(amplitudes521_well*v2s, lifetimes521_well,'r.', 'MarkerFaceColor', 'r', 'MarkerSize', 16);
plot(amplitudes628*v2s, lifetimes628,'g.', 'MarkerFaceColor', 'g', 'MarkerSize', 16);

% title('Training','FontSize', 20);
xlabel('Training strain \gamma_0','FontSize', 18);
ylabel('Lifetime \tau','FontSize', 18);
% ylim([0.02 0.05])
% xlim([0 550])
% axis([0 max(t) 0.02 0.14]);

% % Plot vertical line for training amplitude
trainingAmplitude = 0.9*v2s;
plot(ones(100,1) * trainingAmplitude, linspace(1, 500, 100), 'b--');
trainingAmplitude = 1.2*v2s;
plot(ones(100,1) * trainingAmplitude, linspace(1, 500, 100), 'r--');

trainingAmplitude = 1.4*v2s;
plot(ones(100,1) * trainingAmplitude, linspace(1, 500, 100), 'g--');

xt = get(gca,'XTick');
set(gca, 'FontSize', 16)

hold off


