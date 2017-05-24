function [lpq_hist bits1 bits2 bits3] = lpqRGB(img, fun, params, mask1, mask2)

    if ~exist('mask1', 'var')   mask1=[4 7 8 9];   end 
    
    PCA = 8;
    qlev = 2;
    
    clpq = eval( ['fun(mask1, img(:,:,1),' params ');'] );
    lpq = clpq(:, :, 1:PCA);
    lpq_hist = int2hist(lpq, qlev);
    bits1 = lpq;
    
    clpq = eval( ['fun(mask1, img(:,:,2),' params ');'] );
    lpq = clpq(:, :, 1:PCA);
    lpq_hist = [lpq_hist ; int2hist(lpq, qlev)];
    bits2 = lpq;

    clpq = eval( ['fun(mask1, img(:,:,3),' params ');'] );
    lpq = clpq(:, :, 1:PCA);
    lpq_hist = [lpq_hist ; int2hist(lpq, qlev)];
    bits3 = lpq;
     
end