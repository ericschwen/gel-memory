function contact_number

% filein = 'E:\ts5_bpass_normalized_static_160\ts5_features.csv';
filein = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\0.5Hz 0.1V 9-12-16.mdb\ts5_bpass_normalized_static_160\ts5_features.csv';
fileout = [filein(1:length(filein) - 4), '_g_r.csv'];
% filein = ['G:\BackUp_Colloids_Data\XEROX\2016_02_23.mdb\' num2str(pcnt) '_immediate_2enhanced_bp4_feature.csv'];
% fileout = ['G:\BackUp_Colloids_Data\XEROX\2016_02_23.mdb\' num2str(pcnt) '_immediate_2enhanced_bp4_g_r.csv'];
data=xlsread(filein);

% rc = 6; %calculation range (Microns)
% dr= 0.1; %radius step (microns)
% % grc=zeros(rc/dr,2); %declare output data(radius,g(r))

% Max range to be counted as in contact (in microns)
contactRange = 2.0;

% Load x, y, z data and convert distances into um.
data(:,2)=data(:,2)*(0.127);
data(:,3)=data(:,3)*(0.127);
data(:,4)=data(:,4)*(0.135);

% xmax=max(data(:,2));
% ymax=max(data(:,3));
% zmax=max(data(:,4));

% Don't really need to isolate the center part for contact number.
% % Take only data near center for calculation. May want to increase size of
% % center to reduce noise? Could also skew data though by reducing number of
% % far away particles (if you go off the edge of the image).
% % Why divide by 8 specifically? Why not include z column in calculations?
% aNumber = 2;
% center=data(data(:,2) > rc/aNumber & data(:,2) < xmax-rc/aNumber & data(:,3) > rc/aNumber & data(:,3) < ymax -rc/aNumber & data(:,4) > rc/aNumber & data(:,4) < zmax -rc/aNumber,2:4);
% % center = data(:, 1:3);
% center=sortrows(center,3); % Sort center data by z height.

% % Array of only positions. Don't really need it but it's convenient.
% positions = data(:,2:4);

contacts = zeros(length(data), 1); % Declare an array 
contactDist=zeros(12,2);%declare the contact number  distribution array
% Could probably do all the distribution stuff at the end using the
% contacts array anyway.

for i=1:1:length(data)
    %calculate the relative position vector. (Calculate for every other
    %particle in one step with repmat)
    % repmat takes one row of the center matrix and repeats it for each other
    % row to make it the size of data. Then subtract to have distances.
    shifted_vector=data(:,2:4)-repmat(data(i,2:4),length(data),1);
    shifted_vector=abs(shifted_vector); %take the absolute value.
%     % Limit to selected max range rc.
%     shifted_vector=shifted_vector( shifted_vector(:,1)<rc & shifted_vector(:,2)<rc & shifted_vector(:,3)<rc,:);
    distance=zeros(length(shifted_vector),1);

    % Counter variable for the number of particles in contact.
    contactCount = 0;
    
    for j=1:1:length(shifted_vector)
        distance(j,1)=norm(shifted_vector(j,1:3));
        if distance(j,1) < contactRange
            contactCount = contactCount + 1;
        end
    end
    
    contacts(i) = contactCount;

    if mod(i,1000)==0
        fprintf([num2str(i) '/' num2str(length(data)) '\n']);
    end

end

for i = 1:1:length(contactDist)
    contactDist(i,1) = i-1;
end

for i = 1:1:length(contacts)-1
    contactDist(contacts(i)+1,2) = contactDist(contacts(i)+1,2) + 1;
end

% csvwrite(fileout,contactDist);

figure;
plot(contactDist(:,1), contactDist(:, 2), 'b:o');
title('Contact Number Distribution');
xlabel('Contacts');
ylabel('Number');



end