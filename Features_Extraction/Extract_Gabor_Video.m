function Codes=Extract_Gabor_Video(Faces,GW,space,features)
for j=1:size(Faces,2)
             roi=Faces{j};
             roi=imresize(roi,[64,64]);
%% Color spaces
roi=imresize(roi,[64,64]);
if(strcmp(space,'RGB'))
    im=double(roi);
    im=im./255;    
end
if(strcmp(space,'Gray'))
    im=double(rgb2gray(roi)); 
end
if(strcmp(space,'HSV'))
    im=rgb2hsv(roi); 
end
if(strcmp(space,'YCbCr'))
    im=double(rgb2ycbcr(roi));
    im(:,:,1)=(im(:,:,1)-16)/(235-16);
    im(:,:,2)=(im(:,:,2)-16)/(240-16);
    im(:,:,3)=(im(:,:,3)-16)/(240-16); 
end
if(strcmp(space,'LAB'))
    im=rgb2lab(roi); 
end 
if(strcmp(space,'NTSC'))
    im=rgb2ntsc(roi); 
end 
%% Gabor Features
if(strcmp(features,'Gabor'))
                 code=[];                 
                 for l=1:size(im,3)
                   code=[code Extract_Gabor_Image(im(:,:,l),GW)];
                 end

end
if(strcmp(features,'GaborOPP'))
                 code=[];
                 for i=1:size(im,3)
                     for k=1:size(im,3)
                         if(k>i)
                            code=[code Extract_GaborOPP_Image(im(:,:,i),im(:,:,k),GW)];
                         end
                     end
                 end
end
%%              
Codes(j,:)=code;
       
end 