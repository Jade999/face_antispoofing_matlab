function [wer,far,frr] = wer_apriori(wolves, sheep, thrd, cost)
%cost(1) : cost of false acceptance
%cost(2) : cost of false rejection

%wolves and sheep are 1 dimension in column
fa = size(find (wolves >= thrd),1);
fr = size(find (sheep < thrd),1);
far = fa /size(wolves,1) * cost(1);
frr = fr /size(sheep,1) * cost(2);
%fprintf(1, 'far = %2.3f, frr = %2.3f\n', far*100, frr*100);
wer = far + frr;

