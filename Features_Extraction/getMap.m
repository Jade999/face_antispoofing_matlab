function [M] = getMap(nB)
%
% Mapping table for RIC-LBP
%
%  [M] = getMap(nB)
% 
%  Input:
%   nB - number of neighbor pixels of LBP [defalut:4]
% 
%  Output:
%   F - mapping table [256 x 1]
%
% Reference:
% [1] 
% 
% 
% 
% Copyright (C) 2012- Ryusuke Nosaka. All rights reserved.
% 
%
% *2012-11-08
%  -created
   


if ~exist('nB', 'var')
    nB = 4;
end

nP = 2^nB;

flag = zeros(nP,nP);
for pi = 1:nP
for pj = 1:nP
    if(flag(pj,pi) == 0)
        b1 = dec2bin(pj-1,nB);
        b2 = dec2bin(pi-1,nB);
        index = pj+(pi-1)*nP;
        flag(bin2dec([b2(nB/2+1:end) b2(1:nB/2)])+1,...
             bin2dec([b1(nB/2+1:end) b1(1:nB/2)])+1) = index;
        flag(pj,pi) = index;
    end
end
end

[~,~,M] = unique(flag(:), 'first');
