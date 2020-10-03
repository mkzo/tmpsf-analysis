%% Custom Settings
% Range over which to average
avgPeriodTable = [1946 3892 7784 15567];
% Sampling rate (samples/time period)
Fs = 54486; %freq/week!!
% Range of all thermistors being analyzed
range = [1];
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
    dtime = ncread(ncfile,'time');
end
% fft
i = 1;
dtime = dtime/(60*60*24)+datetime(1900,1,1); %Convert to Matlab time
figure;
for avgPeriod = avgPeriodTable
    tag = 'temperature%02d';
    fulltag = sprintf(tag, i);
    x = data(i,  startSample:endSample); 
    %normalizing to get temp. anomaly, reducing 0 frequency bias
    x = x - mean(x);
    avg = zeros(1,floor((endSample-startSample)/avgPeriod));
    for j = 1:floor(((endSample-startSample)/avgPeriod))
        avg(j) = mean(x(1+(avgPeriod*(j-1)):((avgPeriod*j))));
    end
    
    % actual fft
    NFFT=length(x); %NFFT-point DFT      
    X=(fft(x,NFFT))/NFFT; %compute DFT using FFT 
    f = Fs*(0:(NFFT/2))/NFFT;
    t = startDate + calendarDuration(0,0,0,0,0,0:11.1:(sampleNumber)*11.1);
    %figure; 
    
    % actual
    plot(dtime, x);
    xlim([startDate, endDate]);
    xtickformat('dd-MMM-yyyy');
    title("Sampled Temperature Anomalies of " + fulltag);
    xlabel('Date');       
    ylabel('Temperature Anomalies (C)');
    
    % avg
    avgt = startDate + calendarDuration(0,0,0,0,0,0:avgPeriod*11.1:(sampleNumber)*11.1);
    avgt = avgt(1:length(avg));
    hold on;
    %plot(avgt(1:end),avg(1:end),'-s');
    % lines before and after the eruption
    %xline(datetime(2014, 9, 29)) %sample 1504547 at Friday, April 10, 2015
    %xline(datetime(2015, 6, 26)); %sample 1964206 at Monday, June 6, 2015
    
    % fft graph
    %figure; 
    %plot(f, 2*abs(X(1:NFFT/2+1)));
    title("Fourier Frequency Plot of " + fulltag);
    xlabel('Period');       
    ylabel('Temperature Anomalies (C)');
    ylim([0 0.2]); 
 
    % actual fft
    avgFs = Fs/avgPeriod;
    avgNFFT=length(avg); %NFFT-point DFT      
    avgX=(fft(avg,avgNFFT))/avgNFFT; %compute DFT using FFT 
    avgf = avgFs*(0:(avgNFFT/2))/avgNFFT;
    
    % avg fft graph
    plot(avgf, 2*abs(avgX(1:avgNFFT/2+1)));
    hold on;
end
    title("Avg Fourier Frequency Plot of " + fulltag);
    xlabel('Frequency (1/week)');       
    ylabel('Temperature Anomalies (C)');
    axis([0 15 0 0.2]); 
    legend("6 hours", "12 hours", "24 hours", "48 hours");


