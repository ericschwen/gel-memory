function [kx, ky, kz] = build_freq3d(arr)
[rx, ry, rz] = meshgrid(1:size(arr,1),1:size(arr,2),1:size(arr,3));
kx = fftfreq(rx-1, size(arr, 1));
ky = fftfreq(ry-1, size(arr, 2));
kz = fftfreq(rz-1, size(arr, 3));
end