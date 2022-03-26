clear;clc;close all
sample_depth_profile = 200;
filename = './glider-profiles-28901.csv';
fileID = fopen(filename);
all_data = textscan(fileID,'%f %s %f %f %f %f %f %f %s','Delimiter',',',...
    'HeaderLines',1,'EmptyValue',-Inf);
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
%% 200 m
temperature_200m = temperature(depth<=sample_depth_profile,:);
time_formatted_200m = time_formatted(depth<=sample_depth_profile,:);
depth_200m = depth(depth<=sample_depth_profile,:);
latitude_200m = latitude(depth<=sample_depth_profile,:);
longitude_200m = longitude(depth<=sample_depth_profile,:);
%% 50 m
sample_depth_ANOVA = 50;
temperature_50m = temperature(depth<=sample_depth_ANOVA,:);
time_formatted_50m = time_formatted(depth<=sample_depth_ANOVA,:);
depth_50m = depth(depth<=sample_depth_ANOVA,:);
%% The profile of July 20 (0720) from 0 to 200 m
time_0720 = time_single(1);
depth_0720_200m = depth_200m(time_formatted_200m == time_0720,:);
latitude_0720_200m = unique(latitude_200m(time_formatted_200m == time_0720,:));
longitude_0720_200m = unique(longitude_200m(time_formatted_200m == time_0720,:));

%temperature%
temperature_0720_200m = temperature_200m(time_formatted_200m == time_0720,:);
temperature_0720_50m = temperature_50m(time_formatted_50m == time_0720,:);
temperature_0720_50m_mean = mean(temperature_0720_50m);

%% The profile of July 30 (0730) from 0 to 200 m
time_0730 = time_single(79);
depth_0730_200m = depth_200m(time_formatted_200m == time_0730,:);
latitude_0730_200m = unique(latitude_200m(time_formatted_200m == time_0730,:));
longitude_0730_200m = unique(longitude_200m(time_formatted_200m == time_0730,:));

%temperature%
temperature_0730_200m = temperature_200m(time_formatted_200m == time_0730,:);
temperature_0730_50m = temperature_50m(time_formatted_50m == time_0730,:);
temperature_0730_50m_mean = mean(temperature_0730_50m);

%% The profile of Aug 10 (0808) from 0 to 200 m
time_0808 = time_single(157);
depth_0808_200m = depth_200m(time_formatted_200m == time_0808,:);
latitude_0808_200m = unique(latitude_200m(time_formatted_200m == time_0808,:));
longitude_0808_200m = unique(longitude_200m(time_formatted_200m == time_0808,:));

%temperature%
temperature_0808_200m = temperature_200m(time_formatted_200m == time_0808,:);
temperature_0808_50m = temperature_50m(time_formatted_50m == time_0730,:);
temperature_0808_50m_mean = mean(temperature_0808_50m);

%% T - profile
fig=figure
fig.PaperUnits = 'centimeters';
fig.PaperSize = [29.7 21]; % A4 papersize (horizontal,21-by-29.7 cm,[width height])
fig.PaperType = '<custom>';
fig.WindowState = 'maximized';
fig;
ax = axes
% subplot(1,3,1)
L1 = plot(temperature_0720_200m,-depth_0720_200m,'-b.','LineWidth',3);
hold on;
% subplot(1,3,2)
L2 = plot(temperature_0730_200m,-depth_0730_200m,'-g.','LineWidth',3);
hold on;
% subplot(1,3,3)
L3 = plot(temperature_0808_200m,-depth_0808_200m,'-r.','LineWidth',3);
hold off;
ax.LineWidth = 2;
ax.FontSize = 20;
ax.FontWeight = 'Bold';
grid on;
ax.GridLineStyle = '-';
axis tight
ylabel('Depth (m)')
xlabel('Temperature (^{\circ}C)')
title('Seaglider (28901)')
ylim([-Inf 0])
legend([L1,L2,L3],...
    {[char(time_0720) ' (' num2str(latitude_0720_200m) '^{\circ}N, ' ...
    num2str(longitude_0720_200m) '^{\circ}E)'],...
    [char(time_0730) ' (' num2str(latitude_0730_200m) '^{\circ}N, ' ...
    num2str(longitude_0730_200m) '^{\circ}E)'],...
    [char(time_0808) ' (' num2str(latitude_0808_200m) '^{\circ}N, ' ...
    num2str(longitude_0808_200m) '^{\circ}E)']},...
    'Location','best');
%% ANOVA F-testing of ocean temperature
n1 = numel(temperature_0720_50m); % number of samples
n2 = numel(temperature_0730_50m); % number of samples
n3 = numel(temperature_0808_50m); % number of samples

%ANOVA table%
group_mean = sum(temperature_0720_50m_mean+temperature_0730_50m_mean+...
    temperature_0808_50m_mean)/3;
group_number = 3;
data_total_number = n1+n2+n3;
df1 = group_number-1;
df2 = data_total_number-group_number;

SSB = n1*(temperature_0720_50m_mean-group_mean)^2+...
    n2*(temperature_0730_50m_mean-group_mean)^2+...
    n3*(temperature_0808_50m_mean-group_mean)^2;
SST = (temperature_0720_50m_mean-group_mean)^2+...
    (temperature_0730_50m_mean-group_mean)^2+...
    (temperature_0808_50m_mean-group_mean)^2;
SSW = SST-SSB;
MSB = SSB/df1;
MSW = SSW/df2;
F = MSB/MSW;
F_095 = (4.1821+4.0510)/2;
% if abs(t_temperature)>t_095
%     fprintf('***\nRejected...\n');
%     fprintf('The mean temperature of the first profiles is not equal to the last one.\n')
% else
%     fprintf('***\nAccepted...\n');
%     fprintf('The mean temperature of the first profiles is equal to the last one.\n') 
% end