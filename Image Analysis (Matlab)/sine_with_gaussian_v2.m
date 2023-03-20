

% sine with gaussian

%v2: making sure gaussian is right

num_points = 1000;
amplitude = 2;
sig = 0.03;
reduction = 1/20;

% %% just sine
% x = (1:1:num_points) * 1 / num_points;
% 
% figure;
% plot(x, amplitude * sin(x*(2*pi)), 'r:o')
% xlim([-0.5, 1.5])
% ylim([-amplitude, amplitude])
% 
% %% gaussian
% x = -1:0.01:1;
% sig = 1;
% u = 0.5;
% 
% figure;
% plot(x, amplitude * exp(-(x - u).^2/ (2* sig^2)), 'b:o')

%% square wave
t = (-num_points+1:1:2*num_points) * (1/num_points);
square_wave = zeros(num_points*3,1);

% % full square wave version
% for i = num_points:1:2*num_points
%     square_wave(i) = amplitude;
% end

% reduced square wave version
for i = (num_points + num_points * reduction):1:(2*num_points - num_points*reduction)
    square_wave(i) = amplitude;
end

window = square_wave;

% %% square wave with sine wave
% sine_w_square = zeros(length(t),1);
% for i = 1:length(square_wave)
%     sine_w_square(i) = square_wave(i) * sin(t(i)*2*pi);
% end
% 
% figure;
% plot(t, sine_w_square, 'b:o')

%% square wave with combined wave with gaussian
% u1 = num_points
u2 = 2*num_points - (num_points * reduction);
combined_wave = zeros(num_points*3, 1);
gaussian = zeros(num_points*3,1);

% for i = 1:length(t)
%     gaussian(i) = amplitude * exp(-(t(i-u)).^2/(2*sig));
% end

for i = (2*num_points - num_points*reduction):1:3*num_points
    gaussian(i) = amplitude * exp(-(t(i)-t(u2)).^2/(2*sig^2));
    window(i) = gaussian(i);
end

for i = 1:length(t)
    combined_wave(i) = sin(t(i)*2*pi) * window(i);
end

for i = 1:length(t)
    sine_curve(i) = amplitude* sin(t(i)*2*pi);
end


figure;
plot(t, gaussian, 'r:o')
figure;
plot(t, window, 'g:o')
figure;
plot(t, combined_wave, 'b:o', 'MarkerSize', 1)
hold on
plot(t, sine_curve, 'r:o', 'MarkerSize', 1)

%% full gaussian
f_gaussian = zeros(num_points*3,1);
for i = 1:1:3*num_points
    f_gaussian(i) = amplitude * exp(-(t(i)-t(u2)).^2/(2*sig^2));
end

figure;
plot(t, f_gaussian, 'b:o');
