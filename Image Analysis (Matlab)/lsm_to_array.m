% filename = 'C:\Users\Eric\Documents\Xerox Data\0.5Hz_1Amp_5-27-16.mdb\zstack_1.lsm';


% filename = ['C:\Users\Eric\Documents\Xerox Data\Meeras Data\'...
%     '2016_04_27\0.5V_1Hz.mdb\zstack4.lsm']

filename = 'C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 1.4V 7-11-16.mdb\zstack1.lsm';

zsiz = 100;

imarray = zeros(512,512, zsiz);

cnt = 1;
for i = 1:1:zsiz
    imarray(:, :, cnt) = imread(filename, 2*i -1);
    cnt = cnt +1;
end
