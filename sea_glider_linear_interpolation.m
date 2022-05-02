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

%% Extract the standard depths from the first profiles of temperature salinity on 20 July. 
sample_depth = find(depth == 10 | depth == 20 | depth == 30 | depth == 50 ...
    | depth == 100 | depth == 150 | depth == 200);
temperature_200m = temperature(sample_depth,:);
salinity_200m = salinity(sample_depth,:);
time_formatted_200m = time_formatted(sample_depth,:);
depth_200m = depth(sample_depth,:);
latitude_200m = latitude(sample_depth,:);
longitude_200m = longitude(sample_depth,:);
%% The profile of July 20 (0720) from 0 to 200 m
time_0720 = time_single(1);
depth_0720_200m = depth_200m(time_formatted_200m == time_0720,:);
latitude_0720_200m = unique(latitude_200m(time_formatted_200m == time_0720,:));
longitude_0720_200m = unique(longitude_200m(time_formatted_200m == time_0720,:));

%temperature%
temperature_0720_200m = temperature_200m(time_formatted_200m == time_0720,:);
%salinity%
salinity_0720_200m = salinity_200m(time_formatted_200m == time_0720,:);
%% Linear Interpolating : 75 m, 125 m
temperature_ITP_75m = temperature_0720_200m(depth_0720_200m==50)+(75-50)/(100-50)*...
    (temperature_0720_200m(depth_0720_200m==100)-temperature_0720_200m(depth_0720_200m==50));
salinity_ITP_75m = salinity_0720_200m(depth_0720_200m==50)+(75-50)/(100-50)*...
    (salinity_0720_200m(depth_0720_200m==100)-salinity_0720_200m(depth_0720_200m==50));
temperature_ITP_125m = temperature_0720_200m(depth_0720_200m==100)+(125-100)/(150-100)*...
    (temperature_0720_200m(depth_0720_200m==150)-temperature_0720_200m(depth_0720_200m==100));
salinity_ITP_125m = salinity_0720_200m(depth_0720_200m==100)+(125-100)/(150-100)*...
    (salinity_0720_200m(depth_0720_200m==150)-salinity_0720_200m(depth_0720_200m==100));
depth_0720_200m = [10;20;30;50;75;100;125;150;200];
temperature_0720_200m = [temperature_0720_200m(1:4);temperature_ITP_75m;...
    temperature_0720_200m(5);temperature_ITP_125m;temperature_0720_200m(6:7)];
salinity_0720_200m = [salinity_0720_200m(1:4);salinity_ITP_75m;...
    salinity_0720_200m(5);salinity_ITP_125m;salinity_0720_200m(6:7)];
%% T & S- profile
fig=figure
fig.PaperUnits = 'centimeters';
fig.PaperSize = [29.7 21]; % A4 papersize (horizontal,21-by-29.7 cm,[width height])
fig.PaperType = '<custom>';
fig.WindowState = 'maximized';
fig;
ax1 = axes
ax1.Position = [0.05 0.1 0.4 0.85];
% subplot(1,2,1)
% yyaxis left
L1 = plot(temperature_0720_200m,-depth_0720_200m,'-','LineWidth',3,'Marker','.');
grid on;
ylabel('Depth (m)')
xlabel('Temperature (^{\circ}C)')
title('Seaglider (28901)')
ax1.LineWidth = 2;
ax1.FontSize = 20;
ax1.FontWeight = 'Bold';
ax1.GridLineStyle = '-';
% % ylim([-Inf 0])
% subplot(1,2,2)
ax2 = axes
ax2.Position = [0.55 0.1 0.4 0.85];
% yyaxis right
L2 = plot(salinity_0720_200m,-depth_0720_200m,'-','LineWidth',3,'Marker','.');
grid on;
xlabel('Salinity (psu)')
ylabel('Depth (m)')
title('Seaglider (28901)')
ax2.LineWidth = 2;
ax2.FontSize = 20;
ax2.FontWeight = 'Bold';
ax2.GridLineStyle = '-';
% axis tight
% ax.View = [0 -90];
