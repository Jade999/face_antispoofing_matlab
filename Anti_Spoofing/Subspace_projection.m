function Test_data=Subspace_projection(Test_data,Subspace,method)
if strcmp(method,'PCA') 
                    Test_data=bsxfun(@minus,Test_data,Subspace.mu);
                    Test_data=Test_data*Subspace.coeff;
end
