% function gr1D_multi_image_v1
% Calculates g(r) for a collection of particles. Averages the g(r)
% calculation over multiple subsequent images to get better SNR. Modified
% from gr1D_v8.
%
% Mod. History:

filein = 'E:\Gardner Data\piezo 7-31-20 overnight\ts-post-1-stacked\linked_peri_mod.csv';
% NOTE: Gardner data is binary. Need inteligent g_r eventually

fileout = [filein(1:length(filein) - 4), '_g_r.csv'];
data=xlsread(filein);

% Rough first pass at averaging. Establish all basic numbers for limits and
% normalization with example frame, then do g(r) calculation. In the future
% version I may do normalization frame by frame, but this should be close
% for now.

frame_column = 5; % Trackpy data: Set which data column will be checked for frame number
% frame_column = 5; % PERI dat: Set which data column will be checked for frame number
rc = 6; %calculation range (Microns)
dr= 0.1; %radius step (microns)
% grc=zeros(rc/dr,2); %declare output data(radius,g(r))

%%%%%%%%%
% select only frame 0 
condition = data(:,frame_column) ~= 3;
data(condition,:) = [];

% % Limit to only particles with reasonable radii (only for peri)
% radii_column = 4; % radii are in pixels
% min_radius = 0.7 / 0.127; % radius converted to pixels
% max_radius = 1.3 / 0.127; % radius converted to pixels
% condition2 = data(:, radii_column) > max_radius;
% data(condition2, :) = [];
% condition3 = data(:, radii_column) < min_radius;
% data(condition3, :) = [];

% Load x, y, z data and convert distances into um.
data(:,1)=data(:,1)*(0.127); % x[px] to x[um]
data(:,2)=data(:,2)*(0.127); % y[px] to y[um]
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
buffer_frac = 0.7;
center=data(data(:,1) > xmin + rc*buffer_frac & data(:,1) < xmax-rc*buffer_frac & ...
    data(:,2) > ymin + rc*buffer_frac & data(:,2) < ymax -rc*buffer_frac & ...
    data(:,3) > zmin + rc*buffer_frac & data(:,3) < zmax -rc*buffer_frac, 1:3);
% center = data(:, 1:3);
center=sortrows(center,3); % Sort center data by z height.

% Calculate number density for normalization
center_volume = ((xmax-rc*buffer_frac)-(xmin+rc*buffer_frac)) * ...
    ((ymax-rc*buffer_frac)-(ymin+rc*buffer_frac)) * ...
    ((zmax-rc*buffer_frac)-(zmin+rc*buffer_frac));
n_density = length(center)/center_volume;

gr=zeros(rc/dr,2); %declare the g(r).
tempgr=zeros(rc/dr,1); %temp g(r) to manipulate in the for-loop
x_space=dr:dr:rc; %x_space to do the histogram.
gr(:,1)=x_space';

