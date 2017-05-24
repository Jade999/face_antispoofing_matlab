function [F] = cvtRICLBP(img, s, r, M)
%
% RIC-LBP feature extraction
%
%  [F] = cvtRICLBP(img, s, r, M)
% 
%  Input:
%   img - Gray-scale image [height x width]
%   s   - scale of LBP radius [default:1]
%   r   - interval of LBP pair [default:2]
%   M   - mapping table [the table must be based on 4 neighbor pixels]
% 
%  Output:
%   F - Feature vector [136 x 1]
%
% Reference:
% [1] Ryusuke Nosaka, Chendra Hadi Suryanto, Kazuhiro Fukui,
%  "Rotation invariant co-occurrence among adjacent LBPs",
%  International Workshop on Computer Vision With Local Binary Pattern Variants, 2012
% 
% 
% Copyright (C) 2012- Ryusuke Nosaka. All rights reserved.
% 
% *2013-01-09
%  -bug fix
% *2012-12-23
%  -bug fix
% *2012-11-08
%  -created

% init
if ~exist('s', 'var')
    s = 1;
end
if ~exist('r', 'var')
    r = 2;
end

if ~exist('M', 'var') 
    M = [1;2;3;4;5;6;7;8;9;10;11;12;13;14;15;16;...
        5;17;18;19;20;21;22;23;24;25;26;27;28;29;30;31;...
        9;32;33;34;24;35;36;37;38;39;40;41;42;43;44;45;...
        13;46;47;48;28;49;50;51;42;52;53;54;55;56;57;58;...
        2;59;60;61;17;62;63;64;32;65;66;67;46;68;69;70;...
        6;62;71;72;21;73;74;75;35;76;77;78;49;79;80;81;...
        10;65;82;83;25;76;84;85;39;86;87;88;52;89;90;91;...
        14;68;92;93;29;79;94;95;43;89;96;97;56;98;99;100;...
        3;60;101;102;18;71;103;104;33;82;105;106;47;92;107;108;...
        7;63;103;109;22;74;110;111;36;84;112;113;50;94;114;115;...
        11;66;105;116;26;77;112;117;40;87;118;119;53;96;120;121;...
        15;69;107;122;30;80;114;123;44;90;120;124;57;99;125;126;...
        4;61;102;127;19;72;109;128;34;83;116;129;48;93;122;130;...
        8;64;104;128;23;75;111;131;37;85;117;132;51;95;123;133;...
        12;67;106;129;27;78;113;132;41;88;119;134;54;97;124;135;...
        16;70;108;130;31;81;115;133;45;91;121;135;58;100;126;136;];
end



dim = max(M);
ssq = ceil(s/sqrt(2));
sr = ceil(r/sqrt(2));

dr = [0,r; sr,sr; r,0; sr,-sr;]';
nr = size(dr,2);

Z = double(img);
[h, w] = size(Z);

% obtain LBP at every pixels
C = Z(1+s:h-s,1+s:w-s);
X = zeros(8,h-2*s,w-2*s);
X(1,:,:) = Z(1+s-ssq:h-s-ssq,1+s-ssq:w-s-ssq)-C;
X(2,:,:) = Z(1+s-s  :h-s-s  ,1+s    :w-s    )-C;
X(3,:,:) = Z(1+s-ssq:h-s-ssq,1+s+ssq:w-s+ssq)-C;
X(4,:,:) = Z(1+s    :h-s    ,1+s+s  :w-s+s  )-C;
X(5,:,:) = Z(1+s+ssq:h-s+ssq,1+s+ssq:w-s+ssq)-C;
X(6,:,:) = Z(1+s+s  :h-s+s  ,1+s    :w-s    )-C;
X(7,:,:) = Z(1+s+ssq:h-s+ssq,1+s-ssq:w-s-ssq)-C;
X(8,:,:) = Z(1+s    :h-s    ,1+s-s  :w-s-s  )-C;
X = double(X>0);

% obtain a histogram of LBP pair
weight = [0,8,0,4,0,2,0,1];
Ftmp = zeros(16*16,1);
for ci = 1:nr
    A=reshape(weight*X(:,:), h-2*s, w-2*s)+1;
    [hh, ww] = size(A);
    rr = dr(:,ci);
    D = (A(1+r:hh-r, 1+r:ww-r) - 1) * 16;
    Y = A(1+r+rr(1):hh-r+rr(1),1+r+rr(2):ww-r+rr(2)) + D;
    Ftmp = Ftmp + hist(Y(:), 1:(16*16))';
    
    weight = [weight(end) weight(1:end-1)];
end

% combine LBP pair histogram to RIC-LBP histogram
F = zeros(dim,1);
for id = 1:16*16
    F(M(id)) = F(M(id))+Ftmp(id);
end
