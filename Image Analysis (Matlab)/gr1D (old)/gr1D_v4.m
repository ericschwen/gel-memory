function gr1D

filein = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\0.5Hz 0.1V 9-12-16.mdb\ts5_bpass_normalized_static_160\ts5_features.csv';
fileout = [filein(1:length(filein) - 4), '_g_r.csv'];
% filein = ['G:\BackUp_Colloids_Data\XEROX\2016_02_23.mdb\' num2str(pcnt) '_immediate_2enhanced_bp4_feature.csv'];
% fileout = ['G:\BackUp_Colloids_Data\XEROX\2016_02_23.mdb\' num2str(pcnt) '_immediate_2enhanced_bp4_g_r.csv'];
data=xlsread(filein);

rc = 6; %calculation range (Microns)
dr= 0.1; %radius step (microns)
% grc=zeros(rc/dr,2); %declare output data(radius,g(r))

% Load x, y, z data and convert distances into um.
data(:,2)=data(:,2)*(0.127);
data(:,3)=data(:,3)*(0.127);
data(:,4)=data(:,4)*(0.135);

xmax=max(data(:,1));
ymax=max(data(:,2));
zmax=max(data(:,3));

% Take only data near center for calculation. May want to increase size of
% center to reduce noise? Could also skew data though by reducing number of
% far away particles (if you go off the edge of the image).
% Why divide by 8 specifically? Why not include z column in calculations?
aNumber = 2;
center=data(data(:,2) > rc/aNumber & data(:,2) < xmax-rc/aNumber & data(:,3) > rc/aNumber & data(:,3) < ymax -rc/aNumber & data(:,4) > rc/aNumber & data(:,4) < zmax -rc/aNumber,2:4);
% center = data(:, 1:3);
center=sortrows(center,3); % Sort center data by z height.

gr=zeros(rc/dr,2);%declare the g(r).
tempgr=zeros(rc/dr,1);%temp g(r) to manipulate in the for-loop
x_space=dr:dr:rc;%x_space to do the histogram.

for i=1:length(center)
    %calculate the relative position vector. (Calculate for every other
    %particle in one step with repmat)
    % repmat takes one row of the center matrix and repeats it for each other
    % row to make it the size of data. Then subtract to have distances.
    shifted_vector=data(:,2:4)-repmat(center(i,:),length(data),1);
    shifted_vector=abs(shifted_vector);%take the absolute value.
    % Limit to selected max range rc.
    shifted_vector=shifted_vector( shifted_vector(:,1)<rc & shifted_vector(:,2)<rc & shifted_vector(:,3)<rc,:);
    distance=zeros(length(shifted_vector),1);

    for cnt=1:size(shifted_vector,1),
        distance(cnt,1)=norm(shifted_vector(cnt,1:3));
    end

    % Calculate histogram for g_r for single particle
    tempgr=histc(distance',x_space); % Maybe use histcounts instead
    % Add single particle g_r to total
    gr(:,2)=gr(:,2)+tempgr';

    % if mod(i,1000)==0
    %     fprintf([num2str(i) '/' num2str(length(center)) '\n']);
    % end

end
% end
gr(:,1)=x_space';

for cnt=1:length(gr) % Normalization of g_r
    gr(cnt,2)=(gr(cnt,2)*2/(gr(cnt,1))^2)/(length(center)* (length(center)+1));
%         gr(cnt,2) = (gr(cnt,2))/(gr(cnt,1)^2 * length(data));
end

csvwrite(fileout,gr);

% Find max of gr
[~,max_index] = max(gr(:,2));
gr_peak = gr(max_index,1); % Location of max gr in um.


figure;
plot(gr(:,1), gr(:, 2), 'b:o');
title('G(r)');
xlabel('r (um)');
ylabel('G(r)');
% hold on;
end
% end
% legend('0.1','0.105', '0.11', '0.115', '0.12', '0.125', '0.13', '0.135', '0.14', '0.145', '0.15'); 
% end