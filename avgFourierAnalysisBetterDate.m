%% Custom Settings
% Range over which to average
avgPeriod = 58488;
days = 998;
% Sampling rate (samples/time period)
Fs = 58488; %freq/week!!
% Range of all thermistors being analyzed
range = [3, 7, 14]
% Date of first sample being analyzed 
startDate = datetime(2017, 8, 15);
% Date of last sample being analyzed
endDate = datetime(2020, 5, 9);
% Starting and Ending sample (entire data set is 2102729 samples)
startSample = 1;
endSample = 4796043+3937482;
% Number of samples being analyzed 
sampleNumber = 8338748; %cut off last bit of data after 5/9/20
% part 2 = 4796043 samples
% part 1 = 3937482 samples
% part 1 startDate = datetime(2017, 8, 15); and endDate = datetime(2019, 3, 17);
% part 2 startDate = datetime(2019, 3, 18); and endDate = datetime(2020, 5, 9);
%

%% Code
part1 = 'deployment0002_RS03ASHS-MJ03B-07-TMPSFA301-streamed-tmpsf_sample_20170815T003130.804600-20190317T235952.916832.nc';
part2 = 'deployment0002_RS03ASHS-MJ03B-07-TMPSFA301-streamed-tmpsf_sample_20190318T000002.917325-20200717T140006.013506.nc';
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
    data(1:4796043,i) = ncread(part1,fulltag);
    data(4796044:endSample,i) = ncread(part2,fulltag);
    dtime1 = ncread(part1,'time');
    dtime2 = ncread(part2,'time');
end
data = data';
% fft
figure;
for i = range
    tag = 'temperature%02d';
    fulltag = sprintf(tag, i);
    x = data(i,  startSample:sampleNumber); 
    %normalizing to get temp. anomaly, reducing 0 frequency bias
    %x = x - mean(x);
    avg = zeros(1,floor((sampleNumber-startSample)/avgPeriod));
    top = zeros(1,length(avg));
    bot = zeros(1,length(avg));
    %for j = 1:floor(((sampleNumber-startSample)/avgPeriod))
    %    avg(j) = mean(x(1+(avgPeriod*(j-1)):((avgPeriod*j))));
    %    top(j) = max(x(1+(avgPeriod*(j-1)):((avgPeriod*j))));
    %    bot(j) = min(x(1+(avgPeriod*(j-1)):((avgPeriod*j))));
    %end
    
    % actual fft
    %NFFT=length(x); %NFFT-point DFT      
    %X=(fft(x-mean(x),NFFT))/NFFT; %compute DFT using FFT 
    %f = Fs*(0:(NFFT/2))/NFFT;
    newdtime1 = dtime1/(60*60*24)+datetime(1900,1,1); %Convert to Matlab time
    newdtime2 = dtime2/(60*60*24)+datetime(1900,1,1); %Convert to Matlab time
    t = [newdtime1; newdtime2];
    t = t';
    t = t(1:8338748);  
    %actual
    figure;
    plot(t, x);
    
    % avg
    %avgt = startDate + calendarDuration(0,0,0,0,0,0:avgPeriod*10.558:(sampleNumber)*10.558);
    %avgt = avgt(1:length(avg));
    %hold on;
    %plot(avgt(1:end),avg(1:end),'-s');
    %plot(avgt(1:end),top(1:end),'-s');
    %plot(avgt(1:end),bot(1:end),'-s');
    %fill([avgt flip(avgt)],[bot flip(top)],'red', 'FaceAlpha',0.5)
    
        
    % fft graph
    figure; 
    plot(f, 2*abs(X(1:NFFT/2+1)));
    title("Fourier Frequency Plot Temperatures of " + fulltag);
    xlabel('Frequency (1/week)');       
    ylabel('Power');
end
    xlim([startDate, endDate]);
    xtickformat('dd-MMM-yyyy');
    title("Sampled Temperatures of TMPSF 2nd Deployment");
    xlabel('Date');       
    ylabel('Temperatures (C)');
    legend();


