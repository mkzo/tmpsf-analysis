%% Custom Settings
% Range over which to average
columnCluster = false;
avgPeriod = 1946;
% Sampling rate (samples/time period)
Fs = 68937; %freq/week!!
% Range of all thermistors being analyzed
range = [1:24];
% Date of first sample being analyzed 
startDate = datetime(2017, 8, 15);
% Date of last sample being analyzed
endDate = datetime(2020, 7, 17);
% Starting and Ending sample (entire data set is 2102729 samples)
startSample = 1;
endSample = 3937482+4796043;
% Number of samples being analyzed 
sampleNumber = endSample;
% part 2 = 4796043 samples
% part 1 = 3937482 samples
% part 1 startDate = datetime(2017, 8, 15); and endDate = datetime(2019, 3, 17);
% part 2 startDate = datetime(2019, 3, 18); and endDate = datetime(2020, 7, 17);
%

%% Code
part1 = 'deployment0002_RS03ASHS-MJ03B-07-TMPSFA301-streamed-tmpsf_sample_20190318T000002.917325-20200717T140006.013506.nc';
part2 = 'deployment0002_RS03ASHS-MJ03B-07-TMPSFA301-streamed-tmpsf_sample_20170815T003130.804600-20190317T235952.916832.nc' ;
% To get information about the nc file
ncinfo(part1);
ncinfo(part2);
% to display nc file
ncdisp(part1);
ncdisp(part2);
% preallocation for speed
data = zeros(sampleNumber,24);
for i = range
    tag = 'temperature%02d';
    fulltag = sprintf(tag, i);
    data(1:3937482,i) = ncread(part1,fulltag);
    data(3937483:endSample,i) = ncread(part2,fulltag);
    meanData = mean(data(:,i));
    data(:,i) = data(:,i) - meanData;
end
data = data';
    figure;
    [r, p] = corrcoef(data');
    heatmap(r);
    mycolormap = customcolormap_preset('blue-white-red');
    colormap(mycolormap);
    title("Pearson Correlation Coefficients");
    xlabel("Thermistor");
    ylabel("Thermistor");
    caxis([-1 1]);
    figure;
    heatmap(p);
    title("p-values");
    xlabel("Thermistor");
    ylabel("Thermistor");
    caxis([0 1]);
    colormap(parula);
    %% PCA
    figure;
    [coeff, score, latent, ~, explained] = pca(data');
    v = 1:24;
    vbls = string(v);
    h = biplot(coeff(:,1:3),'VarLabels',vbls);
    if (columnCluster)
        for k = [6,9,20,22]
            h(k).Color = 'y'; % Specify red as the line color
        end
        for k = [2,13,16,24]
            h(k).Color = 'r'; % Specify red as the line color
        end
        for k = [4,11,18,23]
            h(k).Color = 'b'; % Specify red as the line color
        end
        for k = [1, 14, 15]
            h(k).Color = 'k'; % Specify red as the line color
        end
        for k = [7, 8, 21]
            h(k).Color = [0.8500, 0.3250, 0.0980]; % orange
        end
        for k = [3, 12, 17]
            h(k).Color = [0, 0.5, 0]; % green
        end
        for k = [5, 10, 19]
            h(k).Color = [1 0 1]; % magenta
        end
    else
        for k = 1:7
            h(k).Color = 'r'; % Specify red as the line color
        end
        for k = 8:14
            h(k).Color = 'g'; % Specify red as the line color
        end
        for k = 15:21
            h(k).Color = 'b'; % Specify red as the line color
        end
        for k = 22:24
            h(k).Color = 'k'; % Specify red as the line color
        end
    end
    title("Principal Component Analysis of TMPSF Thermistors");
    xlabel("Component 1 ("+explained(1)+"%)");
    ylabel("Component 2 ("+explained(2)+"%)");
    zlabel("Component 3 ("+explained(3)+"%)");
    figure;
    hold on;
    plot(coeff(:,1),'*-');
    plot(coeff(:,2),'*-');
    plot(coeff(:,3),'*-');
    legend("1","2","3");
    xlabel("Thermistor");
    ylabel("Coefficient");
    title("Principal Component Formulas");
%% Output CSV File with Mean Temp, Component Formulas, Column and Level Clusters
