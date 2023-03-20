% function gr3D

rc = 4; % calculation range
dr=0.1; % radius step

x_space=(-rc:dr:rc)'; % x_space to do the histogram.
y_space=(-rc:dr:rc)'; % Note: length(y_space) = 2 * rc/dr + 1
z_space=(-rc:dr:rc)';

% For 201x201x201 space, over 8 million positons. ~1352 particles.  

gr=zeros(length(x_space), length(y_space), length(z_space)); % declare output data(radius,g(r))
tempgr=zeros(length(x_space), length(y_space), length(z_space));%temp g(r) to manipulate in the for-loop


filein = 'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\testing 0.6 postsweep stack\zstack_post_train_bpass3D_o5\100\positions_15-15-11.csv';
fileout = [filein(1:length(filein) - 4), '_g_r_3d.csv'];
data=xlsread(filein);

% My file is particle #, x, y, z. Start with data(:,2) not data(:,1).
data(:,2)=data(:,2)*(0.127); % Or 0.127?
data(:,3)=data(:,3)*(0.127);
data(:,4)=data(:,4)*(0.12);

xmax=max(data(:,2));
ymax=max(data(:,3));
zmax=max(data(:,4));

% Select data only in center
center=data(data(:,2) > rc/2 & data(:,2) < xmax-rc/2 & data(:,3) > rc/2 & data(:,3) < ymax-rc/2 & data(:,4) > rc/2 & data(:,4) < zmax-rc/2,2:4);
center=sortrows(center,3); % Sort for some reason? don't need it to be sorted, specifically.


for i=1:1:length(center)

    shifted_vector=data(:,2:4)-repmat(center(i,:),length(data),1);%calculate the relative position vector
    % shifted_vector=abs(shifted_vector);%take the absolute value.
    shifted_vector=shifted_vector(shifted_vector(:,1)<rc & shifted_vector(:,2)<rc & shifted_vector(:,3)<rc & shifted_vector(:,1)> -rc & shifted_vector(:,2) > -rc & shifted_vector(:,3) > -rc,:);

    tempgr=hist3D(shifted_vector, x_space, y_space, z_space);
    
    gr = gr+tempgr;

    if mod(i,1000)==0
        fprintf([num2str(i) '/' num2str(length(center)) '\n']);
    end

end

% csvwrite(fileout,gr);


 
% % Remove the term with distance = 0?
% for cnt1=1:1:size(gr, 1)
%     for cnt2 = 1:1: size(gr, 2)
%         for cnt3 = 1:1:size(gr, 3)
% %             gr(cnt1, cnt2, cnt3) =  gr(cnt1, cnt2, cnt3)/((x_space(cnt1)^2+ y_space(cnt2)^2+ z_space(cnt3)^2)*length(center));
%             if (x_space(cnt1)^2+ y_space(cnt2)^2+ z_space(cnt3)^2) == 0
%                 gr(cnt1, cnt2, cnt3) = 0;
%             end
%         end
%     end
%     
% %     grc(cnt,2)=(grc(cnt,2)/(x_space(cnt))^2)/length(center)* 3.8;
% %         gr(cnt,2) = (gr(cnt,2))/(gr(cnt,1)^2 * length(data));
% end

% Quicker removal of terms with distance = 0 (symmetrical only)
gr((size(gr,1)+1)/2,(size(gr,1)+1)/2,(size(gr,1)+1)/2) = 0;

% Get xy g(r)
gr_xy = zeros(size(gr,1),size(gr,2));

% Averaged over just middle few z
averagingRange = 5;
for z = (length(gr(:,3))-1)/2-averagingRange:1:(length(gr(:,3))-1)/2+averagingRange
    gr_xy = gr_xy + gr(:,:,z);
end

% Colormap of gr_xy
figure;
imagesc(gr_xy,'CDataMapping','scaled')
daspect([1, 1, 1])
colorbar

% Get xz g(r)
gr_xz = zeros(size(gr,1),1,size(gr,3));

% Averaged over just middle few y
averagingRange = 5;
for y = (length(gr(:,2))-1)/2-averagingRange:1:(length(gr(:,2))-1)/2+averagingRange
    gr_xz = gr_xz + gr(:,y,:);
end

gr_xz= permute(gr_xz, [1 3 2]);

% Colormap of gr_xz
figure;
imagesc(gr_xz,'CDataMapping','scaled')
daspect([1, 1, 1])
colorbar

% Get yz g(r)
gr_yz = zeros(1,size(gr,2),size(gr,3));

% Averaged over just middle few z
averagingRange = 5;
for x = (length(gr(:,1))-1)/2-averagingRange:1:(length(gr(:,1))-1)/2+averagingRange
    gr_yz = gr_yz + gr(x,:,:);
end

gr_yz= permute(gr_yz, [2 3 1]);

% Colormap of gr_yz
figure;
imagesc(gr_yz,'CDataMapping','scaled')
daspect([1, 1, 1])
colorbar

% end