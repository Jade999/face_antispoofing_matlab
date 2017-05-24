function Z = rgb2lc(A, lum)
    
    if ~exist('lum','var') || isempty(lum)
        lum = [1 1 1]';
    end

    [row col ~] = size(A);

    l = lum(:);
%     l = l * min(1./l);
    li = l / norm(l)^2;
    e1 = [1 0 0]';

    a =  e1 - dot(e1,l)*li;
    b = cross(a,l);
    
    a = a/norm(a);
    b = b/norm(b);
    
    M = [l a b];
    
    A = reshape(A, [row*col 3]);
    Z = M\A.';
    
    Z = reshape(Z.', [row col 3]);
    Z(:,:,2) = complex(Z(:,:,2), -Z(:,:,3));
    Z(:,:,3) = [];
    
end