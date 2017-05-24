function Codes=Extract_LBP_Color_Video(Faces,r,v,mapping,bloc,overlap,mode,space,features,norm)
for j=1:size(Faces,2)
             im=Faces{j};
%% Color spaces
if(strcmp(space,'RGB'))
%     im=(roi);  
    max_values=[256 256 256];
    min_values=[0 0 0];
end
if(strcmp(space,'Gray'))
%     im=(rgb2gray(roi)); 
end
if(strcmp(space,'HSV'))
%     im=rgb2hsv(roi); 
    max_values=[1.001 1.001 1.001];
    min_values=[0 0 0];
end
if(strcmp(space,'YCbCr'))
%     im=(rgb2ycbcr(roi));
    max_values=[236 241 241];
    min_values=[16 16 16];
end
if(strcmp(space,'LAB'))
%     im=rgb2lab(roi); 
end 
if(strcmp(space,'NTSC'))
%     im=rgb2ntsc(roi); 
end 
%  im=imresize(im,[64,64]);
%% LBP Features
if(strcmp(features,'LBPMS')||strcmp(features,'LBP')||strcmp(features,'LBP256'))
                 code=[];
                 for l=1:size(im,3)
                   code=[code Extract_LBP_Image(im(:,:,l),r,v,mapping,bloc,overlap,mode,norm)];
                 end
end
if(strcmp(features,'LBPV'))
                  code=[];
                 for l=1:size(im,3)
                   code=[code Extract_LBPV_Image(im(:,:,l),r,v,mapping,bloc,overlap,mode,norm)];
                 end
end
if(strcmp(features,'CoLBP'))
                 code=[];
                 for l=1:size(im,3)
                   code=[code Extract_CoLBP_Image(im(:,:,l),1,2,1,bloc,overlap,mode,norm)];
                 end
end
if(strcmp(features,'CoLBP3'))
                 code=[];
                 for l=1:size(im,3)
                   code=[code Extract_CoLBP_Image(im(:,:,l),1,2,1,bloc,overlap,mode,norm)];
                   code=[code Extract_CoLBP_Image(im(:,:,l),2,4,1,bloc,overlap,mode,norm)];
                   code=[code Extract_CoLBP_Image(im(:,:,l),4,8,1,bloc,overlap,mode,norm)];
                 end
end
if(strcmp(features,'CoLBPx'))
                 code=[];
                 for l=1:size(im,3)
                   code=[code Extract_CoLBP_Image(im(:,:,l),1,2,2,bloc,overlap,mode,norm)];
                 end
end
if(strcmp(features,'LBPOPP'))
                 code=[];
                 for i=1:size(im,3)
                     for k=1:size(im,3)
                       code=[code Extract_LBPOPP_Image(im(:,:,i),im(:,:,k),r,v,mapping,bloc,overlap,mode,norm)];
                     end
                 end
end
%% Color features
if(strcmp(features,'Color(16 16 16)'))
             code=[];
             bins=[16 16 16];
             for l=1:size(im,3)
               code=[code Color_histogram(im(:,:,l),max_values(l),min_values(l),bins(l))]; 
             end	
end
if(strcmp(features,'Color(32 32 32)'))
             code=[];
             bins=[32 32 32];
             for l=1:size(im,3)
               code=[code Color_histogram(im(:,:,l),max_values(l),min_values(l),bins(l))];
             end	
end
if(strcmp(features,'Color(64 64 64)'))
             code=[];
             bins=[64 64 64];
             for l=1:size(im,3)
               code=[code Color_histogram(im(:,:,l),max_values(l),min_values(l),bins(l))];
             end	
end
%%              
Codes(j,:)=code;
       
end   


 