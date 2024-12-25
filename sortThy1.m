%% REMEMBER PATH CHANGES %%
% Written by Kayla Fernando (12/25/24)

close all
clear all
clc

% Load data
basepath = 'Z:\\home\kayla\Electrophysiology analysis\E-I Ratio in Thy1-ChR2\';
mousepath = '241118 Coronal E-I for sorting.xlsx'; % Naming convention
Thy1_pseudo_EPSC = readtable([basepath mousepath],'Sheet','Thy1 pseudotraining EPSC');
Thy1_pseudo_IPSC = readtable([basepath mousepath],'Sheet','Thy1 pseudotraining IPSC');
Thy1_opto_EPSC = readtable([basepath mousepath],'Sheet','Thy1 optotraining EPSC');
Thy1_opto_IPSC = readtable([basepath mousepath],'Sheet','Thy1 optotraining IPSC');
str = repmat("double", 1, 12); % for table preallocation

% Cutoff thresholds based on EPSC electrode recordings
Ra_threshold = 15.5; 
Ihold_threshold = -550; 

% Triaged Thy1 pseudotrained EPSC data
sort_Thy1_pseudo_EPSC = (Thy1_pseudo_EPSC.Ra_electrode_ <= Ra_threshold & Thy1_pseudo_EPSC.Ihold_electrode_ >= Ihold_threshold);
T_Thy1_pseudo_EPSC = Thy1_pseudo_EPSC(sort_Thy1_pseudo_EPSC,:); clear sort_Thy1_pseudo_EPSC;

% Triaged Thy1 pseudotrained IPSC data
T_Thy1_pseudo_IPSC = table('Size',[0 12],'VariableTypes',str);
T_Thy1_pseudo_IPSC.Properties.VariableNames = ["pA_electrode_","pA_opto_","E_I_electrode_","E_I_opto_","ElecRun","OptoRun", ...
    "Ra_electrode_","Ri_electrode_","Ra_opto_","Ri_opto_","Ihold_electrode_","Ihold_opto_"];    
for ii = 1:size(T_Thy1_pseudo_EPSC,1)
    k = find(Thy1_pseudo_IPSC.E_I_electrode_ == T_Thy1_pseudo_EPSC.E_I_electrode_(ii) & ... 
        Thy1_pseudo_IPSC.E_I_opto_ == T_Thy1_pseudo_EPSC.E_I_opto_(ii));
    sort_Thy1_pseudo_IPSC = Thy1_pseudo_IPSC(k,:);
    T_Thy1_pseudo_IPSC = [T_Thy1_pseudo_IPSC; sort_Thy1_pseudo_IPSC];
end; clear sort_Thy1_pseudo_IPSC

% Triaged Thy1 optotrained EPSC data
sort_Thy1_opto_EPSC = (Thy1_opto_EPSC.Ra_electrode_ <= Ra_threshold & Thy1_opto_EPSC.Ihold_electrode_ >= Ihold_threshold);
T_Thy1_opto_EPSC = Thy1_opto_EPSC(sort_Thy1_opto_EPSC,:); clear sort_Thy1_opto_EPSC;

% Triaged Thy1 optotrained IPSC data
T_Thy1_opto_IPSC = table('Size',[0 12],'VariableTypes',str);
T_Thy1_opto_IPSC.Properties.VariableNames = ["pA_electrode_","pA_opto_","E_I_electrode_","E_I_opto_","ElecRun","OptoRun", ...
    "Ra_electrode_","Ri_electrode_","Ra_opto_","Ri_opto_","Ihold_electrode_","Ihold_opto_"];    
for ii = 1:size(T_Thy1_opto_EPSC,1)
    k = find(Thy1_opto_IPSC.E_I_electrode_ == T_Thy1_opto_EPSC.E_I_electrode_(ii) & ... 
        Thy1_opto_IPSC.E_I_opto_ == T_Thy1_opto_EPSC.E_I_opto_(ii));
    sort_Thy1_opto_IPSC = Thy1_opto_IPSC(k,:);
    T_Thy1_opto_IPSC = [T_Thy1_opto_IPSC; sort_Thy1_opto_IPSC];
end; clear sort_Thy1_opto_IPSC