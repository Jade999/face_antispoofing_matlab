function Codes=Extract_Quality_Video(Faces)
for j=1:size(Faces,2)
         roi=Faces{j};
         roi=imresize(roi,[64,64]);
%% Color spaces
%             im=roi;
        im=rgb2gray(roi);  
%             im=rgb2hsv(roi);
%             im=rgb2ntsc(roi);
%             im=rgb2lab(roi);
%              im=rgb2ycbcr(roi);
%% Quality mesurments
         code=[];
         for l=1:size(im,3)
           code=[code Image_Smouthness(im(:,:,l))];             
         end
         Codes(j,:)=code;
end


 