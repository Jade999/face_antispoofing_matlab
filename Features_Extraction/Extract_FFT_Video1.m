 function Codes=Extract_FFT_Video1(file_vid,file_pos,nb_frames)
[f a b c d]=textread(file_pos,'%f %f %f %f %f');
  vid = VideoReader(file_vid);  
%  vid = mmread(path_vid); 
 nFrames=vid.NumberOfFrames;
 fs=vid.FrameRate;
 cpt=1;
 Codes=zeros(nFrames-2,10);
for i=2:nFrames-1  
    if (d(i)==0)
           if(i==1)
            ind=find(d(i:end)~=0,1);
           else
            ind=(i-2)+find(d(i-1:end)~=0,1) ;   
           end
            a(i)=a(ind);
            b(i)=b(ind);
            d(i)=d(ind);
            c(i)=c(ind);
    end
     cframe = read(vid,i);
     roi=cframe(b(i):b(i)+d(i),a(i):a(i)+c(i),:);
     im=rgb2gray(roi);    
     im=imresize(im,[100,100]);
%%
%      im=homomorph_filter(im,10);
%%
      im=log(double(im)+1);
      im=fft2(im);
      lowg=.5; %(lower gamma threshold, must be lowg < 1)
      highg=0.9;
      sigma=10;
      k=100;
      im=homomorph(im,lowg,highg,sigma,k);
      im=real(ifft2(im));  %inverse 2D fft
      im=exp(im)-1;%     %exponent of result
%%
%     im=gamma_correction(im, [0 1], [0 1], 0.2);
%     im=dog(im,0.5,1,0);
%%
% h=fspecial('gaussian',[7 7],2);
% fim=imfilter(im,h,'replicate');
% im=im-fim;
%%
%       figure 
%       imshow(im,[]);
      im=fftshift(fft2(im));
      [xx,yy] = ndgrid((1:size(im,1))-size(im,1)/2,(1:size(im,2))-size(im,2)/2);      
      for m=1:10
          mask = (((m-1)*5)^2<(xx.^2 + yy.^2))&((xx.^2 + yy.^2)<=(m*5)^2);      
          im1=mask.*im; 
          Codes(cpt,m)=sum(sum(log(abs(im1)+1)));      
      end
      mask = ((xx.^2 + yy.^2)<=50^2);
      im1=~mask.*im;
      Codes(cpt,m+1)=sum(sum(log(abs(im1)+1))); 
%        figure 
%        imshow(log(abs(im)+1),[]);
        cpt=cpt+1;
end
 Codes= mean(Codes);



