%%%%%%%%%%%%%%%%%%%%
% Curve fitting experimentation
%%%%%%%%%%%%%%%%%%%%%%%

% Fs = 1000;                    % Sampling frequency
% T = 1/Fs;                     % Sample time
% L = 1000;                     % Length of signal
% t = (0:L-1)*T;                % Time vector
% % Sum of a 50 Hz sinusoid and a 120 Hz sinusoid
% x = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t); 
% y = x + 2*randn(size(t));     % Sinusoids plus noise
% plot(Fs*t(1:50),y(1:50))
% title('Signal Corrupted with Zero-Mean Random Noise')
% xlabel('time (milliseconds)')

% 
% time = (0:1000 - 1) / 1000;
% y = 0.7 * sin(2*pi*10*time);
% 
% plot(time(1:300), y(1:300), 'b');
% hold on;

% fit1 = fit(time.', y.', 'sin1');

% plot(time(1:300), fit1(1:300), 'r');
% 
% plot(fit1);

% x = (1:1:10);
% 
% y = x.^3 + 100;
% 
% % plot(x(1:100),y(1:100),'b')
% 
% fit1 = fit(x.',y.', 'fourier2')

x = linspace(1,100);
y = 5 + 7*sin(x);
myfittype = fittype('a+b*sin(x)',...
    'dependent',{'y'},'independent',{'x'},...
    'coefficients',{'a','b'})
myfit = fit(x',y',myfittype)
plot(myfit,x,y)

% x = linspace(1,100);
% y = 5 + 7*log(x);
% myfittype = fittype('a + b*log(x)',...
%     'dependent',{'y'},'independent',{'x'},...
%     'coefficients',{'a','b'})
% myfit = fit(x',y',myfittype)
% plot(myfit,x,y)
