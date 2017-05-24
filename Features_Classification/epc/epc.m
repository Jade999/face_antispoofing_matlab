function [dev, eva, cost]  = epc(dev_wolves, dev_sheep, eva_wolves, eva_sheep, n_samples,range)
%function [dev, eva, cost]  = epc(dev_wolves, dev_sheep, eva_wolves, eva_sheep, n_samples,range)
% Other options
% 
% range : a vector of the form [a,b]
%         It analyses the range from a to b
%         default is [0,1]
% n_samples : the number of samples to take from a to b
if (nargin < 5),
  n_samples =10;
end;
if (nargin < 6),
  range = [0,1];
end;

c_fa = linspace(range(1),range(2),n_samples);
c_fr = 1-c_fa;
cost = [c_fa' c_fr'];

%cost
for i=1:n_samples,
  fprintf(1, '.');
  [dev.wer_apost(i),dev.thrd_fv(i) ] = wer(dev_wolves, dev_sheep, cost(i,:));%pause;
%     dev.thrd_fv(i)=0.5;
  [eva.wer_apost(i),eva.thrd_fv(i) ] = wer(eva_wolves, eva_sheep, cost(i,:));
  [eva.wer_apri(i), eva.war_apri(i), eva.wrr_apri(i)] = wer_apriori(eva_wolves, eva_sheep, dev.thrd_fv(i),cost(i,:));
  [eva.hter_apri(i), eva.far_apri(i), eva.frr_apri(i)] = hter_apriori(eva_wolves, eva_sheep, dev.thrd_fv(i));
end;

