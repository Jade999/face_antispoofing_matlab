function Codes=Extract_FFT_Video(file_vid,file_pos,filter)
[f a b c d]=textread(file_pos,'%f %f %f %f %f');
  vid = VideoReader(file_vid);  
%  vid = mmread(path_vid); 
 nFrames=vid.NumberOfFrames;
 fs=vid.FrameRate;
 cpt=1;
for i=2:52-1   
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
%      im=imresize(im,[64,64]);
     for k=1:size(filter,2)
       features(:,:,k)=abs(imfilter(double(im),filter{k}));
     end 
     Codes(cpt,:)=Region_Covariance(features,size(im,1),size(im,1));
     features=[];
end