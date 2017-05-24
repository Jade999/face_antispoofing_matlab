function [ Model ] = Train_Classifier( Train_data,Train_labels,Train_indices,classifier )
%TRAIN_CLASSIFIER Summary of this function goes here
%   Detailed explanation goes here
if strcmp(classifier,'SVM')
                    folds = 4;
                    C=0:2:16;
                    d=0;
                    for i=1:numel(C)        
                         c=2^C(i);
                         for j=1:folds    
                               Train_data_fold=[Train_data(Train_indices~=j,:)];
                               Dev_data_fold=[Train_data(Train_indices==j,:)];
                               Train_labels_fold=[Train_labels(Train_indices~=j)];  
                               Dev_labels_fold=[Train_labels(Train_indices==j)];
                               model{j} = train(Train_labels_fold,sparse(double(Train_data_fold)), ...          
                                        sprintf('-s %d -c %f', 2,  c));
                               [lbl, acc, dec]=predict(Dev_labels_fold,sparse(Dev_data_fold),model{j});
                              % pause(10);
                               [aaa, bbb, epc_cost]= epc(dec(Dev_labels_fold==-1),dec(Dev_labels_fold==1),dec(Dev_labels_fold==-1),dec(Dev_labels_fold==1), 1,[0.5 0.5]);     
                               EER_dev(j)=aaa.wer_apost(1)*100;
                         end
                         Acc(i)=mean(EER_dev);
                    end
                    [~,ind]=min(Acc);
                    c=2^C(ind)
                    Model= train(Train_labels,sparse(Train_data), ...          
                                         sprintf('-s %d -c %f' ,1,  c));
end

end

