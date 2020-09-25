%% Custom Settings
% Range over which to average (number samples taken in the avg period)
% Sampling rate (samples/time period)
Fs = 54486; %freq/week (change requires changing the x axis)
% Range of all thermistors being analyzed
range = [1,2,13,16,24];
% Periods
weeks = [2];
% Number of samples being analyzed 
sampleNumber = 2102729;
newcolors = {'#ff0000','#ff4000','#ff8000','#ffbf00','#ffff00','#bfff00','#80ff00', '#40ff00', '#00ff00', '#00ff40', '#00ff80', '#00ffbf', '#00ffff', '#00bfff', '#0080ff', '#0040ff', '#0000ff', '#4000ff', '#8000ff', '#bf00ff', '#ff00ff'};

%% Reading in Data
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

%% Code
for w = weeks
    % Sample Array
    samples = 1:w*54486:2102729; %rounds down number of samples
    % Dates of Periods Array
    dates = datetime(2014, 9, 29) + calweeks(1:w:w*length(samples));
    % fft
    for i = range
        clear z;
        tag = 'temperature%02d';
        fulltag = sprintf(tag, i);
        %period
        %figure; 
        for j = 1:(length(samples)-1)
            x = data(i, samples(j):samples(j+1)); 
            %normalizing to get temp. anomaly, reducing 0 frequency bias
            x = x - mean(x);
            % actual fft
            NFFT=length(x); %NFFT-point DFT      
            X=(fft(x,NFFT))/NFFT; %compute DFT using FFT 
            f = Fs*(0:(NFFT/2))/NFFT;
            % fft graph
            %str = newcolors(j);
            %color = sscanf(str(2:end),'%2x%2x%2x',[1 3])/255;
            z(j, :) = 2*abs(X(1:NFFT/2+1));
            %plot(f, 2*abs(X(1:NFFT/2+1)), 'Color', newcolors{end-j});
            hold on;
        end
        %title("Fourier Frequency Plot of " + fulltag);
        %xlabel('Frequency (1/week)');       
        %ylabel('Power');
        %axis([0 100 0 1]); 
        %leg = legend(datestr(dates));
        %leg.FontSize = 6;
        
        %z(16:17,2) = 0; %getting rid of outliers to better scales
        figure;
        heatmap(0:1:24.5,1:19,z,'ColorMap',parula);
        caxis([0,1])
        title("FFT Time Series at a 2 week interval, Thermistor 01" + fulltag);
        xlabel('Frequency/week');       
        ylabel('Power');
         actual full plot (all periods)
        figure; 
        t = dates(1) + calendarDuration(0,0,0,0,0,0:11.1:(2102728)*11.1);
        x = data(i, 1:2102729); 
        x = x - mean(x);
        plot(t, x);
        xlim([dates(1), dates(end)]);
        xtickformat('dd-MMM-yyyy');
        title("Sampled Temperature Anomalies of " + fulltag);
        xlabel('Date');       
        ylabel('Temperature Anomalies (C)');
        % lines for each period interval
        %for d = dates
        %    xline(datetime(d));
        %end
    end
end

