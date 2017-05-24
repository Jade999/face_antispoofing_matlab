function [ Faces,labels ] = Get_Faces(txt_path,s,space)
    
     fid = fopen(txt_path,'r');
     data = textscan(fid,'%s %d %d %d %d %d');
     imgpath = data{1};
     boxes = [data{2},data{3},data{4},data{5}];
     labels = data{6};
     labels(labels~=1) = -1;
     for i =1:length(imgpath)
         im = imread(strcat('/raid5/DataCenter/Face/liveness/total/',imgpath{i,1}));
         %rect = [max(1,boxes(i,1)-boxes(i,3)*0.2),max(1,boxes(i,2)-boxes(i,4)*0.2),min(size(im,2),boxes(i,3)*1.4),min(size(im,1),boxes(i,4)*1.4)];
         xo = boxes(i,1)+boxes(i,3)/2; yo = boxes(i,2)+boxes(i,4)/2;
         L = max(boxes(i,3),boxes(i,4))*1.0;
         rect = int32([max(1,xo-L/2),max(1,yo-L/2),min(size(im,2),xo+L/2),min(size(im,1),yo+L/2)]);
         face = im(rect(2):rect(4),rect(1):rect(3),:);
         %face = imcrop(im,rect);
         face = imresize(face,[s,s]);
         %imwrite(face,strcat(num2str(randi(100)),'.jpg'));
         if(strcmp(space,'RGB'))
           face = face; 
         end
         if(strcmp(space,'Gray'))
           face = rgb2gray(face);
         end
         if(strcmp(space,'HSV'))
           face = rgb2hsv(face); 
         end
         if(strcmp(space,'LAB'))
           face = rgb2lab(face) ;
         end 
         if(strcmp(space,'NTSC'))
           face = rgb2ntsc(face);
         end
        if(strcmp(space,'YCbCr'))
            face=rgb2ycbcr(face);
        end
         Faces{i} = face;
     end
end
