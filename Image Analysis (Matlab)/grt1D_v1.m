% function gr1D
% Calculates g_d(r,t) for a collection of particles.
% 
% Space-time correlation calculation. Code modified from gr1D_v8.
% Mod. History:
%   v1: first try. very rough. no averaging, just two time points. 11-22-20

% filein = 'E:\Gardner Data\piezo 2-25-20\ts-post-p5-stacked\linked_peri_mod.csv';

filein = 'E:\Gardner Data\glass 11-17-20\settling\settling-ts-1-stacked\linked_peri_mod.csv';
% NOTE: Gardner data is binary. Need inteligent g_r

fileout = [filein(1:length(filein) - 4), '_g_rt.csv'];
data=xlsread(filein);
data2=xlsread(filein);

frame_column = 5; % Trackpy data: Set which data column will be checked for frame number
% frame_column = 5; % PERI dat: Set which data column will be checked for frame number
rc = 6; %calculation range (Microns)
dr= 0.1; %radius step (microns)
% grc=zeros(rc/dr,2); %declare output data(radius,g(r))

% Choose frames to use for different times with g_rt
frame1 = 500;
frame2 = 519;

%%%%%%%%%
% select only frame 0. Or whichever frame you choose 
condition = data(:,frame_column) ~= frame1;
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

% xmin = min(data(:,1));
% ymin = min(data(:,2));
% zmin = min(data(:,3));
% 
% xmax=max(data(:,1));
% ymax=max(data(:,2));
% zmax=max(data(:,3));

% g_rt calculation--select data for a different frame as well
condition2 = data2(:,frame_column) ~= frame2;
data2(condition2,:) = [];

% Load x, y, z data and convert distances into um.
data2(:,1)=data2(:,1)*(0.127); % x[px] to x[um]
data2(:,2)=data2(:,2)*(0.127); % y[px] to y[um]
data2(:,3)=data2(:,3)*(0.12); % z[px] to z[um]

xmin = min(data2(:,1));
ymin = min(data2(:,2));
zmin = min(data2(:,3));

xmax=max(data2(:,1));
ymax=max(data2(:,2));
zmax=max(data2(:,3));

% Take only data near center for calculation. May want to increase size of
% center to reduce noise? Could also skew data though by reducing number of
% far away particles (if you go off the edge of the image).
buffer_frac = 0.7;
center=data2(data2(:,1) > xmin + rc*buffer_frac & data2(:,1) < xmax-rc*buffer_frac & ...
    data2(:,2) > ymin + rc*buffer_frac & data2(:,2) < ymax -rc*buffer_frac & ...
    data2(:,3) > zmin + rc*buffer_frac & data2(:,3) < zmax -rc*buffer_frac, 1:3);
% center = data2(:, 1:3);
center=sortrows(center,3); % Sort center data by z height.

% Calculate number density for normalization
center_volume = ((xmax-rc*buffer_frac)-(xmin+rc*buffer_frac)) * ...
    ((ymax-rc*buffer_frac)-(ymin+rc*buffer_frac)) * ...
    ((zmax-rc*buffer_frac)-(zmin+rc*buffer_frac));
n_density = length(center)/center_volume;

grt=zeros(rc/dr,2); %declare the g(r).
tempgrt=zeros(rc/dr,1); %temp g(r) to manipulate in the for-loop
x_space=dr:dr:rc; %x_space to do the histogram.
grt(:,1)=x_space';

% NOTES: Center is now array of central particles in frame2. data is still
% particles from frame1. subracting the two should make sense.
% Normalization is still funky--should I be using number density from 1 or
% 2? Probably close enough that it doesn't matter too much initially.

for i=1:length(center)
    %calculate the relative position vector. (Calculate for every other
    %particle in one step with repmat)
    % repmat takes one row of the center matrix and repeats it for each other
    % row to make it the size of data. Then subtract all other positions to have distances.
    shifted_vector=data(:,1:3)-repmat(center(i,:),length(data),1);
    shifted_vector=abs(shifted_vector); %take the absolute value to get positive distances.
    
    % Limit to selected max range rc.
    shifted_vector=shifted_vector(shifted_vector(:,1)<rc & shifted_vector(:,2)<rc & shifted_vector(:,3)<rc,:);
    distance=zeros(length(shifted_vector),1);
    
    for cnt=1:size(shifted_vector,1)
        distance(cnt,1)=norm(shifted_vector(cnt,1:3));
    end

    % Calculate histogram for g_r for single particle
    tempgrt=histc(distance',x_space); % Maybe use histcounts instead
    % Add single particle g_r to total
    grt(:,2)=grt(:,2)+tempgrt';
end

test_unnorm = grt(:,2);

norm_grt = ones(length(grt),2);
for cnt=1:length(grt) % Normalization of g_r
    norm_grt(cnt,1) = grt(cnt,1);
    norm_grt(cnt,2)=(grt(cnt,2)/(4*pi*(grt(cnt,1))^2*dr))/length(center)/n_density;
    
    % Normalization here is weird because I'm only summing over center but
    % I'm including pairs with particles outside center? 
    
%     norm_gr(cnt,2)=(gr(cnt,2)/(4/3*pi*(gr(cnt,1))^2)*dr)/(length(center)* (length(center)+1));
%     norm_gr(cnt)=(gr(cnt,2)/gr(cnt,1)^2*dr)/(length(center)* (length(center)+1))
%         gr(cnt,2) = (gr(cnt,2))/(gr(cnt,1)^2 * length(data));
end


csvwrite(fileout,norm_grt);

% Find max of gr
[~,max_index] = max(norm_grt(:,2));
gr_peak = norm_grt(max_index,1); % Location of max gr in um.

red = [228,26,28]/255;
blu = [55,126,184]/255;
grn = [77,175,74]/255;
pur = [152,78,163]/255;
org = [255,127,0]/255;

% Plot normalized g(r)
figure;
hold on
plot1 = plot(norm_grt(2:end-1,1)-dr/2, norm_grt(2:end-1, 2), 'b:.', 'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 20);
% plot2 = plot(norm_grt_0(1:end-1,1)-dr/2, norm_grt_0(1:end-1, 2), 'b:.', 'Color', pur, 'MarkerFaceColor', pur, 'MarkerSize', 20);
% plot(norm_gr_sum_pre(1:end-1,1)-dr/2, norm_gr_sum_pre(1:end-1, 2), 'b:.', 'Color', grn, 'MarkerFaceColor', grn, 'MarkerSize', 20);
% lgd = legend([plot1, plot2], {'9.5s', '0s'}, 'Location', 'northeast', 'FontSize', 12);
xlabel('r (um)');
ylabel('g(r,t)');
ylim([0,3]);
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