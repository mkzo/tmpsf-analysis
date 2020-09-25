%% Custom Settings
% Range over which to average
avgPeriod = 1946*4;
% Sampling rate (samples/time period)
Fs = 54486; %freq/week!!
% Range of all thermistors being analyzed
range = [1 2 13 16 24];
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
% fft
figure;
for i = range
    tag = 'temperature%02d';
    fulltag = sprintf(tag, i);
    x = data(i,  startSample:endSample); 
    %normalizing to get temp. anomaly, reducing 0 frequency bias
    x = x - mean(x);
    for j = 1:((endSample-startSample)/avgPeriod)-1
        avg(j) = mean(x(1+(avgPeriod*(j-1)):((avgPeriod*j))));
    end
    % actual fft
    NFFT=length(x); %NFFT-point DFT      
    X=(fft(x,NFFT))/NFFT; %compute DFT using FFT 
    f = Fs*(0:(NFFT/2))/NFFT;
    t = startDate + calendarDuration(0,0,0,0,0,0:11.1:(sampleNumber)*11.1);
    subplot(5,1,find(range==i));
    plot(t, x);
    xlim([startDate, endDate]);
    xtickformat('dd-MMM-yyyy');
    title("Sampled Temperature Anomalies of " + fulltag);
    xlabel('Date');       
    ylabel('Anom. (C)');
    avgt = startDate + calendarDuration(0,0,0,0,0,0:avgPeriod*11.1:(sampleNumber)*11.1);
    hold on;
    plot(avgt(1:length(avg)),avg,'-s');
    % lines before and after the eruption
    xline(datetime(2015, 4, 10)) %sample 1504547 at Friday, April 10, 2015
    xline(datetime(2015, 6, 6)); %sample 1964206 at Monday, June 6, 2015
end

figure;
for i = range
    tag = 'temperature%02d';
    fulltag = sprintf(tag, i);
    x = data(i,  startSample:endSample); 
    %normalizing to get temp. anomaly, reducing 0 frequency bias
    x = x - mean(x);
    for j = 1:((endSample-startSample)/avgPeriod)-1
        avg(j) = mean(x(1+(avgPeriod*(j-1)):((avgPeriod*j))));
    end
    % actual fft
    NFFT=length(x); %NFFT-point DFT      
    X=(fft(x,NFFT))/NFFT; %compute DFT using FFT 
    f = Fs*(0:(NFFT/2))/NFFT;
    plot(f, 2*abs(X(1:NFFT/2+1)));
    hold on;
end
    hold on;
    tidalAnalysis
    title("Fourier Frequency Plot of 5 Probes");
    xlabel('Frequency (1/week)');       
    ylabel('Anom. (C)');
    axis([0 20 0 0.8]); 
    legend('1','2','13','16','24','Buoy Data');
    
 


