function gr3D

rc = 10; % calculation range
dr=0.1; % radius step

x_space=(-rc:dr:rc)'; % x_space to do the histogram.
y_space=(-rc:dr:rc)'; % Note: length(y_space) = 2 * rc/dr + 1
z_space=(-rc:dr:rc)';

gr=zeros(length(x_space), length(y_space), length(z_space)); % declare output data(radius,g(r))
tempgr=zeros(length(x_space), length(y_space), length(z_space));%temp g(r) to manipulate in the for-loop


filein = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\0.5Hz 0.1V 9-12-16.mdb\ts5_bpass_normalized_static_160\ts5_features.csv';
fileout = [filein(1:length(filein) - 4), '_g_r_3d.csv'];
data=xlsread(filein);

data(:,1)=data(:,1)*(0.125); % Or 0.127?
data(:,2)=data(:,2)*(0.125);
data(:,3)=data(:,3)*(0.135);

xmax=max(data(:,1));
ymax=max(data(:,2));
zmax=max(data(:,3));

% Select data only in center
center=data(data(:,1) > rc/2 & data(:,1) < xmax-rc/2 & data(:,2) > rc/2 & data(:,2) < ymax-rc/2 & data(:,3) > rc/2 & data(:,3) < zmax-rc/2,1:3);
center=sortrows(center,3); % Sort for some reason? don't need it to be sorted, specifically.


% space = repmat(x_space, 1, 3);
for i=1:1:length(center)

    shifted_vector=data(:,1:3)-repmat(center(i,:),length(data),1);%calculate the relative position vector
    % shifted_vector=abs(shifted_vector);%take the absolute value.
    shifted_vector=shifted_vector(shifted_vector(:,1)<rc & shifted_vector(:,2)<rc & shifted_vector(:,3)<rc & shifted_vector(:,1)> -rc & shifted_vector(:,2) > -rc & shifted_vector(:,3) > -rc,:);
    
    % distance=zeros(length(shifted_vector),1);

    % for cnt=1:size(shifted_vector,1),
    % distance(cnt,1)=norm(shifted_vector(cnt,1:3));
    % end

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
for i = 1:1:size(gr,3)
    gr_xy = gr_xy + gr(:,:,i);
end

figure;
image(gr_xy,'CDataMapping','scaled')
colorbar

% figure;
% plot(x_space, gr(:, 1), 'b:o');
% title('G(r)');
% xlabel('r (um)');
% ylabel('G(r)');

csvwrite(fileout, gr);

% plot(gr(:,1), gr(:, 2));

end