load("fullData.mat");
%% REAL CODE
t = t';
figure;
x = [];
tt = [];
for i = 1:24
    x = [x temp(i,:)];
    tt = [tt t];
end
h = binscatter(tt, x);
h.NumBins = [200 250];
ax = gca;
ax.ColorScale = 'log';
colormap fireice
    title("TMPSF Absolute Temperatures 9/29/14-6/26/15");
    xlabel('Date');       
    ylabel('Temperatures (C)');