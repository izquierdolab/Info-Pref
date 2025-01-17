clear, clc
close all
%03262023: AI got started on GLM analyses for Valeria Gonzalez summary data
%for Response Rate in Steady State
% virus 0=control, 1=hM4Di
% sex 0=female, 1=male
% drug 0=VEH, 1=CNO, 2=No injection
% region 1=OFC, 2=BLA, 3=ACC
% combvr 0=null 1=OFC hM4Di, 2= BLA hM4Di, 3= ACC hM4Di (combvr=combined
% virus region) USE THIS
% 1 CHOICE, 2 NO INFO, 3 INFO

%Read in the dataset
SteadyRR=readtable('Stable_RR.xlsx');


%%
%we do not include the no drug condition which is contained
%intraining analysis
SteadyRR(SteadyRR.drug==2,:) = []; 
%now repeat with CNO vs VEH only
glmeRR = fitglme(SteadyRR,'median~1+cs*combvr*drug*sex+(1+drug|rat:cs)')
%Note 5/25/23: There is still only an effect of sex.

%%
%Here adding for training
%Read in the dataset
TrainRR=readtable('TrainRR-.xlsx');

%full model 
glmeTRR = fitglme(TrainRR,'median~1+cs*sex+(1|rat:cs)')
%%
%Here adding for new cues
%Read in the dataset
NCRR=readtable('NewCuesRR.xlsx');
NCRR(NCRR.drug==2,:) = [];

%ALL
glmeNCRR = fitglme(NCRR,'Median~1+trial*session*combvr*drug*sex+(1+drug*session|rat:trial)')

% by brain region
%BLA first
BLAhM4Di = NCRR(NCRR.combvr==2,:) %select BLA
CON = NCRR(NCRR.combvr==0,:) %select CON

BLARR = [BLAhM4Di; CON]; %combined two tables above to form a tbl with BLA and CON

%BLA GLM
glmblaRR = fitglme(BLARR,'Median~1+sex*combvr*trial*session*drug+(1+session|rat:trial)')


%ACC
ACChM4Di = NCRR(NCRR.combvr==3,:) %select ACC

ACCRR = [ACChM4Di; CON];

glmaccRR = fitglme(ACCRR,'Median~1+sex*combvr*trial*session*drug+(1+session|rat:trial)')

%OFC 
OFCRR= NCRR(NCRR.combvr<=1,:);

glmofcRR = fitglme(OFCRR,'Median~1+sex*combvr*trial*session*drug+(1+session|rat:trial)')


