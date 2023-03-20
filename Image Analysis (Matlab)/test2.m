

x = [0:1:10];
plot(x, -(x-5).^2+25, 'ro-')
xlim([0 10])
xlabel('\gamma_0')
ylabel('Training Effectiveness')