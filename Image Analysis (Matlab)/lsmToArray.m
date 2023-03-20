function imArray = lsmToArray(filename)

% filename = ['C:\Users\Eric\Documents\Xerox Data\' ...
%     '0.5Hz_1Amp_5-27-16.mdb\TimeSeries_2sec.lsm'];

% C:\Users\Eric\Documents\Xerox Data\0.5Hz_1Amp_5-27-16.mdb\zstack_1.lsm

% 'C:\Users\Eric\Documents\Xerox Data\0.5Hz 0.5V 6-27-16.mdb\zstack1.lsm'

zsiz = 100;

imArray = zeros(512,512, zsiz);

cnt = 1;
for i = 1:1:zsiz
    imArray(:, :, cnt) = imread(filename, 2*i -1);
    cnt = cnt +1;
end
