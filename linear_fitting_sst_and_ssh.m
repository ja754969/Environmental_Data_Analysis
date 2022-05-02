clear;clc;close all
%% Read the data
load('sst_data.txt')
load('ssh_data.txt')
sst_time = datetime(sst_data(:,1),sst_data(:,2),1);
sst = sst_data(:,3);
ssh_time = datetime(ssh_data(:,1),ssh_data(:,2),1);
ssh = ssh_data(:,3);
%% Linear fitting
% [lin_fit_slope;lin_fit_intercept] = V\M
n = length(ssh);
M = [sum(ssh.^2) sum(ssh); sum(ssh) n];
V = [sum(ssh.*sst);sum(sst)];
reg_comp = M\V;
lin_fit_slope = reg_comp(1);
lin_fit_intercept = reg_comp(2);
%% Find R_square
lin_fit_sst = lin_fit_slope*ssh+lin_fit_intercept;
SS_res = sum((sst-lin_fit_sst).^2);
SS_tot = sum((sst-mean(sst)).^2);
R_square = 1-SS_res/SS_tot;
%% T-test
SSx_tot = sum((ssh-mean(ssh)).^2);
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
scatter(ssh,sst,'rx','LineWidth',2);
xlabel('SSH (cm)')
ylabel('SST (^{\circ}C)')
title('Monthly 1998-2004')
hold on;
plot(ssh,lin_fit_sst,'b-','LineWidth',2)
hold off;
ax.FontSize = 20;
ax_legend = axes;
ax_legend.Color = 'none';
ax_legend.Position = [0.1 0.1 0.8 0.8];
ax_legend.XTick = [];
ax_legend.YTick = [];
text(0.85,0.3,['y = ' num2str(lin_fit_slope) 'x + ' num2str(lin_fit_intercept)],...
    'FontSize',20)
text(0.85,0.2,['R^2 = ' num2str(R_square)],'FontSize',20)
text(0.85,0.1,['T_0 = ' num2str(T) ' (\alpha = 5%, d.f. = ' num2str(n-2) ')'],...
    'FontSize',20)