% Now loop through frames and calculate g(r) for each
frame_first = 1;
frame_last = 100;
for frame=frame_first:frame_last
    % read in data
    data_current=xlsread(filein);
    % restrict to specific frame
    condition_current = data_current(:,frame_column) ~= frame;
    data_current(condition_current,:) = [];
    % x, y, z data convert distances into um.
    data_current(:,1)=data_current(:,1)*(0.127); % x[px] to x[um]
    data_current(:,2)=data_current(:,2)*(0.127); % y[px] to y[um]
    data_current(:,3)=data_current(:,3)*(0.12); % z[px] to z[um]
    % create array of valid particles in middle
    middle=data_current(data_current(:,1) > xmin + rc*buffer_frac & data_current(:,1) < xmax-rc*buffer_frac & ...
    data_current(:,2) > ymin + rc*buffer_frac & data_current(:,2) < ymax -rc*buffer_frac & ...
    data_current(:,3) > zmin + rc*buffer_frac & data_current(:,3) < zmax -rc*buffer_frac, 1:3);
    middle=sortrows(middle,3); % Sort center data by z height.
    
    for i=1:length(middle)
        %calculate the relative position vector. (Calculate for every other
        %particle in one step with repmat)
        % repmat takes one row of the center matrix and repeats it for each other
        % row to make it the size of data. Then subtract all other positions to have distances.
        shifted_vector=data_current(:,1:3)-repmat(middle(i,:),length(data_current),1);
        shifted_vector=abs(shifted_vector); %take the absolute value to get positive distances.

        % Limit to selected max range rc.
        shifted_vector=shifted_vector(shifted_vector(:,1)<rc & shifted_vector(:,2)<rc & shifted_vector(:,3)<rc,:);
        distance=zeros(length(shifted_vector),1);

        for cnt=1:size(shifted_vector,1)
            distance(cnt,1)=norm(shifted_vector(cnt,1:3));
        end

        % Calculate histogram for g_r for single particle
        tempgr=histc(distance',x_space); % Maybe use histcounts instead
        % Add single particle g_r to total
        gr(:,2)=gr(:,2)+tempgr';
    end
end
test_unnorm = gr(:,2);

norm_gr = ones(length(gr),2);
for cnt=1:length(gr) % Normalization of g_r
    norm_gr(cnt,1) = gr(cnt,1);
    norm_gr(cnt,2)=(gr(cnt,2)/(4*pi*(gr(cnt,1))^2*dr))/length(center)/(frame_last-frame_first+1)/n_density;
    
    % Normalization here is weird because I'm only summing over center but
    % I'm including pairs with particles outside center? 
    
%     norm_gr(cnt,2)=(gr(cnt,2)/(4/3*pi*(gr(cnt,1))^2)*dr)/(length(center)* (length(center)+1));
%     norm_gr(cnt)=(gr(cnt,2)/gr(cnt,1)^2*dr)/(length(center)* (length(center)+1))
%         gr(cnt,2) = (gr(cnt,2))/(gr(cnt,1)^2 * length(data));
end

% % Correlation function S = n_density*norm_gr - n_density^2
% S = ones(length(norm_gr),2);
% for cnt=1:length(gr)
%     S(cnt,1) = norm_gr(cnt,1);
%     S(cnt,2) = gr(cnt,2)*n_density - n_density*n_density
% end


csvwrite(fileout,norm_gr);

% Find max of gr
[~,max_index] = max(norm_gr(:,2));
gr_peak = norm_gr(max_index,1); % Location of max gr in um.

red = [228,26,28]/255;
blu = [55,126,184]/255;
grn = [77,175,74]/255;
pur = [152,78,163]/255;
org = [255,127,0]/255;

% Plot normalized g(r)
figure;
hold on
plot(norm_gr_3(1:end-1,1)-dr/2, norm_gr_3(1:end-1, 2), 'b:.', 'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 20);
plot(norm_gr(1:end-1,1)-dr/2, norm_gr(1:end-1, 2), 'r:.', 'Color', red, 'MarkerFaceColor', red, 'MarkerSize', 20);
% plot(norm_gr_sum_post(1:end-1,1)-dr/2, norm_gr_sum_post(1:end-1, 2), 'b:.', 'Color', pur, 'MarkerFaceColor', pur, 'MarkerSize', 20);
% plot(norm_gr_sum_pre(1:end-1,1)-dr/2, norm_gr_sum_pre(1:end-1, 2), 'b:.', 'Color', grn, 'MarkerFaceColor', grn, 'MarkerSize', 20);
xlabel('r (um)');
ylabel('g(r)');
xt = get(gca,'XTick');
set(gca, 'FontSize', 16);
box on
hold off


% %% Plot multiple g(r) (ran full code normally multiple times. renamed
% % manually to get multiple curves)
% % Ex: norm_gr_pre = norm_gr;
% options.line_width = 1.0;
% mean_diameter = 1.85;
% figure;
% hold on
% plot_post = plot((norm_gr_sum_post(1:end-1,1)-dr/2)/mean_diameter, norm_gr_sum_post(1:end-1, 2), ':', ...
%     'Color', blu, 'Marker', '.', 'MarkerFaceColor', blu, 'MarkerSize', 20, ...
%     'LineWidth', options.line_width);
% plot_pre = plot((norm_gr_sum_pre(1:end-1,1)-dr/2)/mean_diameter, norm_gr_sum_pre(1:end-1, 2), ':', ...
%     'Color', pur, 'Marker', '.', 'MarkerFaceColor', pur, 'MarkerSize', 20, ...
%     'LineWidth', options.line_width);
% lgd = legend([plot_pre, plot_post], {'Untrained', 'Trained'}, 'Location', 'northeast', 'FontSize', 12);
% xlabel('r/2a');
% ylabel('g(r)');
% xt = get(gca,'XTick');
% set(gca, 'FontSize', 16);
% box on
% hold off