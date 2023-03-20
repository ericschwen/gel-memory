% 2D Shear band calculation
file_path = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.4V 8-17-16.mdb\xyts2_5075.lsm';
filebase = file_path(1:length(file_path)-4);
strainpathX = [filebase '_v_fieldX1.csv'];

shiftX= xlsread(strainpathX);
totShift = zeros(99,1);

for t = 1:1:99
    if t~=1
        totShift(t) = shiftX(t) + totShift(t-1);
    else
        totShift(t) = shiftX(t);
    end
end


time = 1:1:99;
time = time* 0.090;
figure;
plot(time, shiftX,'b:o');

figure;
plot(time, totShift, 'r:o');