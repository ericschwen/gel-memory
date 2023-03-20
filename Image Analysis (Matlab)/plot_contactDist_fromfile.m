%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mean image difference
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
folder = 'E:\Xerox Data\30um gap runs 2016\0.5Hz 0.1V 9-12-16.mdb';

numfiles = 9;

% Can use a list of the file numbers if one is missing, etc.
fileNumbers = 1:1:numfiles;
% fileNumbers = [1 2 4 5 6 7 8 9];

% Declare cell array sizes.
filename = cell(numfiles,1);
contactDist = cell(numfiles,1);
meanContacts = zeros(numfiles,1);

for fnum = fileNumbers %1:1:numfiles
    filename{fnum} = [folder '\ts' num2str(fnum) '_static_bpass_3D_static_160\ts' num2str(fnum) '_features_contact_dist.csv'];
    contactDist{fnum} = xlsread(filename{fnum});
    
    % Get mean contact number
    for i = 1:1:length(contactDist{fnum})
        meanContacts(fnum) = meanContacts(fnum) + contactDist{fnum}(i,1)*contactDist{fnum}(i,2);
    end
    meanContacts(fnum) = meanContacts(fnum) / sum(contactDist{fnum}(:,2));
end

preshear_meanContacts = 0;
preshear_filename = [folder '\preshear' '_static_bpass_3D_static_160\preshear_features_contact_dist.csv'];
preshear_contactDist = xlsread(preshear_filename);
for i = 1:1:length(preshear_contactDist)
        preshear_meanContacts = preshear_meanContacts + preshear_contactDist(i,1)*preshear_contactDist(i,2);
end
preshear_meanContacts = preshear_meanContacts / sum(preshear_contactDist(:,2));

plotStyle = ':o';

map = colormap(jet);

figure;
hold on
for i = 1:1:length(contactDist)
    plot(contactDist{i}(:,1), contactDist{i}(:,2)/sum(contactDist{i}(:,2)), plotStyle, 'Color', map(i*6,:));
    legendInfo{i} = ['time ' num2str(i)];
end
title('Contact Number Distribution by Time');
xlabel('Contacts');
ylabel('Probability');
legend(legendInfo);
plot(preshear_contactDist(:,1), preshear_contactDist(:, 2)/sum(preshear_contactDist(:,2)), 'b-o');
hold off


figure;
hold on
plot(1:1:numfiles, meanContacts(:), 'b:o');
plot(0,preshear_meanContacts,'b:o');
title('Mean Contact Number by Time');
xlabel('time');
ylabel('mean contact number');
hold off

%% Just first and last
figure;
hold on
title('Contact Number Distribution by Time');
xlabel('Contacts');
ylabel('Probability');
plot(preshear_contactDist(:,1), preshear_contactDist(:, 2)/sum(preshear_contactDist(:,2)), 'b-o');
plot(contactDist{length(contactDist)}(:,1),...
    contactDist{length(contactDist)}(:,2)/sum(contactDist{length(contactDist)}(:,2)),...
    plotStyle, 'Color', 'r');
legend('Before Training', 'After Training')
hold off
