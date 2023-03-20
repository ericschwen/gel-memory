


filein = 'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\0.6\ampsweep\0.2\u_combined_o5\linked15_mod.csv';
% fileout = [filein(1:length(filein) - 4), '_g_r_3d.csv'];
[data, txt]=xlsread(filein);
% txt is column names


% count number of displacements
count = 0;
for i = 1:length(data)
    % count only non-zero displacements
    if data(i, 18)>0
        count = count + 1;
    end
end

disp_data = zeros(count, size(data,2));

count = 1;
for i = 1:length(data)
    % read only non-zero displacements
    if data(i, 18)>0
        disp_data(count, :) = data(i,:);
        count = count+1;
    end
end

% could add part to get only specific frame

% create histogram space
dr = 0.2;
rc = 10;
x_space=(-rc:dr:rc)'; % x_space to do the histogram.
y_space=(-rc:dr:rc)'; % Note: length(y_space) = 2 * rc/dr + 1
z_space=(-rc:dr:rc)';

gr=zeros(length(x_space), length(y_space), length(z_space)); % declare output data(radius,g(r))

for i=1:1:length(disp_data)
    % read in dxum_adj, dyum_adj, dzum_adj for each displacement
    disp_vector = disp_data(i, 19:21);
    disp_vector_px= [disp_vector(1)/.127, disp_vector(2)/.127,disp_vector(3)/.12];
    tempgr=hist3D_v2(disp_vector_px, x_space, y_space, z_space);
    
    gr = gr+tempgr;

    if mod(i,1000)==0
        fprintf([num2str(i) '/' num2str(length(disp_data)) '\n']);
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