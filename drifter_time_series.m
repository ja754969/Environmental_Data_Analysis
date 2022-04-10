clear;clc;close all
%% Read sheet 'drifting-buoys-2101641' in 'drifting-buoys-data.xlsx'
opts = detectImportOptions('drifting-buoys-data.xlsx');
opts.Sheet = 'drifting-buoys-2101641';
preview('drifting-buoys-data.xlsx',opts)
opts.SelectedVariableNames = [1:6]; 
opts.DataRange = '2:134';
drifting_buoys_2101641 = readmatrix('drifting-buoys-data.xlsx',opts);
time_hours_2101641 = drifting_buoys_2101641(:,1);
longitude_2101641 = drifting_buoys_2101641(:,2);
latitude_2101641 = drifting_buoys_2101641(:,3);
temperature_2101641 = drifting_buoys_2101641(:,4);
u_2101641 = drifting_buoys_2101641(:,5);
v_2101641 = drifting_buoys_2101641(:,6);
%------------------------------------------------%
temperature_mean_2101641 = mean(temperature_2101641);
temperature_var_2101641 = var(temperature_2101641);

%% Read sheet 'drifting-buoys-2101642' in 'drifting-buoys-data.xlsx'
opts = detectImportOptions('drifting-buoys-data.xlsx');
opts.Sheet = 'drifting-buoys-2101642';
preview('drifting-buoys-data.xlsx',opts)
opts.SelectedVariableNames = [1:6]; 
opts.DataRange = '2:197';
drifting_buoys_2101642 = readmatrix('drifting-buoys-data.xlsx',opts);
time_hours_2101642 = drifting_buoys_2101642(:,1);
longitude_2101642 = drifting_buoys_2101642(:,2);
latitude_2101642 = drifting_buoys_2101642(:,3);
temperature_2101642 = drifting_buoys_2101642(:,4);
u_2101642 = drifting_buoys_2101642(:,5);
v_2101642 = drifting_buoys_2101642(:,6);
%------------------------------------------------%
temperature_mean_2101642 = mean(temperature_2101642);
temperature_var_2101642 = var(temperature_2101642);
%% t-test
n1 = length(temperature_2101641);
n2 = length(temperature_2101642);
df = n1+n2-2;
%------------------------------------------------%
t_095 = 1.65;
t_temperature = (temperature_mean_2101642-temperature_mean_2101641)/...
    sqrt(temperature_var_2101642/n1+temperature_var_2101642/n2);
%% Time series of temperature and u-velocity 
fig=figure
fig.PaperUnits = 'centimeters';
fig.PaperSize = [29.7 21]; % A4 papersize (horizontal,21-by-29.7 cm,[width height])
fig.PaperType = '<custom>';
fig.WindowState = 'maximized';
fig;

%-------------------------------------------%
ax1 = axes
ax1.Position = [0.05 0.52 0.85 0.4]
ax1.LineWidth = 2;
ax1.FontSize = 20;
ax1.FontWeight = 'Bold';
ax1.XAxisLocation = 'top';
grid on;
ax1.GridLineStyle = '-';
yyaxis left
L1_41 = plot(time_hours_2101641,u_2101641,'LineWidth',2);
ylabel('Eastward velocity (m/s)')
ylim([-0.8 0.8])
yyaxis right
L2_41 = plot(time_hours_2101641,temperature_2101641,'LineWidth',2);
ylabel('Temperature (^{\circ}C)')
xlabel('time (hours)')
xlim([0 210])
ylim([26.6 27.8])
% axis tight
%----------------------------------------------------%
ax2 = axes
ax2.Position = [0.05 0.075 0.85 0.4]
ax2.LineWidth = 2;
ax2.FontSize = 20;
ax2.FontWeight = 'Bold';
grid on;
ax2.GridLineStyle = '-';
yyaxis left
L1_42 = plot(time_hours_2101642,u_2101642,'LineWidth',2);
ylabel('Eastward velocity (m/s)')
ylim([-0.8 0.8])
yyaxis right
L2_42 = plot(time_hours_2101642,temperature_2101642,'LineWidth',2);
% axis tight
ylabel('Temperature (^{\circ}C)')
xlabel('time (hours)')
xlim([0 210])
ylim([26.6 27.8])
%-------------------------------------------%
ax = axes
ax.Position = [0.02 0.02 0.98 0.98];
ax.XColor = 'none';ax.YColor = 'none';
ax.Color = 'none'
text(0.7,0.85,'#2101641','FontSize',30)
text(0.7,0.4,'#2101642','FontSize',30)
