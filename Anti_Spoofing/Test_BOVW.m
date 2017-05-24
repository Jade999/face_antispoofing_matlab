function [Test_data, Test_labels,Test_indices] = Test_BOVW(Data,labels,Indices,Bovw,method,num_desc)
if strcmp(method,'Fisher_vector')
 cpt=1;
 M=size(Data,2)/num_desc;
 N=size(Data,1)*size(Bovw.means,2)*2;
 Test_data=zeros(M,N);
 for i=1:num_desc:size(Data,2)
     ind=i:i+num_desc-1;
     Test_data(cpt,:)= vl_fisher(Data(:,ind),Bovw.means,Bovw.covariances,Bovw.priors,'SquareRoot','Normalized','Improved');   
     Test_labels(cpt,1)=mean(labels(ind));
     if ~isempty(Indices)
      Test_indices(cpt,1)=mean(Indices(ind));
     end
     cpt=cpt+1
 end
end

