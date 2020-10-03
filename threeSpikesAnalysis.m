ncfile = 'deployment0001_RS03ASHS-MJ03B-07-TMPSFA301-streamed-tmpsf_sample_20140929T190312-20150626T185957.167762.nc' ; % nc file name
% To get information about the nc file
ncinfo(ncfile)
% to display nc file
ncdisp(ncfile)
range = 2;
% preallocation for speed
temp = zeros(24, 2102729);
for i = range
    tag = 'temperature%02d';
    fulltag = sprintf(tag, i);
    temp(i,:) = ncread(ncfile,fulltag);
end
% fft
for i = range
    tag = 'temperature%02d';
    fulltag = sprintf(tag, i);
    x = temp(i, 1:752274); 
    y = temp(i, 752274:1504547); 
    z = temp(i, 1504547:end); 
    x = x - mean(x);
    y = y - mean(y);
    z = z - mean(z);
    
    NFFT=length(x); %NFFT-point DFT      
    NFFTy=length(y);
    NFFTz=length(z);
    X=(fft(x,NFFT))/NFFT; %compute DFT using FFT 
    Y=(fft(y,NFFTy))/NFFTy;
    Z=(fft(z,NFFTy))/NFFTz;
    Fs = 54486; %freq/week
    fx = Fs*(0:(NFFT/2))/NFFT;
    fy = Fs*(0:(NFFTy/2))/NFFTy;
    fz = Fs*(0:(NFFTz/2))/NFFTz;
    figure; 
    plot(z);
    title("Temperature Anomalies in " + fulltag);
    xlabel('Samples');       
    ylabel('Temperature (C)');
    hold on;
    %xline(1504547); % Friday, April 10, 2015
    %xline(1964206); % Monday, June 6, 2015
    figure; 
    plot(fx, 2*abs(X(1:NFFT/2+1)));
    hold on;
    plot(fy, 2*abs(Y(1:NFFTy/2+1)));
    plot(fz, 2*abs(Z(1:NFFTz/2+1)));
    title("Pre-eruption Power Spectrum, 1st Deployment, Thermistor #"+range);
    xlabel('Frequency (1/week)');       
    ylabel('Power');
    axis([0 20 0 1]);
    legend('09/29/14 - 01/03/15', '01/03/15 - 04/10/15', '04/10/15 - 6/26/15');
    
    %X=fftshift((fft(x,NFFT)));
    %fVals=(-NFFT/2:NFFT/2-1); %DFT Sample points  
   
    %figure;
    %plot(fVals,abs(X));      
    %title("Fast Fourier Transform of " + fulltag);       %Double Sided FFT - with FFTShift
    %xlabel('Wave Number');       
    %ylabel('DFT Values');
    %axis([-1 10 0 100]);
   
end


