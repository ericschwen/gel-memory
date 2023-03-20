function f = sum_squares_exp_decay(vars, data)
% sum_squares_exp_decay
% Calculates the sum of the squares of the difference between the data
% and an exponential decay model with an offset constant.
% Model:
% y = a * exp(-lamb * t) + b
% 
% Author: Eric
% Date: 6-6-18

% Set chosen values for a, lamb, b
a = vars(1);
lamb = vars(2);
b = vars(3);

% Calculate difference between data and expected
t = 1:length(data);
expected = vars(1)*exp(-vars(2)* t) + vars(3);

diff = data - expected;
square_diff = diff.^2;

f = sum(square_diff);
end



% % Make a function handle to calculate expected value
% % y = a * exp(-lamb * t) + b
% expect = @(vars, data) vars(1)*exp(-vars(2)* data) + vars(3);
