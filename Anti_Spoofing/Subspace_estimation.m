function Subspace=Subspace_estimation(Train_data,Train_labels,method,no_dims)
if strcmp(method,'PCA')
                    Subspace.coeff=pca(Train_data);
                    Subspace.mu=mean(Train_data);
                    Subspace.coeff=Subspace.coeff(:,1:no_dims);  
end
