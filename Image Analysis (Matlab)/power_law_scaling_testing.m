% test power law scaling fitting
gc = 0.9;
gam = [0.1 0.2 0.3 0.4 0.5 0.6 0.65 0.7 0.75 0.8 0.85 0.87 0.88 0.89];
life = 2 * (gc-gam).^-1.3;

figure;
plot(gam,life,'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 16);


figure;
loglog(gc-gam, life,'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 16);

myfit = fit(log((gc-gam))', log(life)', 'poly1')
figure;
hold on
plot(log(gc-gam), -1.3* log(0.90-gam) + 0.6931)
plot(log(gc-gam), log(life),'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 16)
hold off
