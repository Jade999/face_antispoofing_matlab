function Code= Extract_GaborOPP_Image(im1,im2,GW)
[u,v] = size(GW);
cpt=1;
for i = 1:u
    for k=1:u
        if(abs(i-k)<=1)
            for j = 1:v
            im_conv1= abs(conv2(im1,GW{i,j},'same'));
            im_conv2= abs(conv2(im2,GW{k,j},'same'));
            Moy1=mean(mean(im_conv1));
            Moy2=mean(mean(im_conv2));
            im_conv1=im_conv1./Moy1;
            im_conv2=im_conv2./Moy2;
            im_conv=im_conv1-im_conv2;
            im_conv=im_conv.^2;
            Code(cpt)=sqrt(sum(sum(im_conv)));
            cpt=cpt+1;
            end
        end
    end
end
