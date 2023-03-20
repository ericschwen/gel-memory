% Void volume comparison and data analysis

files = {'C:\Eric\Xerox Data\30um gap runs\0.3333Hz 4-11-17\1.4V\zstack_post_sweep2_bpass3D_100slices\features.csv'};

dx = 0.06;

for i = 1:length(files)
    [VV{i}, VV_mean(i), count(i)] = void_volume_v6(files{i}, dx);
end

for i = 1:length(files)
    
    h{i} = histogram(VV{1});
    normValues{i} = h{i}.Values/count(i);
    binEdges{i} = h{i}.BinEdges(1:end-1);
%     binLimits{i} = h{i}.BinLimits;
%     binWidth(i) = h{i}.BinWidth;
end
%%
loglog(binEdges{1}, normValues{1}, 'bo', 'MarkerSize', 3)
hold on
loglog(binEdges{2}, normValues{2}, 'ro', 'MarkerSize', 3)
xlabel('VV/R^3')
ylabel('VV PDF')
title('Void Volume')
xlim([10^(-4) 10^2])
hold off

%%
% sample bin edges created for dx = 0.06
bin_edges = -4.09:0.01:21.83;

%% Making my own histogram

% [N, edges] = histcounts(VV{1});
edges = -5:0.01:25;
N = histcounts(VV, edges);
plot(edges(1:end-1), N, 'bo', 'MarkerSize', 3)
xlim([-1 1])

edges_noNeg = 0.01:0.01:25;
N_noNeg = histcounts(VV,edges_noNeg);
% % Normalize by probability to make pdf
% N = histcounts(VV{1}, edges, 'Normalization', 'probability');

%% Making histogram iteratively
edges1 = 0.01:0.01:25;
N = histcounts(0, edges1);
parfor i = 1:10
    temp_N = histcounts(VV(i), edges1);
    [value,index] = max(temp_N)
    N = N + temp_N
%     before = N(index);
%     N_before_update = N;
%     N_before_update(index);
%     N(index) = 1;
end