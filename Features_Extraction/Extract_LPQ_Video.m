function Codes=Extract_LPQ_Video(Faces,winSize,decorr,freqestim,bloc,overlap,mode,feature,space,norm)
for j=1:size(Faces,2)
             im=Faces{j};

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
%% LPQ Features
if(strcmp(feature,'LPQ'))
    code=[];
     for l=1:size(im,3)
       code=[code Extract_LPQ_Image(im(:,:,l),winSize,decorr,freqestim,bloc,overlap,mode,norm)];
     end
     Codes(j,:)=code;
end
if(strcmp(feature,'CLPQ'))
    code=Extract_CLPQ_Image(im,winSize,bloc,overlap,mode,norm);
    Codes(j,:)=code;
end
end