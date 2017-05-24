function Bovw = Train_BOVW(Data,method,dimesion )
if strcmp(method,'Fisher_vector')
    [means,covariances, priors]=vl_gmm(Data,dimesion);
    Bovw.means=means;
    Bovw.covariances=covariances;
    Bovw.priors=priors;
end

