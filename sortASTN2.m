%% REMEMBER PATH CHANGES %%

%%%% OUTLINE %%%%
% Section 1: Sort spontaneous and synaptic activity
    % RT
        % Collapse data by animal
    % 32C
        % Collapse data by animal
% Section 2: Used for plotting Rt vs. EI, Rt vs. EPSC, Rt vs. IPSC
% Section 3: Sort EC Rec Spike Rate & Coefficient of Variation
    % RT
        % Collapse data by animal
    % 32C
        % Collapse data by animal
% Section 4: Sort pre- and post-gabazine
    % RT
    % 32C

%% Section 1: Sort spontaneous and synaptic activity %%

close all
clear all
clc

%Load the appropriate workspace
%load('EI Ratio Stats ASTN2.mat') %All metrics
%load('EI Ratio Stats ASTN2 with pre-gabazine values.mat') %Re-calculated EPSC, IPSC, and EI only using pre-gabazine EPSC sweeps when applicable
load('EI Ratio Stats ASTN2 for Hatten lab.mat') %All metrics

%Create a table from the selected workspace
%T = table(mouse, sex, genotype, age, date, run, Rt, temp, lobule, gabazine, EPSC, IPSC, EI, spontEPSC, spontIPSC, ePPR, iPPR);
%T = table(mouse, sex, genotype, age, date, run, Rt, temp, lobule, gabazine, EPSC, IPSC, EI);
T = table(mouse, sex, genotype, age, date, run, Rt, temp, lobule, gabazine, EPSC, EPSC_2, IPSC, IPSC_2, EI, spontEPSC, spontIPSC, ePPR, iPPR);

%Change parameters
%Gabazine is a logical: 1 = gabazine application, 0 = no gabazine application
gaba = 1;
%Lowpass cutoff Rt value
threshold = 9;

s1 = 'KO';
s2 = 'WT';
s3 = 'M';
s4 = 'F';
s5 = 'RT';
s6 = '32C';

%% RT %% 

%For KO M at RT
sortKOMale = (T.gabazine == gaba & T.Rt <= threshold & strcmp(T.genotype,s1) & strcmp(T.sex,s3) & strcmp(T.temp,s5));
    T_KOmale = T(sortKOMale,:);

%For WT M at RT
sortWTMale = (T.gabazine == gaba & T.Rt <= threshold & strcmp(T.genotype,s2) & strcmp(T.sex,s3) & strcmp(T.temp,s5));
    T_WTmale = T(sortWTMale,:);
    
%For KO F at RT    
sortKOFemale = (T.gabazine == gaba & T.Rt <= threshold & strcmp(T.genotype,s1) & strcmp(T.sex,s4) & strcmp(T.temp,s5));
    T_KOfemale = T(sortKOFemale,:);
    
%For WT F at RT
sortWTFemale = (T.gabazine == gaba & T.Rt <= threshold & strcmp(T.genotype,s2) & strcmp(T.sex,s4) & strcmp(T.temp,s5));
    T_WTfemale = T(sortWTFemale,:);
    
%For all at RT
sortAll = (T.Rt <= threshold);
    T_all = T(sortAll,:);
    
%% RT Collapse data (by animal) %%

%Change mouse number
mouse = 11;

%Change s3 = 'M' and s4 = 'F' as necessary 
sortCollapse = (T.Rt <= threshold & T.mouse == mouse & strcmp(T.sex,s3) & strcmp(T.temp,s5)); %Must pass threshold and be RT, gabazine is irrelevant
    T_collapse = T(sortCollapse,:);
        T_collapse.genotype
        meanEPSC = mean(T_collapse.EPSC);
        meanEPSC_2 = mean(T_collapse.EPSC_2);
        meanIPSC = mean(T_collapse.IPSC);
        meanIPSC_2 = mean(T_collapse.IPSC_2);
        meanEI = mean(T_collapse.EI);
        meanspontEPSC = mean(T_collapse.spontEPSC);
        meanspontIPSC = mean(T_collapse.spontIPSC);
        meanePPR = mean(T_collapse.ePPR);
        meaniPPR = mean(T_collapse.iPPR);
        C = [meanEPSC meanEPSC_2 meanIPSC meanIPSC_2 meanEI meanspontEPSC meanspontIPSC meanePPR meaniPPR];

%% 32C (will replace previous RT tables) %%
       
%For KO M at 32C
sortKOMale = (T.gabazine == gaba & T.Rt <= threshold & strcmp(T.genotype,s1) & strcmp(T.sex,s3) & strcmp(T.temp,s6));
    T_KOmale = T(sortKOMale,:);
    
%For WT M at 32C
sortWTMale = (T.gabazine == gaba & T.Rt <= threshold & strcmp(T.genotype,s2) & strcmp(T.sex,s3) & strcmp(T.temp,s6));
    T_WTmale = T(sortWTMale,:);
    
