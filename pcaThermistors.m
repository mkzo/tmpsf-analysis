%% Custom Settings
% Range over which to average
avgPeriod = 1946;
columnCluster = false;
% Sampling rate (samples/time period)
Fs = 54486; %freq/week!!
% Range of all thermistors being analyzed
range = [1:24];
%range(range == 2) = [];
%range(range == 13) = [];
%range(range == 16) = [];
%range(range == 24) = [];
% Date of first sample being analyzed (entire data set starts at datetime(2014, 9, 29))
startDate = datetime(2014, 9, 29);
% Date of last sample being analyzed (entire data set starts at datetime(2015, 7, 1))
endDate = datetime(2015, 6, 26);
% Starting and Ending sample (entire data set is 2102729 samples)
startSample = 1;
endSample = 2102729;
% Number of samples being analyzed 
sampleNumber = endSample-startSample;
% Useful Sample Numbers and Dates:
% First = 1 at 9/29/2014
% Before Eruption = 1504547 at Friday, April 10, 2015
% After Eruption = 1964206 at Monday, June 6, 2015
% Last = 2102729 at 6/26/2015

%% Code
ncfile = 'deployment0001_RS03ASHS-MJ03B-07-TMPSFA301-streamed-tmpsf_sample_20140929T190312-20150626T185957.167762.nc' ; % nc file name
% To get information about the nc file
ncinfo(ncfile);
% to display nc file
ncdisp(ncfile);
% preallocation for speed
data = zeros(24, 2102729);
for i = range
    tag = 'temperature%02d';
    fulltag = sprintf(tag, i);
    data(i,:) = ncread(ncfile,fulltag);
end
for i = range
    tag = 'temperature%02d';
    fulltag = sprintf(tag, i);
    %normalizing to get temp. anomaly, reducing 0 frequency bias
    data(i,:) = data(i,:) - mean(data(i, :));
    %avg = zeros(1,floor((endSample-startSample)/avgPeriod));
    %for j = 1:floor(((endSample-startSample)/avgPeriod))
    %    avg(j) = mean(x(1+(avgPeriod*(j-1)):((avgPeriod*j))));
    %end
    
    %t = startDate + calendarDuration(0,0,0,0,0,0:11.1:(sampleNumber)*11.1);
    %plot(t, x);
    %hold on;
    
    % avg
    %avgt = startDate + calendarDuration(0,0,0,0,0,0:avgPeriod*11.1:(sampleNumber)*11.1);
    %avgt = avgt(1:length(avg));
    %hold on;
    %plot(avgt(1:end),avg(1:end),'-s');
    % lines before and after the eruption
    %xline(datetime(2015, 4, 10)) %sample 1504547 at Friday, April 10, 2015
    %xline(datetime(2015, 6, 6)); %sample 1964206 at Monday, June 6, 2015
end

    %xlim([startDate, endDate]);
    %xtickformat('dd-MMM-yyyy');
    %title("Sampled Temperature Anomalies of " + fulltag);
    %xlabel('Date');       
    %ylabel('Temperature Anomalies (C)');
    %legend;
    [r, p] = corrcoef(data');
    figure;
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
            h(k).Color = [0.8500, 0.3250, 0.0980]; % Specify red as the line color
        end
        for k = [3, 12, 17]
            h(k).Color = [0, 0.5, 0]; % Specify red as the line color
        end
        for k = [5, 10, 19]
            h(k).Color = [1 0 1]; % Specify red as the line color
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