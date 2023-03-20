% plot lifetime vs amplitude
%
% Author: Eric
% Date: 6-8-18


% 6-3-18 data
% lifetimes in shear cycles
lifetimes = [36 56 58 272 267];
% amplitudes in V
amplitudes = [0.4 0.5 0.6 0.8 1.0];

% 

figure;
hold on
plot(amplitudes, lifetimes,'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 12);

% title('Training','FontSize', 20);
xlabel('Shear cycles','FontSize', 18);
ylabel('lifetimes','FontSize', 18);
% ylim([0.02 0.05])
% xlim([0 550])
% axis([0 max(t) 0.02 0.14]);

xt = get(gca,'XTick');
set(gca, 'FontSize', 16)

hold off