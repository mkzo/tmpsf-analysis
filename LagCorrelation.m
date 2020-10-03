load("fullData.mat");
load("distance.mat");
startSample = 1;
[sortedDistance, index] = sort(d(2,:));
perWeek = 60479/(7*24*60); %samples per period - minute
groups = floor(30*6/perWeek); %up to sample 1800
coeff = zeros(4,groups);
pval = zeros(4, groups);
j = 1;
for r = [2 13 16 24] %index
    for i = 0:groups-1
        sourceTemp = temp(2,1:perWeek);
        laggedTemp = temp(r,i*perWeek+1:(i+1)*perWeek);
        A = [sourceTemp' laggedTemp'];
        [c, p] = corrcoef(A);
        coeff(j,i+1) = c(1,2);
        pval(j,i+1) = p(1,2); 
    end
    j = j+1;
end

figure;
ylabels = num2cell([2 13 16 24]);
xlabels = num2cell(startSample:groups);
h1 = heatmap(xlabels, ylabels, coeff);
h1.Title = 'TMPSF First Deployment Source #2 - 1 Hour Lag Correlation';
h1.XLabel = 'Minute';
h1.YLabel = 'Thermistor';
mycolormap = customcolormap_preset('blue-white-red');
colormap(mycolormap);
caxis([-1 1]);


figure;
ylabels = num2cell([2 13 16 24]);
xlabels = num2cell(startSample:groups);
h2 = heatmap(xlabels, ylabels, pval);
h2.Title = 'TMPSF First Deployment Source #2 - 1 Hour Lag p-values';
h2.XLabel = 'Minute';
h2.YLabel = 'Thermistor';
colormap(parula);
caxis([0 1]);