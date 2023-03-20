

% sine with gaussian smoothing

%v2: making sure gaussian is right
%v3: fixing gaussian and applying left side
%v4: reduce to total of 2*period for time

num_points = 1000;
amplitude = 2;
sig = 0.05;
reduction = 0.07;

u1 = num_points/2 + (num_points*reduction);
u2 = (3/2)*num_points - (num_points * reduction);

%% square wave
square_wave = zeros(num_points*2,1);

% % full square wave version
% for i = num_points:1:2*num_points
%     square_wave(i) = amplitude;
% end

% reduced square wave version
for i = u1:1:u2
    square_wave(i) = amplitude;
end

window = square_wave;
%% square wave with combined wave with gaussian

combined_wave = zeros(num_points*2, 1);
gaussian2 = zeros(num_points*2,1);
gaussian1 = zeros(num_points*2,1);


for i = 1:1:u1
    gaussian1(i) = amplitude * exp(-((i-u1)*(1/num_points)).^2/(2*sig^2));
    window(i) = gaussian1(i);
end

for i = u2:1:2*num_points
    gaussian2(i) = amplitude * exp(-((i-u2)*(1/num_points)).^2/(2*sig^2));
    window(i) = gaussian2(i);
end

for i = 1:2*num_points
    combined_wave(i) = sin(i/num_points*2*pi) * window(i);
end

for i = 1:2*num_points
    sine_curve(i) = amplitude* sin(i/num_points*2*pi);
end

t = (1:2*num_points) * 1/num_points;

% figure;
% plot(t, gaussian1, 'r:o')
figure;
plot(t, window, 'g:o')
figure;
plot(t, combined_wave, 'b:o', 'MarkerSize', 1)
% hold on
% plot(t, sine_curve, 'r:o', 'MarkerSize', 1)

% %% full gaussian
% f_gaussian = zeros(num_points*2,1);
% for i = 1:1:3*num_points
%     f_gaussian(i) = amplitude * exp(-((i-u2)/num_points).^2/(2*sig^2));
% end
% 
% figure;
% plot(t, f_gaussian, 'b:o');
