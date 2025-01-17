clear, clc
close all

%This script is for latency related analysis  
%this is the code meaning

% virus 0=control, 1=hM4Di
% sex 0=female, 1=male
% drug 0=VEH, 1=CNO, 2=No injection
% TrialType 1=Choice, 2= Forced_Noinfo, 3=Forced_Info
% combvr 0=null 1=OFC hM4Di, 2= BLA hM4Di, 3= ACC hM4Di

%% Here for Training data
% First, read the data file
TrainLat=readtable('TrainLatency.xlsx');
%GLM for training data
glmeLatTrain = fitglme(TrainLat,'median~1+sex*Trial_type+(1+Trial_type|rat)');

%% Here for Stable performance
%Read in the dataset
SteadyLat=readtable('Stable_Latency.xlsx');

SteadyLat(SteadyLat.drug==2,:) = []; % run this only if you want to eliminate No Drug condition

%median latency with trial_type, drug, virus, and sex as predictors
'median lat full model'
glmeLat = fitglme(SteadyLat,'median~1+sex*trial_type*combvr*drug+(1+trial_type+drug|rat)')

%only trial type
glmposthoc = fitglme(SteadyLat,'median~1+trial_type+(1+trial_type|rat)')

