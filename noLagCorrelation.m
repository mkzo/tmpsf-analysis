% Load data 
load("fullData.mat");
load("distance.mat");
% How to deal with gaps in data? Ignore for larger periods, take into
% account for shorter periods
source = 2;
% Possibly filter out tidal frequencies if they prove too strong
startTime = t(1);
endTime = t(end);
period = datetime(0,0,7); % 1 week
% Create array of datetimes with period as indicated
timeLine = [startTime:caldays(7):endTime endTime];
% Loop through datetime array, calculating corrcoef for each period between
% each thermistor and the source
coeff = zeros(24,length(timeLine)-1);
distance = d(2,:);
% 8, 9, and 16 have the same distances from 2
distance(9) = distance(9) + 0.0001;
distance(16) = distance(16) + 0.0002; %so labeling doesnt return an error
% 11 and 17 has the same distances from 2
distance(17) = distance(17) + 0.0001;
[sortedDistance, index] = sort(distance);
dates = [];
%range(source) = [];
j = 1;
for i = 1:length(timeLine)-1
    At = t(logical((t >= timeLine(i)) .* (t < timeLine(i+1))));
    At.Format = 'dd-MMM-yyyy';
    dates = [dates (string(At(1)) + "-" + string(At(end)))];
end
for r = index
    for i = 1:length(timeLine)-1
        At = t(logical((t >= timeLine(i)) .* (t < timeLine(i+1))));
        startAt = find(t == At(1));
        endAt = find(t == At(end));
        laggedTemp = temp(r,startAt:endAt);
        sourceTemp = temp(source,startAt:endAt);
        A = [laggedTemp' sourceTemp'];
        c = corrcoef(A); % columns of A are variables, rows are observations
        coeff(j,i) = c(1,2);
    end
    j = j+1;
end
figure;
ylabels = num2cell(index);
xlabels = num2cell(1:length(timeLine)-1);
h1 = heatmap(xlabels, ylabels, coeff);
h1.Title = 'Correlation Timeline Source #2 - Thermistor and Week';
h1.XLabel = 'Week';
h1.YLabel = 'Thermistor';
mycolormap = customcolormap_preset('blue-white-red');
colormap(mycolormap);
caxis([-1 1]);

figure;
ylabels = num2cell(sortedDistance);
xlabels = num2cell(dates);
h2 = heatmap(xlabels, ylabels, coeff);
h2.Title = 'Correlation Timeline Source #2 - Distances and Date';
h2.XLabel = 'Date Ranges';
set(struct(h2).NodeChildren(3), 'XTickLabelRotation', 90);
h2.YLabel = 'Distances (cm)';
mycolormap = customcolormap_preset('blue-white-red');
colormap(mycolormap);
caxis([-1 1]);
