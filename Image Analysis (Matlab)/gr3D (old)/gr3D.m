function gr3D
% j = 1;
% for k = -0.02:0.004:0.02
pathlist = ...
    {'1'...
    '2'....
    '3' ...
    '4' ...
    '5'...
    };

bigpathlist = ...
  { 'sphere' ...
%   'square' ...
  };
rc = 2.5;%calculation range
dr=0.05;%radius step
% gr=zeros(2*rc/dr+1,2*rc/dr+1, 2*rc/dr+1);
for bpcnt = 1:1:1
    fileout2 = ['F:\650nm_silica_RI_1.mdb\' char(bigpathlist(bpcnt)) '.csv'];
    gr=zeros(2*rc/dr+1,2*rc/dr+1, 2*rc/dr+1);
for pcnt= 1:1:5
filein = ['F:\650nm_silica_RI_1.mdb\dz_015_' char(pathlist(pcnt)) '_RI2t_enhanced_bp_' char(bigpathlist(bpcnt)) '.csv'];
fileout = ['F:\650nm_silica_RI_1.mdb\dz_015_' char(pathlist(pcnt)) '_RI2t_enhanced_bp_' char(bigpathlist(bpcnt)) 'gr.csv'];
data=load(filein);

% rc = 2.5;%calculation range
% dr=0.05;%radius step
grc=zeros(2*rc/dr+1,2*rc/dr+1, 2*rc/dr+1);%declare output data(radius,g(r))

data(:,1)=data(:,1)*(0.125);
data(:,2)=data(:,2)*(0.125);
data(:,3)=data(:,3)*(0.135);

xmax=max(data(:,1));
ymax=max(data(:,2));
zmax=max(data(:,3));

center=data(data(:,1) > rc/2 & data(:,1) < xmax & data(:,2) > rc/2 & data(:,2) < ymax & data(:,3) > rc/2 & data(:,3) < zmax -rc/2,1:3);
center=sortrows(center,3);

% gr=zeros(rc/dr,4);%declare the g(r).
% tempgr=zeros(2*rc/dr+1,2*rc/dr+1, 2*rc/dr+1);%temp g(r) to manipulate in the for-loop
x_space=(-rc:dr:rc)';%x_space to do the histogram.
y_space=(-rc:dr:rc)';
z_space=(-rc:dr:rc)';
% space = repmat(x_space, 1, 3);
for i=1:length(center),

shifted_vector=data(:,1:3)-repmat(center(i,:),length(data),1);%calculate the relative position vector
% shifted_vector=abs(shifted_vector);%take the absolute value.
shifted_vector=shifted_vector(shifted_vector(:,1)<rc & shifted_vector(:,2)<rc & shifted_vector(:,3)<rc &shifted_vector(:,1)>-rc & shifted_vector(:,2)>-rc & shifted_vector(:,3)>-rc,:);
% distance=zeros(length(shifted_vector),1);

% for cnt=1:size(shifted_vector,1),
% distance(cnt,1)=norm(shifted_vector(cnt,1:3));
% end

tempgr=hist3D(shifted_vector, x_space, y_space, z_space);
grc = grc+tempgr;

if mod(i,1000)==0
    fprintf([num2str(i) '/' num2str(length(center)) '\n']);
end

end
gr = gr + grc;
csvwrite(fileout,grc);
end

% end
% gr(:,1)=x_space';
% 
for cnt1=1:size(gr, 1)
    for cnt2 = 1:1: size(gr, 2)
        for cnt3 = 1:1:size(gr, 3)
%             gr(cnt1, cnt2, cnt3) =  gr(cnt1, cnt2, cnt3)/((x_space(cnt1)^2+ y_space(cnt2)^2+ z_space(cnt3)^2)*length(center));
            if (x_space(cnt1)^2+ y_space(cnt2)^2+ z_space(cnt3)^2) == 0
                gr(cnt1, cnt2, cnt3) = 0;
            end
        end
    end
    
%     grc(cnt,2)=(grc(cnt,2)/(x_space(cnt))^2)/length(center)* 3.8;
%         gr(cnt,2) = (gr(cnt,2))/(gr(cnt,1)^2 * length(data));
end



csvwrite(fileout2, gr);
% plot(gr(:,1), gr(:, 2));
hold on ; 
end

end
% end
% legend('0.1','0.105', '0.11', '0.115', '0.12', '0.125', '0.13', '0.135', '0.14', '0.145', '0.15'); 
% end