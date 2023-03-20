% function gr1D
% Calculates g(r) for a collection of particles.
%
% Mod. History:
%   v6: modifiy to be able to take input from linked file. 9-15-17
%   v7: modify normalization. fix i think. 4-29-19


% filein = 'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\1.0\p400\u_combined\linked.csv';
filein = 'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\ampsweep\1.2\u_combined_o5\linked_mod.csv';
fileout = [filein(1:length(filein) - 4), '_g_r.csv'];
% filein = ['G:\BackUp_Colloids_Data\XEROX\2016_02_23.mdb\' num2str(pcnt) '_immediate_2enhanced_bp4_feature.csv'];
% fileout = ['G:\BackUp_Colloids_Data\XEROX\2016_02_23.mdb\' num2str(pcnt) '_immediate_2enhanced_bp4_g_r.csv'];
data=xlsread(filein);

rc = 6; %calculation range (Microns)
dr= 0.1; %radius step (microns)
% grc=zeros(rc/dr,2); %declare output data(radius,g(r))

% select only frame 0 (frame column = 10)
condition = data(:,10) ~= 0;
data(condition,:) = [];

% Load x, y, z data and convert distances into um.
data(:,1)=data(:,1)*(0.125); % x[px] to x[um]
data(:,2)=data(:,2)*(0.125); % y[px] to y[um]
data(:,3)=data(:,3)*(0.12); % z[px] to z[um]

xmin = min(data(:,1));
ymin = min(data(:,2));
zmin = min(data(:,3));

xmax=max(data(:,1));
ymax=max(data(:,2));
zmax=max(data(:,3));

% Take only data near center for calculation. May want to increase size of
% center to reduce noise? Could also skew data though by reducing number of
% far away particles (if you go off the edge of the image).
% Why divide by 8 specifically? Why not include z column in calculations?
aNumber = 2;
center=data(data(:,1) > xmin + rc/aNumber & data(:,1) < xmax-rc/aNumber & ...
    data(:,2) > ymin + rc/aNumber & data(:,2) < ymax -rc/aNumber & data(:,3) > zmin + rc/aNumber & data(:,3) < zmax -rc/aNumber,1:3);
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
    shifted_vector=data(:,1:3)-repmat(center(i,:),length(data),1);
    shifted_vector=abs(shifted_vector);%take the absolute value.
    % Limit to selected max range rc.
    shifted_vector=shifted_vector( shifted_vector(:,1)<rc & shifted_vector(:,2)<rc & shifted_vector(:,3)<rc,:);
    distance=zeros(length(shifted_vector),1);

    for cnt=1:size(shifted_vector,1)
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

test_unnorm = gr(:,2);

norm_gr = ones(length(gr),2);
for cnt=1:length(gr) % Normalization of g_r
    norm_gr(cnt,1) = gr(cnt,1);
    norm_gr(cnt,2)=(gr(cnt,2)/(4/3*pi*(gr(cnt,1))^2)*dr)/(length(center)* (length(center)+1));
%     norm_gr(cnt)=(gr(cnt,2)/gr(cnt,1)^2*dr)/(length(center)* (length(center)+1))
%         gr(cnt,2) = (gr(cnt,2))/(gr(cnt,1)^2 * length(data));
end


csvwrite(fileout,norm_gr);

% Find max of gr
[~,max_index] = max(norm_gr(:,2));
gr_peak = norm_gr(max_index,1); % Location of max gr in um.


figure;
plot(norm_gr(:,1), norm_gr(:, 2), 'b:o');
title('G(r)');
xlabel('r (um)');
ylabel('G(r)');
% hold on;

% figure;
% plot(gr(:,1), test_unnorm(:), 'b:o');
% title('G(r)');
% xlabel('r (um)');
% ylabel('G(r)');
% % hold on;

% figure;
% plot(gr(:,1), norm_gr(:), 'b:o');
% title('G(r)');
% xlabel('r (um)');
% ylabel('G(r)');
% % hold on;
