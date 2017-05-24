function [ TrainData,TrainLabels,TrainIndex,TestData,TestLabels ] = Split_Data( Data,Labels )
 s = length(Labels);
 perm = randperm(s);
 
 Data = double(Data(perm,:));
 Labels = Labels(perm,:);
 
 r = 0.8;
 TrainData = Data(1:floor(r*s),:);
 TrainLabels = Labels(1:floor(r*s),:);
 TrainIndex = rem((1:floor(r*s))-1,4)+1;
 TestData = Data(floor(r*s)+1:end,:);
 TestLabels = Labels(floor(r*s)+1:end,:);
 
    
end


