function Code= Extract_LPQ_Image(im,winSize,decorr,freqestim,bloc,overlap,mode,norm)
if(norm==1)
    %%
    %   im=gamma_correction(double(im), [0 1], [0 1], 0.2);
    %   im=dog(im,0.5,1,0);
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
Code=[];
if (bloc==size(im,1))
    Code = lpq(im,winSize,decorr,freqestim,mode);
else
   LPQ_Image = lpq(im,winSize,decorr,freqestim,'im');
   [x,y]=meshgrid(1:overlap:size(LPQ_Image,1)-bloc+1,1:overlap:size(LPQ_Image,2)-bloc+1);
   bbox=[x(:) y(:) x(:)+bloc-1 y(:)+bloc-1]; 
   for i=1:size(bbox,1)
       x1=bbox(i,1);
       x2=bbox(i,3);
       y1=bbox(i,2);
       y2=bbox(i,4);
       region=LPQ_Image(x1:x2,y1:y2);
       result=hist(region(:),0:255);
       if (strcmp(mode,'nh'))
         result=result/sum(result);
       end
       Code=[Code result];       
   end   
end
