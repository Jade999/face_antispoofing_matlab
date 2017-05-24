function F = cvtCoALBP(img, s, r, config,mode)
%
% CoALBP feature extraction
%
%  [F] = cvtCoALBP(img, s, r, config)
% 
%  Input:
%   img - Gray-scale image [height x width]
%   s   - scale of LBP radius [default:1]
%   r   - interval of LBP pair [default:2]
%   config - confguration on LBP [default:1]
%          1 for plus configuration (+)
%          2 for cross configuration(x)
% 
%  Output:
%   F - Feature vector [1024 x 1]
%
% Reference:
% [1] R. Nosaka, Y. Ohkawa and K. Fukui,
%     "Feature Extraction Based on Co-occurrence
%       of Adjacent Local Binary Patterns", PSIVT 2011.
% 
% Copyright (C) 2011- Ryusuke Nosaka. All rights reserved.
% 
% *2013-12-18
%  -bug fix
% *2012-11-08
%  -created
%


% init
if ~exist('s', 'var')
    s = 1;
end

if ~exist('r', 'var')
    r = 2;
end

if ~exist('config', 'var')
    config = 1;
end

Z = double(img);
[h w] = size(Z);

C = Z(1+s:h-s,1+s:w-s);
X = zeros(4,h-2*s,w-2*s);

% obtain LBPs at every pixel r
if config == 1     % +
    X(1,:,:) = Z(1+s  :h-s  ,1+s+s:w-s+s)-C;
    X(2,:,:) = Z(1+s-s:h-s-s,1+s  :w-s  )-C;
    X(3,:,:) = Z(1+s  :h-s  ,1+s-s:w-s-s)-C;
    X(4,:,:) = Z(1+s+s:h-s+s,1+s  :w-s  )-C;
elseif config == 2 % x
    X(1,:,:) = Z(1+s-s:h-s-s,1+s-s:w-s-s)-C;
    X(2,:,:) = Z(1+s+s:h-s+s,1+s-s:w-s-s)-C;
    X(3,:,:) = Z(1+s-s:h-s-s,1+s+s:w-s+s)-C;
    X(4,:,:) = Z(1+s+s:h-s+s,1+s+s:w-s+s)-C;    
end

% obtain a LBP pair histogram
X=double(X>0);
A=reshape([1,2,4,8]*X(:,:), h-2*s, w-2*s)+1;
[hh ww] = size(A);
D  = (A(1+r  :hh-r  ,1+r  :ww-r) - 1) * 16;
Y1 = A(1+r  :hh-r  ,1+r+r:ww-r+r) + D;
Y2 = A(1+r-r:hh-r-r,1+r+r:ww-r+r) + D;
Y3 = A(1+r-r:hh-r-r,1+r  :ww-r  ) + D;
Y4 = A(1+r-r:hh-r-r,1+r-r:ww-r-r) + D;

F(:,1) = hist(Y1(:), 1:(16*16));
F(:,2) = hist(Y2(:), 1:(16*16));
F(:,3) = hist(Y3(:), 1:(16*16));
F(:,4) = hist(Y4(:), 1:(16*16));
if(strcmp(mode,'nh'))
   F = F(:)./sum(F(:));
end
F = F';
end

