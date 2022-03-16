clear;clc;close all
x = [1 2 3 4 5];
y = [14 27 20 22 10];

N = numel(y);

mean_y = mean(y);
S = sqrt(sum((y-mean_y).^2)/(N-1));
t = (mean_y-21)/(S/sqrt(N));

figure
plot(x,y)
figure
histogram(y)