%For KO F at 32C    
sortKOFemale = (T.gabazine == gaba & T.Rt <= threshold & strcmp(T.genotype,s1) & strcmp(T.sex,s4) & strcmp(T.temp,s6));
    T_KOfemale = T(sortKOFemale,:);
    
%For WT F at 32C
sortWTFemale = (T.gabazine == gaba & T.Rt <= threshold & strcmp(T.genotype,s2) & strcmp(T.sex,s4) & strcmp(T.temp,s6));
    T_WTfemale = T(sortWTFemale,:);
    
%For all at 32C
sortAll = (T.Rt <= threshold);
    T_all = T(sortAll,:);
    
%% 32C Collapse data (by animal) %%

%Change mouse number
mouse = 11;

%Change s3 = 'M' and s4 = 'F' as necessary 
sortCollapse = (T.Rt <= threshold & T.mouse == mouse & strcmp(T.sex,s3) & strcmp(T.temp,s6)); %Must pass threshold and be 32C, gabazine is irrelevant
    T_collapse = T(sortCollapse,:);
        T_collapse.genotype
        meanEPSC = mean(T_collapse.EPSC);
        meanIPSC = mean(T_collapse.IPSC);
        meanEI = mean(T_collapse.EI);
        meanspontEPSC = mean(T_collapse.spontEPSC);
        meanspontIPSC = mean(T_collapse.spontIPSC);
        meanePPR = mean(T_collapse.ePPR);
        meaniPPR = mean(T_collapse.iPPR);
        C = [meanEPSC meanIPSC meanEI meanspontEPSC meanspontIPSC meanePPR meaniPPR];
  
%% Section 2: Used for plotting Rt vs. EI, Rt vs. EPSC, Rt vs. IPSC %%

C = [T_all.Rt T_all.EI T_all.EPSC T_all.IPSC];

ax1 = subplot(3,1,1);    
x = C(:,1);
y = C(:,2);
coefficients = polyfit(x,y,1);
xFit = linspace(min(x),max(x),10);
yFit = polyval(coefficients,xFit);
scatter(x,y);
hold on;
plot(xFit,yFit);
title('Rt vs E/I');
xlabel('Rt (MOhms)');
ylabel('E/I Ratio');
hold off;

ax2 = subplot(3,1,2);
x = C(:,1);
y = C(:,3);
coefficients = polyfit(x,y,1);
xFit = linspace(min(x),max(x),10);
yFit = polyval(coefficients,xFit);
scatter(x,y);
hold on;
plot(xFit,yFit);
title('Rt vs EPSC');
xlabel('Rt (MOhms)');
ylabel('EPSC (pA)');
hold off;

ax3 = subplot(3,1,3);
x = C(:,1);
y = C(:,4);
coefficients = polyfit(x,y,1);
xFit = linspace(min(x),max(x),10);
yFit = polyval(coefficients,xFit);
scatter(x,y);
hold on;
plot(xFit,yFit);
title('Rt vs IPSC');
xlabel('Rt (MOhms)');
ylabel('IPSC (pA)');
hold off;

linkaxes([ax1, ax2, ax3], 'x');

%% Section 3: Sort EC Rec Spike Rate & Coefficient of Variation %%

close all
clear all
clc

%Load the appropriate workspace
load('EC Recordings Summary Spike Counts.mat')

%Create a table from the selected workspace
T = table(mouse, sex, genotype, age, date, run, temp, rate, CV);

s1 = 'KO';
s2 = 'WT';
s3 = 'M';
s4 = 'F';
s5 = 'RT';
s6 = '32C';

%% RT EC Rec Spike Rate & Coefficient of Variation %% 

%For KO M at RT
sortKOMale = (strcmp(T.genotype,s1) & strcmp(T.sex,s3) & strcmp(T.temp,s5));
    T_KOmale = T(sortKOMale,:);

%For WT M at RT
sortWTMale = (strcmp(T.genotype,s2) & strcmp(T.sex,s3) & strcmp(T.temp,s5));
    T_WTmale = T(sortWTMale,:);
    
%For KO F at RT    
sortKOFemale = (strcmp(T.genotype,s1) & strcmp(T.sex,s4) & strcmp(T.temp,s5));
    T_KOfemale = T(sortKOFemale,:);
    
%For WT F at RT
sortWTFemale = (strcmp(T.genotype,s2) & strcmp(T.sex,s4) & strcmp(T.temp,s5));
    T_WTfemale = T(sortWTFemale,:);
    
%For all at RT
sortAll = (T.mouse >= 1);
    T_all = T(sortAll,:);
    
%% RT Collapse data (by animal) %%

%Change mouse number
mouse = 1;

