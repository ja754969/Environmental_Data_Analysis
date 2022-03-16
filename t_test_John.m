clear;clc;close all
t = [23 25 34 70 200 229 501 509 593 685];
h = [0.3907 0.4226 0.5592 0.9397 -0.342 -0.7547 0.6293 0.515 -0.7986 -0.5736];

df = numel(h)-1;

N = numel(h);
mean_h_population = 0;
mean_h_sample = mean(h);
S = sqrt(sum((h-mean_h_sample).^2)/(N-1));
t = (mean_h_sample-mean_h_population)/(S/sqrt(N));

figure
plot(t,h)
figure
histogram