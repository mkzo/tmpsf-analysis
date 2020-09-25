figure;
fileID = fopen('thermistorPoints.txt','r');
A = fscanf(fileID, '%f'); %in groups of 7, thermistor #, x, y, z (cm), x, y, z, (inch)
d = zeros(24,24);
for i = 0:23
    for j = 0:23
        d(i+1,j+1) = sqrt((A(i*7+2)-A(j*7+2))^2+(A(i*7+3)-A(j*7+3))^2+(A(i*7+4)-A(j*7+4))^2);
    end
end
%[sortedDistance, index] = sort(d(2,:));
%d = d(index,:);
%d = d(:,index);
heatmap(d);
title("Distance Heatplot between TMPSF Thermistors");
xlabel("Thermistor");
ylabel("Thermistor");