function Features=Extract_SURF_Video(Faces,space,box,step)
ind=find(Faces.exist==1);
cpt=1;
for j=1:10:numel(ind)
  if (Faces.exist(ind(j))==1)
        im=Faces.data{ind(j)};
        if(strcmp(space,'Gray'))
            im=rgb2gray(im); 
        end
        if(strcmp(space,'HSV'))
            im=rgb2hsv(im); 
        end
        if(strcmp(space,'YCbCr'))
            im=rgb2ycbcr(im);
        end
        if(strcmp(space,'LAB'))
            im=rgb2lab(im); 
        end 
        if(strcmp(space,'NTSC'))
            im=rgb2ntsc(im); 
        end
        im=imresize(im,box);
        code=[];
         for l=1:size(im,3)
           D= Extract_SURF_Image(im(:,:,l),step)';
           code=[code;D];
         end
        Features.data{1,cpt}=code;   
        Features.exist(cpt,1)=1; 
        cpt=cpt+1;
   else
       Features.exist(j,1)=0;  
   end       
end