function f = fftfreq(z, number)
%z = 0:number-1;
a = 2*pi*z/number;
f = 1.0*(a-2*pi*(a>pi));
end
