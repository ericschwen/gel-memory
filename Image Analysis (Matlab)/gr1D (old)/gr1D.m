function gr1D
% j = 1;
% for k = -0.02:0.004:0.02
% pathlist = ...
%     {'1'...
%     '2'....
%     '3' ...
%     '4' ...
%     '5'...
%     }
for pcnt= 1:1:4
filein = ['G:\BackUp_Colloids_Data\XEROX\2016_02_23.mdb\' num2str(pcnt) '_immediate_2enhanced_bp4_feature.csv'];
fileout = ['G:\BackUp_Colloids_Data\XEROX\2016_02_23.mdb\' num2str(pcnt) '_immediate_2enhanced_bp4_g_r.csv'];
data=load(filein);

rc = 20;%calculation range
dr= 0.2;%radius step
grc=zeros(rc/dr,2);%declare output data(radius,g(r))

data(:,1)=data(:,1)*(0.127);
data(:,2)=data(:,2)*(0.127);
data(:,3)=data(:,3)*(0.135);

xmax=max(data(:,1));
ymax=max(data(:,2));
zmax=max(data(:,3));

center=data(data(:,1) > rc/8 & data(:,1) < xmax-rc/8 & data(:,2) > rc/8 & data(:,2) < ymax -rc/8,1:3);
% center = data(:, 1:3);
center=sortrows(center,3);

gr=zeros(rc/dr,2);%declare the g(r).
tempgr=zeros(rc/dr,1);%temp g(r) to manipulate in the for-loop
x_space=dr:dr:rc;%x_space to do the histogram.

for i=1:length(center),

shifted_vector=data(:,1:3)-repmat(center(i,:),length(data),1);%calculate the relative position vector
shifted_vector=abs(shifted_vector);%take the absolute value.
shifted_vector=shifted_vector( shifted_vector(:,1)<rc & shifted_vector(:,2)<rc & shifted_vector(:,3)<rc,:);
distance=zeros(length(shifted_vector),1);

for cnt=1:size(shifted_vector,1),
distance(cnt,1)=norm(shifted_vector(cnt,1:3));
end

tempgr=histc(distance',x_space);
gr(:,2)=gr(:,2)+tempgr';

% if mod(i,1000)==0
%     fprintf([num2str(i) '/' num2str(length(center)) '\n']);
% end

end
% end
gr(:,1)=x_space';

for cnt=1:length(gr),
    gr(cnt,2)=(gr(cnt,2)*2/(gr(cnt,1))^2)/(length(center)* (length(center)+1));
%         gr(cnt,2) = (gr(cnt,2))/(gr(cnt,1)^2 * length(data));
end

csvwrite(fileout,gr);

plot(gr(:,1), gr(:, 2));
hold on;
end
end
% end
% legend('0.1','0.105', '0.11', '0.115', '0.12', '0.125', '0.13', '0.135', '0.14', '0.145', '0.15'); 
% end