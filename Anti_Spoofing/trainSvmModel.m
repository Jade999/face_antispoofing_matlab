
function [] = trainSvmModel( )

clear ;
close all;
clc;
addpath(genpath('../'));
addpath(genpath('../Features_Classification'));
addpath(genpath('../Features_Extraction/'));
addpath(genpath('../Features_Normalization/'));
vl_setup;
Classifier = 'SVM';

load('./FeatureData.mat');
FeatureData(FeatureData(:,end) == 0, :) = [];

Labels = FeatureData(:,end);
FeatureData(:,end) = [];
Labels(Labels(:)~=1) = -1;

[ TrainData,TrainLabels,TrainIndex,TestData,TestLabels ] = Split_Data( FeatureData,Labels );
clear 'FeatureData' 'Labels';
svmModel = Train_Classifier(TrainData,TrainLabels,TrainIndex,Classifier);
[lbl, acc, dec]=Predict_Classifier(TestData,TestLabels,svmModel,Classifier);
display(sprintf('Performance On TestSets: %f\n',acc));
save('svmModel.mat','svmModel');

end

