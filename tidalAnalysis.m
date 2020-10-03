%Station 46404 (LLNR 765.4) - WEST ASTORIA - 230 NM West of Astoria, OR
%https://www.ndbc.noaa.gov/station_page.php?station=46404&type=0&startyear=2015&startmonth=06&startday=05&endyear=2015&endmonth=07&endday=18&submit=Submit
file_name = fopen('tidalData.txt', 'r');
data = fscanf(file_name, '%d %d %d %d %d %d %d %f', inf);
data = reshape(data, 8, 8847)'; 
% Data is a 2 dimensional array that stores different tidal values
% in every row, and each row contains the date and water column height
data = data(700:end,:);
water_col = data(:,8);
NFFT=length(water_col);
t = datetime(data(1,1),data(1,2),data(1,3)) + calendarDuration(0,0,0,0,0:15:15*(NFFT-1),0);
avg = mean(water_col);
% water col
%figure;
%plot(t, water_col);
%title("Water Column Heigh of Tidal Buoy 46404");
%xlabel('Date');       
%ylabel('Water Column Anomalies (m)');
%axis([0 9000 -30 30]); 
water_col = water_col - avg;

% actual fft
Fs = 672; %number of samples in a week
NFFT=length(water_col); %NFFT-point DFT      
X = (fft(water_col))/NFFT; %compute DFT using FFT 
f = Fs*(0:(NFFT/2))/NFFT;
% fft graph
plot(f, 2*abs(X(1:NFFT/2+1)));
title("Fourier Frequency Plot of Tidal Buoy 46404");
xlabel('Frequency (1/week)');       
ylabel('Water Column Anomalies (m)');
axis([0 30 0 1]); 

fclose(file_name);

