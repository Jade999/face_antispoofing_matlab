function [lbl, acc, dec]=Predict_Classifier(Test_data,Test_labels,Model,classifier)
if strcmp(classifier,'SVM')
    [lbl, acc, dec]=predict(Test_labels,sparse(Test_data),Model);
end

end
