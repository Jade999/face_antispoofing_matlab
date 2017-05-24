function [res] = smooth_scale(im,sc);
% [res] = smooth_scale(im,sc)
% smooths an image at scale sc using normalized gaussian convolution and
% is better behaved than matlab's imsmooth function around boundaries
%
% im: single/double rgb image
% sc: standard deviation (in pixels) of the gaussian used for filtering
filt_wt = gauss_filt2(sc^2);
res  =filter2(filt_wt,im);
nrm = max(filter2(filt_wt,ones(size(im))),eps);
res = res./max(nrm,eps);

function res = gauss_filt2(spread1,spread2)
if nargin==1,
    spread2 = spread1;
end
lim1 =  floor(3.2*sqrt(spread1));
lim2 =  floor(3.2*sqrt(spread2));

gauss_1 = gauss_nd([-lim1:lim1],0,spread1);
gauss_2 = gauss_nd([-lim2:lim2],0,spread2);
res = kron(gauss_1,gauss_2');
res = res./sum(sum(res));

function res = gauss_nd(x,m,s);
res = 1/(sqrt(2*pi)*s).*(exp(-(x-m).^2/(2*s.^2)));
