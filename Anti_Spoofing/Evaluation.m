
function [ ] = Evaluation(  )


clear ;
close all;
clc;

addpath(genpath('../Features_Classification'));
addpath(genpath('../Features_Extraction/'));
addpath(genpath('../Features_Normalization/'));
vl_setup;

Classifier = 'SVM';
txt_path = './TrainData.txt';

if exist('./Faces_HSV.mat','file')
    load('./Faces_HSV.mat');
else
    [ Faces_HSV,labels1 ] = Get_Faces(txt_path,64,'HSV');
    save('./Faces_HSV.mat','Faces_HSV','labels1','-v7.3');
end
%
Faces_HSV(10000:2:22000) = [];
labels1(10000:2:22000) = [];

Faces_HSV(10000:3:18000) = [];
labels1(10000:3:18000) = [];

if exist('./Features_HSV.mat','file')
    load('./Features_HSV.mat')
else
    Features.data = {};
    for i =1:length(Faces_HSV)
        im = Faces_HSV{i};
        code = [];
        for l = 1:size(im,3)
           D = Extract_SURF_Image(im(:,:,l),2)';
           code = [code;D];
        end
        Features.data{1,end+1} = code;
    end   
   save('./Features_HSV.mat','Features','-v7.3') 
end

Data = cell2mat(Features.data);
clear 'Features' 'Faces_HSV';


%------
if exist('Faces_YCbCr.mat','file')
    load('./Faces_YCbCr.mat');
else
    [Faces_YCbCr,labels2] = Get_Faces(txt_path,64,'YCbCr');
    save('./Faces_YCbCr.mat','Faces_YCbCr','labels2','-v7.3');
end

Faces_YCbCr(10000:2:22000) = [];
labels2(10000:2:22000) = [];

Faces_YCbCr(10000:3:18000) = [];
labels2(10000:3:18000) = [];


if exist('./Features_YCbCr.mat','file')
    load('./Features_YCbCr.mat');
else
    Features.data = {};
    for i =1:length(Faces_YCbCr)
        im = Faces_YCbCr{i};
        code = [];
        for l = 1:size(im,3) 
            D = Extract_SURF_Image(im(:,:,l),2)';
            code = [code;D];
        end
        Features.data{1,end+1} = code;
    end
    save('./Features_YCbCr.mat','Features','-v7.3');

end

Data = [Data; cell2mat(Features.data)];


if isequal(labels1,labels2)
   Labels = double(labels1); 
else
    error('labels were not corresponding!');
end
clear 'Features' 'labels1' 'labels2' 'code' 'D' 'Faces_YCbCr' 'i' 'im' 'l' 'txt_path';

%temporal save
save('./totalData.mat');

%PCA
if exist('./PCA_Subspace.mat','file')
    load('./PCA_Subspace.mat');
else
    perm = randperm(size(Data,2));
    RandData = Data(:,perm(1:1000000));
    Subspace = [];
    Subspace = Subspace_estimation(double(RandData'),Labels,'PCA',384);
    Subspace.coeff = Subspace.coeff(:,1:300);
    save('./PCA_Subspace.mat','Subspace');
    clear 'RandData' 'perm';
end
Data = Subspace_projection(double(Data'),Subspace,'PCA');
Data = Data';
%Fisher vector coding
num_desc = 1024;
cluster = 128;
if exist('./Bovw.mat','file')
    load('./Bovw.mat');
else
    Bovw = Train_BOVW(double(Data),'Fisher_vector',cluster);
    save('./Bovw.mat','Bovw');
end

M = size(Data,2)/num_desc;
N = size(Data,1)*size(Bovw.means,2)*2;
cnt = 1;
Fisher_Data = zeros(M,N);
for i = 1:num_desc:size(Data,2)
   ind = i:i+num_desc-1;
   Fisher_Data(cnt,:) = vl_fisher(Data(:,ind),Bovw.means,Bovw.covariances,Bovw.priors,'SquareRoot','Normalized','Improved');
   cnt = cnt+1;
end

[ TrainData,TrainLabels,TrainIndex,TestData,TestLabels ] = Split_Data( Fisher_Data,Labels );

clear 'Data';

%train model
if strcmp(Classifier,'SVM')
     Model = Train_Classifier(TrainData,TrainLabels,TrainIndex,Classifier);
     [lbl, acc, dec]=Predict_Classifier(TestData,TestLabels,Model,Classifier);
     display(sprintf('Performance On TestSets: %f\n',acc));
     %[com.epc.dev, com.epc.eva, epc_cost]= epc(dec(testLabels==-1,1),dec(testLabels==1,1),dec(testLabels==-1,1),dec(testLabels==1,1), 1,[0.5 0.5]); 
     save('Model.mat','Model','Subspace','Bovw');
end












end

