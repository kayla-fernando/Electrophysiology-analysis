%% REMEMBER PATH CHANGES %%

clear all
close all
clc

%Load the appropriate workspace, contains Ra and EI columns from
%sortASTN2.m "Sort pre- and post-gabazine" section
%Also saved as "Pre- and post-gabazine Ra vs E-I" on Excel
load('forGABAplots.mat') 

%Lowpass cutoff Ra value
threshold = 25;

%% RT pre-gabazine %%

%KO males RT pre-gabazine
KOmale = [pre(1:16,1) pre(1:16,2)];
    sortKOmale = (KOmale(:,1) < threshold);
    KOmale = KOmale(sortKOmale,:);

%WT males RT pre-gabazine
WTmale = [pre(1:19,3) pre(1:19,4)];
    sortWTmale = (WTmale(:,1) < threshold);
    WTmale = WTmale(sortWTmale,:);

%KO females RT pre-gabazine
KOfemale = [pre(1:13,5) pre(1:13,6)];
    sortKOfemale = (KOfemale(:,1) < threshold);
    KOfemale = KOfemale(sortKOfemale,:);
    
%WT females RT pre-gabazine
WTfemale = [pre(1:19,7) pre(1:19,8)];
    sortWTfemale = (WTfemale(:,1) < threshold);
    WTfemale = WTfemale(sortWTfemale,:);

%% 32C pre-gabazine %%

%KO males 32C pre-gabazine
KOmale = [pre(1:5,9) pre(1:5,10)]; 
    sortKOmale = (KOmale(:,1) < threshold);
    KOmale = KOmale(sortKOmale,:);

%WT males 32C pre-gabazine
WTmale = [pre(1:5,11) pre(1:5,12)];
    sortWTmale = (WTmale(:,1) < threshold);
    WTmale = WTmale(sortWTmale,:);

%KO females 32C pre-gabazine
KOfemale = [pre(1:8,13) pre(1:8,14)];
    sortKOfemale = (KOfemale(:,1) < threshold);
    KOfemale = KOfemale(sortKOfemale,:);

%WT females 32C pre-gabazine
WTfemale = [pre(1,15) pre(1,16)];
    sortWTfemale = (WTfemale(:,1) < threshold);
    WTfemale = WTfemale(sortWTfemale,:);

%% Make pre-gabazine plots %%

%Make KO male pre-gabazine subplot
hold on;
ax1 = subplot(2,2,1);    
x = KOmale(:,1);
y = KOmale(:,2);
coefficients = polyfit(x,y,1);
xFit = linspace(min(x),max(x),10);
yFit = polyval(coefficients,xFit);
scatter(x,y,'filled','k');
hold off;
hold on;
plot(xFit,yFit,'b');
hold off;

%Make WT male pre-gabazine subplot
hold on;
ax2 = subplot(2,2,3);
x = WTmale(:,1);
y = WTmale(:,2);
coefficients = polyfit(x,y,1);
xFit = linspace(min(x),max(x),10);
yFit = polyval(coefficients,xFit);
scatter(x,y,'filled','k');
hold off;
hold on;
plot(xFit,yFit,'b');
hold off;

%Make KO female pre-gabazine subplot
hold on;
ax3 = subplot(2,2,2);
x = KOfemale(:,1);
y = KOfemale(:,2);
coefficients = polyfit(x,y,1);
xFit = linspace(min(x),max(x),10);
yFit = polyval(coefficients,xFit);
scatter(x,y,'filled','k');
hold off;
hold on;
plot(xFit,yFit,'b');
hold off;

%Make WT female pre-gabazine subplot
hold on;
ax4 = subplot(2,2,4);
x = WTfemale(:,1);
y = WTfemale(:,2);
coefficients = polyfit(x,y,1);
xFit = linspace(min(x),max(x),10);
yFit = polyval(coefficients,xFit);
scatter(x,y,'filled','k');
hold off;
hold on;
plot(xFit,yFit,'b');
hold off;

%% RT post-gabazine %%

%KO males RT post-gabazine
KOmale = [post(1:16,1) post(1:16,2)]; 
    sortKOmale = (KOmale(:,1) < threshold);
    KOmale = KOmale(sortKOmale,:);

%WT males RT post-gabazine
WTmale = [post(1:19,3) post(1:19,4)];
    sortWTmale = (WTmale(:,1) < threshold);
    WTmale = WTmale(sortWTmale,:);

%KO females RT post-gabazine
KOfemale = [post(1:13,5) post(1:13,6)];
    sortKOfemale = (KOfemale(:,1) < threshold);
    KOfemale = KOfemale(sortKOfemale,:);

%WT females RT post-gabazine
WTfemale = [post(1:19,7) post(1:19,8)];
    sortWTfemale = (WTfemale(:,1) < threshold);
    WTfemale = WTfemale(sortWTfemale,:);

%% 32C post-gabazine %%

%KO males 32C post-gabazine
KOmale = [post(1:5,9) post(1:5,10)]; 
    sortKOmale = (KOmale(:,1) < threshold);
    KOmale = KOmale(sortKOmale,:);
    
%WT males 32C post-gabazine
WTmale = [post(1:5,11) post(1:5,12)];
    sortWTmale = (WTmale(:,1) < threshold);
    WTmale = WTmale(sortWTmale,:);

%KO females 32C post-gabazine
KOfemale = [post(1:8,13) post(1:8,14)];
    sortKOfemale = (KOfemale(:,1) < threshold);
    KOfemale = KOfemale(sortKOfemale,:);

%WT females 32C post-gabazine
WTfemale = [post(1,15) post(1,16)];
    sortWTfemale = (WTfemale(:,1) < threshold);
    WTfemale = WTfemale(sortWTfemale,:);

%% Plotting post-gabazine values on top of pre-gabazine values %%

%Make KO male post-gabazine subplot
hold on;
ax5 = subplot(2,2,1);    
x = KOmale(:,1);
y = KOmale(:,2);
coefficients = polyfit(x,y,1);
xFit = linspace(min(x),max(x),10);
yFit = polyval(coefficients,xFit);
scatter(x,y,'filled','r');
hold off;
hold on;
plot(xFit,yFit);
title('KO males');
ylabel('E/I Ratio');
hold off;

%Make WT male post-gabazine subplot
hold on;
ax6 = subplot(2,2,3);
x = WTmale(:,1);
y = WTmale(:,2);
coefficients = polyfit(x,y,1);
xFit = linspace(min(x),max(x),10);
yFit = polyval(coefficients,xFit);
scatter(x,y,'filled','r');
hold off;
hold on;
plot(xFit,yFit);
title('WT males');
xlabel('Ra (MOhms)');
ylabel('E/I Ratio');
hold off;

%Make KO female post-gabazine subplot
hold on;
ax7 = subplot(2,2,2);
x = KOfemale(:,1);
y = KOfemale(:,2);
coefficients = polyfit(x,y,1);
xFit = linspace(min(x),max(x),10);
yFit = polyval(coefficients,xFit);
scatter(x,y,'filled','r');
hold off;
hold on;
plot(xFit,yFit);
title('KO females');
hold off;

%Make WT female post-gabazine subplot
hold on;
ax8 = subplot(2,2,4);
x = WTfemale(:,1);
y = WTfemale(:,2);
coefficients = polyfit(x,y,1);
xFit = linspace(min(x),max(x),10);
yFit = polyval(coefficients,xFit);
scatter(x,y,'filled','r');
hold off;
hold on;
plot(xFit,yFit);
title('WT females');
xlabel('Ra (MOhms)');
hold off;
