function Codes=Extract_SID_Video(Faces)
for j=1:size(Faces,2)
im=Faces{j};
% roi=imresize(roi,[64,64]);
%% Color spaces
% if(strcmp(space,'RGB'))
%     im=roi;
% end
% if(strcmp(space,'Gray'))
%     im=rgb2gray(roi); 
% end
% if(strcmp(space,'HSV'))
%     im=rgb2hsv(roi); 
% end
% if(strcmp(space,'YCbCr'))
%     im=rgb2ycbcr(roi);
% end 
% if(strcmp(space,'LAB'))
%     im=rgb2lab(roi); 
% end 
% if(strcmp(space,'NTSC'))
%     im=rgb2ntsc(roi); 
% end 
%  im=imresize(im,[64,64]);
%% BSIF Features
code=[];
 for l=1:size(im,3)
   feature= Extract_SID_Image(im(:,:,l));
   code=[code feature];
 end
 Codes(j,:)=code;
end  