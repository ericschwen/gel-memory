


strain_amps = [1.0, 1.0, 0.6, 2.0, 1.4, 1.2];
lifetime = [51, 57, 63, 83, 93, 9];

x = [0.8, 1.0, 1.2, 1.4, 1.8, 2.4];
y = [5, 5, 8, 27, 51, 886];

figure;
hold on;
% scatter(strain_amps(1:end), lifetime(1:end), 'b', 'MarkerFaceColor', 'b', 'DisplayName', '0.33Hz')

plot(x*(4.1/30), y, 'b:o', 'MarkerFaceColor', 'b')
title('Mobile clusters','FontSize', 20);
xlabel('Strain amplitude','FontSize', 18);
ylabel('Largest mobile cluster','FontSize', 18);

trainingAmplitude = 0.133;
plot(ones(60,1) * trainingAmplitude, 1:1:60, 'g--', 'DisplayName', 'Training strain \gamma_0');

% xlim([0 510])
ylim([0, 60])
leg = legend('Location', 'southeast');
set(leg, 'FontSize', 16)



xt = get(gca,'XTick');
set(gca, 'FontSize', 16);

hold off