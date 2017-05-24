function [lpq_hist] = lpqLABcomplex_face(img, winsize, fun, params, mask1, mask2)

    if ~exist('mask1', 'var')   mask1=[1 2 3 4  6 7 8 9];   end 
    if ~exist('mask2', 'var')   mask2=[1 2 3 4  6 7 8 9];   end 
    
    PCA = 8;
    colPCA = 10;
    qlev = 2;
      
    img = applycform(img, makecform('srgb2lab'));
    img = bsxfun(@rdivide, double(img), reshape([100 128 128],1,1,3));
    img(:,:,2) = complex(img(:,:,2),-img(:,:,3));
    img(:,:,3) = [];
     
        
    lpq = eval( ['fun(mask1, img(:,:,1),' params ');'] );
    lpq = lpq(:, :, 1:PCA);
    lpq_hist = face_feature_clpq_hist(lpq,winsize,qlev);
    
    lpq = eval( ['fun(mask2, img(:,:,2),' params ');'] );
    lpq = lpq(:, :, 1:colPCA);
    lpq_hist = [lpq_hist , face_feature_clpq_hist(lpq,winsize,qlev)];   
     
end