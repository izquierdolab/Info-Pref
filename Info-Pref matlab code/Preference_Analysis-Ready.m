clear, clc
close all
%This script works to analyze data related to preference, below see descrip 
% virus 0=control, 1=hM4Di
% sex 0=female, 1=male
% drug 0=VEH, 1=CNO, 2=No injection
% region 1=OFC, 2=BLA, 3=ACC
% combvr 0=null 1=OFC hM4Di, 2= BLA hM4Di, 3= ACC hM4Di (combvr=combined
% virus region) USE THIS
% May2023, Val added pref train and bl last. 
% Phase is 0= train, 1=BL1, 2=BLSS 3= BL NC

%Read in the dataset for stable preference 
SteadyState=readtable('SteadyStateSum.xlsx');

%create an absolute value variable of change and add it to table
abs_change=abs(SteadyState.change)
SteadyState = addvars(SteadyState,abs_change);

%% Here is to run the GLMs for stable preference data

%AbsChange (Full model, omnibus GLM)
'Absolute Change full model'
glmeachange = fitglme(SteadyState,'abs_change~1+combvr*drug*sex+(1+drug|rat)') 

%AbsChange (Model with order effect ONLY FEM)
changefem = SteadyState(SteadyState.sex==0,:); %select females

'Absolute Change fem and order model'
glmeachangefem = fitglme(changefem,'abs_change~1+combvr*drug*order+(1+drug|rat)') 
'Previous did not show sig effect but drug:combvr'

glmeachangefemr = fitglme(changefem,'abs_change~1+combvr*drug*order+(1+drug|rat:order)') 
'Previous did ont show any effect but drug:combvr'
%% here we separate analysis by group (brain region) based on previous GLM
%Select combvr for OFC hM4Di vs CON

OFCtbl = SteadyState(SteadyState.combvr<=1,:) %select OFC and CON

'Absolute Change for OFC hM4Di vs CON'
glmeachangeOFC = fitglme(OFCtbl,'abs_change~1+combvr*drug*sex+(1+drug|rat)') 

%%
%Select combvr for ACC hM4Di vs CON

ACChM4Di = SteadyState(SteadyState.combvr==3,:) %select ACC
CON = SteadyState(SteadyState.combvr==0,:) %select CON

ACCtbl = [ACChM4Di; CON] %combined two tables above to form a tbl with ACC and CON

'Absolute Change for ACC hM4Di vs CON'
glmeachangeACC = fitglme(ACCtbl,'abs_change~1+combvr*drug*sex+(1+drug|rat)') 

%%
%Select combvr for BLA hM4Di vs CON

BLAhM4Di = SteadyState(SteadyState.combvr==2,:) %select BLA
CON = SteadyState(SteadyState.combvr==0,:) %select CON

BLAtbl = [BLAhM4Di; CON] %combined two tables above to form a tbl with BLA and CON

'Absolute Change for BLA hM4Di vs CON'
glmeachangeBLA = fitglme(BLAtbl,'abs_change~1+combvr*drug*sex+(1+drug|rat)') 
%%
%Posthocs analysis for ACC vs Control

ACChM4Di = SteadyState(SteadyState.combvr==3,:) %select ACC
CON = SteadyState(SteadyState.combvr==0,:) %select CON

'Absolute Change for ACC hM4Di '
glmeachangeACC = fitglme(ACChM4Di,'abs_change~1+drug+sex+(1+drug|rat)')
nTests= 2; 
'P for effect of drug' 
glmeachangeACC.Coefficients.pValue(2)*nTests

'Absolute Change for ACC control'
glmeachangeCON = fitglme(CON,'abs_change~1+drug+sex+(1+drug|rat)')
nTests= 2; 
'P for effect of drug' 
glmeachangeCON.Coefficients.pValue(2)*nTests

%% This section is to analyze training data 
%End of training with pre-drug baseline analysis

%Read in the dataset
TrainBL=readtable('TrainBL-Pref.xlsx');

%select only training
TrainBL1= TrainBL(TrainBL.phase<2,:)

%Preference (Full model, omnibus GLM) for train and BL 1
glmetrainbl = fitglme(TrainBL1,'pref~1+sex*phase+(1+phase|rat)')

%%
%Train by session
Training= readtable('Trainingbysession.xlsx');

%Preference (Full model, omnibus GLM) for training acquisition
glmetraining = fitglme(Training,'pref~1+sex*session+(1+session|rat)'); 


