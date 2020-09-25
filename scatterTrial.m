load("totalNew.mat");
load("trueData.mat");
figure;
x = [];
tt = [];
for i = 1:24
    x = [x data(i,:)];
    tt = [tt t];
end
h = binscatter(tt, x);
h.NumBins = [200 250];
ax = gca;
ax.ColorScale = 'log';
colormap fireice
    title("Temperature Array 1");
    xlabel('Date');       
    ylabel('Temperatures (C)');