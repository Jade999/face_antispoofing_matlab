clear;clc;
close all;
addpath(genpath('../Features_Classification/'))
addpath(genpath('../Features_Extraction/'));
addpath(genpath('../Features_Normalization/'));
vl_setup;

load('./Model_0.mat');

obj = videoinput('winvideo', 1, 'I420_640x480');
faceDetector = vision.CascadeObjectDetector;     
h = figure(1);
triggerconfig(obj,'manual');
start(obj);

Spaces = {'HSV','YCbCr'};

while 1 
    frame = ycbcr2rgb(getsnapshot(obj));
    %frame = imread('U:\Face\liveness\total\ULSEE\DanielChen\Image01.jpg');
    bboxes = step(faceDetector,frame);
    if isempty(bboxes)
        imshow(frame);
        drawnow;
       continue; 
    end
    
    for i =1:size(bboxes,1)
         xo = bboxes(i,1)+bboxes(i,3)/2; yo = bboxes(i,2)+bboxes(i,4)/2;
         L = max(bboxes(i,3),bboxes(i,4))*1.2;
         rect = int32([max(1,xo-L/2),max(1,yo-L/2),min(size(frame,2),xo+L/2),min(size(frame,1),yo+L/2)]);
         face = frame(rect(2):rect(4),rect(1):rect(3),:);
         face = imresize(face,[64,64]);
    
         for s = 1:length(Spaces)
             if strcmp(Spaces{s},'HSV')
                 im = rgb2hsv(face);
                 code1 = [];
                 for l = 1:size(im,3)
                    D = Extract_SURF_Image(im(:,:,l),2)';
                    code1 = [code1;D];
                 end
             end
             
             if strcmp(Spaces{s},'YCbCr')
                 im = rgb2ycbcr(face);
                 code2 = [];
                 for l =1:size(im,3)
                    D = Extract_SURF_Image(im(:,:,l),2)';
                    code2 = [code2;D];
                 end
             end
         end
         
         Feature  = [code1;code2];
         Feature = Subspace_projection(double(Feature'),Subspace,'PCA');
         Feature = Feature';
         Feature = vl_fisher(Feature,Bovw.means,Bovw.covariances,Bovw.priors,'SquareRoot','Normalized','Improved')';
         
         [lbl, acc, dec]=predict(1,sparse(Feature),Model);
         sum(Feature ~= 0);
        if lbl == 1
            frame = insertObjectAnnotation(frame,'rectangle',bboxes(i,:),'geninue');
        end
        if lbl == -1
            frame = insertObjectAnnotation(frame,'rectangle',bboxes(i,:),'fake');
        end
  
    end
    
    imshow(frame);
    drawnow;
    
end
delete(obj);
