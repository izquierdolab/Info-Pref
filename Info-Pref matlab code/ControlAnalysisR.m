clear, clc
close all
%05192023: GLM analyses for control group
% sex 0=female, 1=male
% phase 0=Train, 1=BL, 2=CNO, 3=VEH, 4= abs CNO change, 5= abs VEH change
% control type 0= no expression, 1= eGFP, 2= unilateral

%Read in the dataset
Control=readtable('Control.xlsx');


%% For training data
Training = Control(Control.Phase==0,:) %select training data

%Preference (Full model, omnibus GLM) 
'Preference full model'
glmepref = fitglme(Training,'Mean~1+Sex*Control+(1|ID)')



%%
%For change in stable preference 

Stable = Control(Control.Phase>=4,:) %select CNO and VEH change

'Preference for OFC hM4Di vs CON'
glmStable = fitglme(Stable,'Mean~1+Sex*Control*Phase+(1+Phase|ID)')


%%
% For NC preference

NewCues = Control(Control.Phase==6,:) %select NC

%ACCtbl = [ACChM4Di; CON] %combined two tables above to form a tbl with ACC and CON
%See if drugs need to be added here?
'Preference for ACC hM4Di vs CON'
glmNC = fitglme(NewCues,'Mean~1+Sex*Control*Phase+(1+Phase|rat)')

