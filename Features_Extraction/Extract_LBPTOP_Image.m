function Code= Extract_LBPTOP_Image(im,XRadius,YRadius,TRadius,XYNeighborPoints,XTNeighborPoints,YTNeighborPoints,mapping,bloc,overlap,mode,norm)
if(norm==1)
    %%
%       im=gamma_correction(double(im), [0 1], [0 1], 0.2);
%        im=dog(im,0.5,1,0);
    %%
%     h=fspecial('gaussian',[7 7],1);
%     fim=imfilter(im,h,'replicate');
%     im=im-fim;     
    %%
%           im=log(double(im)+1);
%           im=fft2(im);
%           lowg=.4; %(lower gamma threshold, must be lowg < 1)
%           highg=0.7;
%           sigma=12;
%           k=150;
%           im=homomorph(im,lowg,highg,sigma,k);
%           im=real(ifft2(im)); 
%           im=exp(im)-1;
    %%
%     im=ideal_HPF(im,2);
end
%%
Code=[];
if (bloc==size(im,1))
  Code=LBPTOP(im,XRadius,YRadius,TRadius,XYNeighborPoints,XTNeighborPoints,YTNeighborPoints,mapping,mode);
else 
  [x,y]=meshgrid(1:overlap:size(im,1)-bloc+1,1:overlap:size(im,2)-bloc+1);
   bbox=[x(:) y(:) x(:)+bloc-1 y(:)+bloc-1]; 
   for i=1:size(bbox,1)
       x1=bbox(i,1);
       x2=bbox(i,3);
       y1=bbox(i,2);
       y2=bbox(i,4);
       region=im(x1:x2,y1:y2,:);
       C=LBPTOP(region, FxRadius, FyRadius, TInterval, NeighborPoints, TimeLength, BorderLength, bBilinearInterpolation, Bincount, mapping);
       C=reshape(C',1,size(C,2)*3);
       Code=[Code C];       
   end   
end

