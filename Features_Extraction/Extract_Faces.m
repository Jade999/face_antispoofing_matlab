function Faces=Extract_Faces(file_vid,file_pos,space)
     fileID = fopen(file_pos);
     face_pos=textscan(fileID,'%f %f %f %f %f %f %f %f %f','Delimiter',',');
     vid = VideoReader(file_vid);  
     nFrames=vid.NumberOfFrames;
     fs=vid.FrameRate;
     cpt=1;
     base_points=[16 15; 48 15];
     for j=2:min(nFrames,size(face_pos{1},1))-1
                cframe = read(vid,j);
                if(strcmp(space,'RGB'))
                cframe=(cframe);  
                end
                if(strcmp(space,'Gray'))
                    cframe=(rgb2gray(cframe)); 
                end
                if(strcmp(space,'HSV'))
                    cframe=rgb2hsv(cframe); 
                end
                if(strcmp(space,'YCbCr'))
                    cframe=(rgb2ycbcr(cframe));
                end
                if(strcmp(space,'LAB'))
                    cframe=rgb2lab(cframe); 
                end 
                if(strcmp(space,'NTSC'))
                    cframe=rgb2ntsc(cframe); 
                end 
                input_points(1,1)=face_pos{6}(j);
                input_points(1,2)=face_pos{7}(j);
                input_points(2,1)=face_pos{8}(j);
                input_points(2,2)=face_pos{9}(j);   
                t = cp2tform(input_points,base_points,'linear conformal');
                Faces{cpt}=imtransform(cframe,t,'XData',[1 64], 'YData',[1 64]);
                cpt=cpt+1;
   
     end
    fclose(fileID);
