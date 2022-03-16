clear;clc;close all
sample_depth = 50;
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

depth = all_data{:,5};
temperature = all_data{:,6};
salinity = all_data{:,7};
%%
temperature = temperature(depth<=sample_depth,:);
salinity = salinity(depth<=sample_depth,:);
time_formatted = time_formatted(depth<=sample_depth,:);
depth = depth(depth<=sample_depth,:);
%% The first profile of observation
time_first = time_single(1);
depth_first = depth(time_formatted == time_first,:);
n1 = numel(depth_first); % number of samples
%temperature%
temperature_first = temperature(time_formatted == time_first,:);
temperature_first_mean = mean(temperature_first);
temperature_first_std = std(temperature_first);
%salinity%
salinity_first = salinity(time_formatted == time_first,:);
salinity_first_mean = mean(salinity_first);
salinity_first_std = std(salinity_first);
%% The last profile of observation
time_last = time_single(end);
depth_last = depth(time_formatted == time_last,:);
n2 = numel(depth_last); % number of samples
%temperature%
temperature_last = temperature(time_formatted == time_last,:);
temperature_last_mean = mean(temperature_last);
temperature_last_std = std(temperature_last);
%salinity%
salinity_last = salinity(time_formatted == time_last,:);
salinity_last_mean = mean(salinity_last);
salinity_last_std = std(salinity_last);
%% t-testing and F-testing of ocean temperature
df1 = n1-1;
df2 = n2-1;
df = df1+df2;
%t-testing%
t_095 = 1.711;
t_temperature = (temperature_first_mean-temperature_last_mean)/...
    sqrt((temperature_first_mean^2)/n1+(temperature_last_mean^2)/n2);
if abs(t_temperature)>t_095
    fprintf('***\nRejected...\n');
    fprintf('The mean temperature of the first profiles is not equal to the last one.\n')
else
    fprintf('***\nAccepted...\n');
    fprintf('The mean temperature of the first profiles is equal to the last one.\n') 
end
%F-testing%
F_095 = 3.2773;
F_temperature = (temperature_first_std^2)/(temperature_last_std^2);
if abs(F_temperature)>F_095
    fprintf('***\nRejected...\n');
    fprintf('The temperature variation of the first profiles is not equal to the last one.\n')
else
    fprintf('***\nAccepted...\n');
    fprintf('The temperature variation of the first profiles is equal to the last one.\n') 
end
%% t-testing and F-testing of ocean temperature
%t-testing%
t_salinity = (salinity_first_mean-salinity_last_mean)/...
    sqrt((salinity_first_mean^2)/n1+(salinity_last_mean^2)/n2);
if abs(t_temperature)>t_095
    fprintf('***\nRejected...\n');
    fprintf('The mean salinity of the first profiles is not equal to the last one.\n')
else
    fprintf('***\nAccepted...\n');
    fprintf('The mean salinity of the first profiles is equal to the last one.\n') 
end
%F-testing%
F_salinity = (salinity_first_std^2)/(salinity_last_std^2);
if abs(F_salinity)>F_095
    fprintf('***\nRejected...\n');
    fprintf('The salinity variation of the first profiles is not equal to the last one.\n')
else
    fprintf('***\nAccepted...\n');
    fprintf('The salinity variation of the first profiles is equal to the last one.\n') 
end