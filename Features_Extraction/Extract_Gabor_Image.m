function Code= Extract_Gabor_Image(im,GW)
[u,v] = size(GW);
cpt=1;
for i = 1:u
    for j = 1:v
        im_conv= abs(conv2(im,GW{i,j},'same'));
        Code(1,cpt)=mean(mean(im_conv));
        Code(2,cpt)=std(std(im_conv));
        cpt=cpt+1;
    end
end
Code=reshape(Code,1,numel(Code));