function [lpq_hist bits1 bits2] = lpqLC(axis, img, fun, params, mask1, mask2)

    if ~exist('mask1', 'var')   mask1=[1 2 3 4  6 7 8 9];   end 
    if ~exist('mask2', 'var')   mask2=[1 2 3 4  6 7 8 9];   end 
    
    PCA = 8;
    colPCA = 10;
    qlev = 2;
    
    img_lc = rgb2lc(img, axis);            


    lpq = eval( ['fun(mask1, img_lc(:,:,1),' params ');'] );
    lpq = lpq(:, :, 1:PCA);
    lpq_hist = int2hist(lpq, qlev);
    bits1 = lpq;
    
    lpq = eval( ['fun(mask2, img_lc(:,:,2),' params ');'] );
    lpq = lpq(:, :, 1:colPCA);
    lpq_hist = [lpq_hist ; int2hist(lpq, qlev)];
    bits2 = lpq;
    
end