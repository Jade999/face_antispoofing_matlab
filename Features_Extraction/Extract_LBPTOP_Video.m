function LBP_Codes=Extract_LBPTOP_Video(Faces,XRadius,YRadius,TRadius,XYNeighborPoints,XTNeighborPoints,YTNeighborPoints,mapping,bloc,overlap,nb_frames,chauv,mode,space,norm)
 LBP_Codes=[];
for i=1:chauv:size(Faces,2)
     Im1=[];
     Im2=[];
     Im3=[];     
     cpt=1;
     Code=[];
     for j=i:min(i+nb_frames,size(Faces,2))
             im=Faces{j};
            %% Color spaces
%             if(strcmp(space,'RGB'))
%                 im=roi;
%             end
%             if(strcmp(space,'Gray'))
%                 im=rgb2gray(roi); 
%             end
%             if(strcmp(space,'HSV'))
%                 im=rgb2hsv(roi); 
%             end
%             if(strcmp(space,'YCbCr'))
%                 im=rgb2ycbcr(roi);
%             end
%             if(strcmp(space,'LAB'))
%                 im=rgb2lab(roi); 
%             end 
%             if(strcmp(space,'NTSC'))
%                 im=rgb2ntsc(roi); 
%             end 
%             im=imresize(im,[64,64]);
            if(size(im,3)==1)
             Im1(:,:,cpt)=im(:,:,1);
            else
             Im1(:,:,cpt)=im(:,:,1);
             Im2(:,:,cpt)=im(:,:,2);
             Im3(:,:,cpt)=im(:,:,3);
            end
            cpt=cpt+1;
      end  
      if(size(Im1,3)>10)
          if(size(im,3)==1)
             Code=[Code Extract_LBPTOP_Image(Im1,XRadius,YRadius,TRadius,XYNeighborPoints,XTNeighborPoints,YTNeighborPoints,mapping,bloc,overlap,mode,norm)];
          else
             Code=[Code Extract_LBPTOP_Image(Im1,XRadius,YRadius,TRadius,XYNeighborPoints,XTNeighborPoints,YTNeighborPoints,mapping,bloc,overlap,mode,norm)];
             Code=[Code Extract_LBPTOP_Image(Im2,XRadius,YRadius,TRadius,XYNeighborPoints,XTNeighborPoints,YTNeighborPoints,mapping,bloc,overlap,mode,norm)];
             Code=[Code Extract_LBPTOP_Image(Im3,XRadius,YRadius,TRadius,XYNeighborPoints,XTNeighborPoints,YTNeighborPoints,mapping,bloc,overlap,mode,norm)];
          end
          LBP_Codes=[LBP_Codes; Code];
     end
 end


 