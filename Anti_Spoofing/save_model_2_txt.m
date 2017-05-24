load('Model_cplus.mat');
fid = fopen('./Model_cplus.txt','w');
%------save svm model
fprintf(fid,'solver_type %s\n','L2R_L2LOSS_SVC_DUAL');
fprintf(fid,'nr_class %d\n',Model.nr_class);
fprintf(fid,'label');
for i =1:length(Model.Label)
   fprintf(fid,' %d',Model.Label(i)); 
end
fprintf(fid,'\n');

fprintf(fid,'nr_feature %d\n',Model.nr_feature);
fprintf(fid,'bias %.16g\n',Model.bias);

fprintf(fid,'w\n');
for i = 1:length(Model.w)
   fprintf(fid,'%.16g ',Model.w(i)); 
end
fprintf(fid,'\n');
%save pca subspace

fprintf(fid,'pca_coeff\n');
for i = 1:size(Subspace.coeff,1)
    for j = 1:size(Subspace.coeff,2)
        fprintf(fid,'%.16g ',Subspace.coeff(i,j)); 
    end
end
fprintf(fid,'\n');
fprintf(fid,'pca_mu\n');
for i = 1:length(Subspace.mu)
    fprintf(fid,'%.16g ',Subspace.mu(i));
end
fprintf(fid,'\n');
%save Bovw 

fprintf(fid,'bovw_means\n');
tmp = Bovw.means(:);
for i = 1:length(tmp)
     fprintf(fid,'%.16g ',tmp(i));
end
% for i = 1:size(Bovw.means,1)
%     for j = 1:size(Bovw.means,2)
%         fprintf(fid,'%.16g ',Bovw.means(i,j));
%     end
% end
fprintf(fid,'\n');
fprintf(fid,'bovw_covariances\n');
tmp = Bovw.covariances(:);
for i = 1:length(tmp)
    fprintf(fid,'%.16g ',tmp(i));
end
% for i = 1:size(Bovw.covariances,1)
%    for j = 1:size(Bovw.covariances,2) 
%        fprintf(fid,'%.16g ',Bovw.covariances(i,j));
%    end
% end
fprintf(fid,'\n');

fprintf(fid,'bovw_priors\n');
for i = 1:length(Bovw.priors)
    fprintf(fid,'%.16g ',Bovw.priors(i));
end
fprintf(fid,'\n');