%Change s3 = 'M' and s4 = 'F' as necessary 
sortCollapse = (T.mouse == mouse & strcmp(T.sex,s3) & strcmp(T.temp,s5)); %Must pass threshold and be RT, gabazine is irrelevant
    T_collapse = T(sortCollapse,:);
        T_collapse.genotype
        meanRate = mean(T_collapse.rate);
        meanCV = mean(T_collapse.CV);
        C = [meanRate meanCV];

%% 32C EC Rec Spike Rate & Coefficient of Variation (will replace previous RT tables) %%
       
%For KO M at 32C
sortKOMale = (strcmp(T.genotype,s1) & strcmp(T.sex,s3) & strcmp(T.temp,s6));
    T_KOmale = T(sortKOMale,:);
    
%For WT M at 32C
sortWTMale = (strcmp(T.genotype,s2) & strcmp(T.sex,s3) & strcmp(T.temp,s6));
    T_WTmale = T(sortWTMale,:);
    
%For KO F at 32C    
sortKOFemale = (strcmp(T.genotype,s1) & strcmp(T.sex,s4) & strcmp(T.temp,s6));
    T_KOfemale = T(sortKOFemale,:);
    
%For WT F at 32C
sortWTFemale = (strcmp(T.genotype,s2) & strcmp(T.sex,s4) & strcmp(T.temp,s6));
    T_WTfemale = T(sortWTFemale,:);
    
%For all at 32C
sortAll = (T.mouse >= 1);
    T_all = T(sortAll,:);
    
%% 32C Collapse data (by animal) %%

%Change mouse number
mouse = 1;

%Change s3 = 'M' and s4 = 'F' as necessary 
sortCollapse = (T.mouse == mouse & strcmp(T.sex,s3) & strcmp(T.temp,s6)); %Must pass threshold and be 32C, gabazine is irrelevant
    T_collapse = T(sortCollapse,:);
        T_collapse.genotype
        meanRate = mean(T_collapse.rate);
        meanCV = mean(T_collapse.CV);
        C = [meanRate meanCV];

%% Section 4: Sort pre- and post-gabazine %%

close all
clear all
clc

%Load the appropriate workspace
load('Pre-gabazine avg Ra EPSCs vs EI Ratio calc with pre-gabazine EPSC.mat')
%load('Post-gabazine avg Ra EPSCs vs EI Ratio calc with post-gabazine EPSC.mat')
%load('ePPR pre- and post-gabazine.mat')
%load('Matched Ra and pre-gabazine ePPR vs post-gabazine ePPR.mat')

%Create a table from the selected workspace
T = table(sex, genotype, temp, Ra, EI);
%T = table(sex, genotype, temp, Ra, EI);
%T = table(sex, genotype, temp, preGABAePPR, postGABAePPR);
%T = table(sex, genotype, temp, preRa, preEPPR, postEPPR);

s1 = 'KO';
s2 = 'WT';
s3 = 'M';
s4 = 'F';
s5 = 'RT';
s6 = '32C';

%% RT pre- and post-gabazine %%

%For KO M at RT
sortKOMale = (strcmp(T.genotype,s1) & strcmp(T.sex,s3) & strcmp(T.temp,s5));
    T_KOmale = T(sortKOMale,:);

%For WT M at RT
sortWTMale = (strcmp(T.genotype,s2) & strcmp(T.sex,s3) & strcmp(T.temp,s5));
    T_WTmale = T(sortWTMale,:);
    
%For KO F at RT    
sortKOFemale = (strcmp(T.genotype,s1) & strcmp(T.sex,s4) & strcmp(T.temp,s5));
    T_KOfemale = T(sortKOFemale,:);
    
%For WT F at RT
sortWTFemale = (strcmp(T.genotype,s2) & strcmp(T.sex,s4) & strcmp(T.temp,s5));
    T_WTfemale = T(sortWTFemale,:);
    
%For all at RT
sortAll = (strcmp(T.temp,s5));
    T_all = T(sortAll,:);
    
%% 32C pre- and post-gabazine (will replace previous RT tables) %%

%For KO M at 32C
sortKOMale = (strcmp(T.genotype,s1) & strcmp(T.sex,s3) & strcmp(T.temp,s6));
    T_KOmale = T(sortKOMale,:);

%For WT M at 32C
sortWTMale = (strcmp(T.genotype,s2) & strcmp(T.sex,s3) & strcmp(T.temp,s6));
    T_WTmale = T(sortWTMale,:);
    
%For KO F at 32C    
sortKOFemale = (strcmp(T.genotype,s1) & strcmp(T.sex,s4) & strcmp(T.temp,s6));
    T_KOfemale = T(sortKOFemale,:);
    
%For WT F at 32C
sortWTFemale = (strcmp(T.genotype,s2) & strcmp(T.sex,s4) & strcmp(T.temp,s6));
    T_WTfemale = T(sortWTFemale,:);
    
%For all at 32C
sortAll = (strcmp(T.temp,s6));
   T_all = T(sortAll,:);