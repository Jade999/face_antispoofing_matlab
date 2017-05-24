%% *************** LOAD A COLOR IMAGE ********************************
A = im2double(imread('guanajuato_car.png'));
A = imcrop(A, [560 333 300 300]);
figure(1);
imshow(A);

%% ************ EXTRACT THE LPQ HISTOGRAM ****************

% qLPQ-Lab:
[clpq_hist bits1 bits2] = lpqLABcomplex(A, @clpq, ' ''Width'', 7 ');

% % qLPQ-lin(0,0,1):
% [clpq_hist bits1 bits2] = lpqLC([0 0 1], A, @clpq, ' ''Width'', 7 ');

% % LPQ-RGB:
% [clpq_hist bits1 bits2 bits3] = lpqRGB(A, @clpq, ' ''Width'', 7 ');

% % LPQ-Lab (this is not in the paper):
% [clpq_hist bits1 bits2 bits3] = lpqLAB(A, @clpq, ' ''Width'', 7 ');

figure(2);
bar(clpq_hist);
title(sprintf('%d bins histogram', length(clpq_hist)) );
grid on;



% ------------------------------------------------------------------------
% ------------------------------------------------------------------------
%  Please, ignore the following code: it is only useful for visualization
% ------------------------------------------------------------------------
% ------------------------------------------------------------------------
if exist('bits3','var')
    LPQimg1 = bsxfun(@times, bits1, reshape(2.^[0:size(bits1,3)-1], 1,1,[]) );
    LPQimg1 = sum(LPQimg1,3) / (2^size(bits1,3)-1);
    LPQimg2 = bsxfun(@times, bits2, reshape(2.^[0:size(bits2,3)-1], 1,1,[]) );
    LPQimg2 = sum(LPQimg2,3) / (2^size(bits2,3)-1);
    LPQimg3 = bsxfun(@times, bits3, reshape(2.^[0:size(bits3,3)-1], 1,1,[]) );
    LPQimg3 = sum(LPQimg3,3) / (2^size(bits3,3)-1);
    
    LPQimg(:,:,1) = LPQimg1;
    LPQimg(:,:,2) = LPQimg2;
    LPQimg(:,:,3) = LPQimg3;
    figure(3); imshow(LPQimg);
    
else
    if exist('bits1','var')
        LPQimg1 = bsxfun(@times, bits1, reshape(2.^[0:size(bits1,3)-1], 1,1,[]) );
        LPQimg1 = sum(LPQimg1,3) / (2^size(bits1,3)-1);
        figure(3); imshow(LPQimg1);
        colormap hot;
    end
    
    if exist('bits2','var')
        LPQimg2 = bsxfun(@times, bits2, reshape(2.^[0:size(bits2,3)-1], 1,1,[]) );
        LPQimg2 = sum(LPQimg2,3) / (2^size(bits2,3)-1);
        figure(4); imshow(LPQimg2);
        colormap hot;
    end
end

clear bits* LPQimg*;

