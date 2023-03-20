function [kx, ky] = build_freq2d(arr)
[rx, ry] = meshgrid(1:size(arr,1),1:size(arr,2));
kx = fftfreq(rx-1, size(arr, 1));
ky = fftfreq(ry-1, size(arr, 2));
end