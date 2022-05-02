clear;clc;close all
filename = './glider-profiles-28901.csv';
fileID = fopen(filename);
all_data = textscan(fileID,'%f %s %f %f %f %f %f %f %s','Delimiter',',',...
    'HeaderLines',1,'EmptyValue',NaN);
fclose(fileID);
time = all_data{:,2};

for i = 1:length(time)
   time_formatted(i,1) = datetime(time{i}(1:end),'InputFormat','uuuu-MM-dd''T''HH:mm:ss''Z''');
end
time_single = unique(time_formatted);
latitude = all_data{:,3};
longitude = all_data{:,4};
depth = all_data{:,5};
temperature = all_data{:,6};
salinity = all_data{:,7};

%% Specific depth
sample_depth = find(depth == 10 | depth == 20 | depth == 30 | depth == 50 ...
    | depth == 100 | depth == 150 | depth == 200);
latitude_lin_fit = latitude(sample_depth,:);
longitude_lin_fit = longitude(sample_depth,:);
depth_lin_fit = depth(sample_depth,:);
temperature_lin_fit = temperature(sample_depth,:);
time_formatted_lin_fit = time_formatted(sample_depth,:);
%% 20-July
time_0720 = time_single(1);
temperature_lin_fit_0720 = temperature_lin_fit(time_formatted_lin_fit==time_0720);
%% 8-August
time_0808 = time_single(157);
temperature_lin_fit_0808 = temperature_lin_fit(time_formatted_lin_fit==time_0808);
%% Linear fitting
% [lin_fit_slope;lin_fit_intercept] = V\M
n = length(temperature_lin_fit_0720);
M = [sum(temperature_lin_fit_0720.^2) sum(temperature_lin_fit_0720);...
    sum(temperature_lin_fit_0720) n];
V = [sum(temperature_lin_fit_0720.*temperature_lin_fit_0808);...
    sum(temperature_lin_fit_0808)];
reg_comp = M\V;
lin_fit_slope = reg_comp(1);
lin_fit_intercept = reg_comp(2);
%% Find R_square
lin_fit_temperature_lin_fit_0808 = lin_fit_slope*temperature_lin_fit_0720+lin_fit_intercept;
SS_res = sum((temperature_lin_fit_0808-lin_fit_temperature_lin_fit_0808).^2);
SS_tot = sum((temperature_lin_fit_0808-mean(temperature_lin_fit_0808)).^2);
R_square = 1-SS_res/SS_tot;
%% T-test
SSx_tot = sum((temperature_lin_fit_0720-mean(temperature_lin_fit_0720)).^2);
se = sqrt((SS_res/(n-2))/SSx_tot);
T = (lin_fit_slope-0)/se;
%% Results
fig=figure
fig.PaperUnits = 'centimeters';
fig.PaperSize = [29.7 21]; % A4 papersize (horizontal,21-by-29.7 cm,[width height])
fig.PaperType = '<custom>';
fig.WindowState = 'maximized';
fig;
ax = axes;
ax.Position = [0.1 0.1 0.8 0.8];
scatter(temperature_lin_fit_0720,temperature_lin_fit_0808,100,'rx','LineWidth',2);
xlabel('20-July (^{\circ}C)')
ylabel('08-August (^{\circ}C)')
title('Temperature profiles in 2012 (Seaglider, ID:28901)')
hold on;
plot(temperature_lin_fit_0720,lin_fit_temperature_lin_fit_0808,'b-','LineWidth',2)
hold off;
ax.FontSize = 20;
ax_legend = axes;
ax_legend.Color = 'none';
ax_legend.Position = [0.1 0.1 0.8 0.8];
ax_legend.XTick = [];
ax_legend.YTick = [];
text(0.85,0.3,['y = ' num2str(lin_fit_slope) 'x + (' num2str(lin_fit_intercept) ')'],...
    'FontSize',20)
text(0.85,0.2,['R^2 = ' num2str(R_square)],'FontSize',20)
text(0.85,0.1,['T_0 = ' num2str(T) ' (\alpha = 5%, d.f. = ' num2str(n-2) ')'],...
    'FontSize',20)