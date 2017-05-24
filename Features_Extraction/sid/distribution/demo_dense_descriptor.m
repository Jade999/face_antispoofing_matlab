%% Demonstration of 
%% (1) dense descriptor extraction 
%% (2) descriptor invariance to scale and rotation (after FFT)
%%
%% Used to generate the Figure 3 in paper submission
%% 
%% Iasonas Kokkinos
%% iasonas.kokkinos@ecp.fr
%% 

%% descriptor settings 
settings.sc_min = 3;        %% min ring radius
settings.sc_max = 231;      %% max ring radius
settings.nsteps = 28;       %% number of rings
settings.nrays  = 32;       %% number of rays
settings.sc_sig = 0.1400;   %% (Gaussian sigma / ring radius) ratio
settings.nors   = 4;        %% number of derivative orientations
settings.cmp    = 1;        %% compress the invariant descriptor

im1         = imread('img1.pgm');
im2         = imread('img4.pgm');
H           = load('H1to4p');

%% find pixels in image 2 where something from image 1 gets mapped to
[sup_1]     = apply_transform(inv(H),ones(size(im1)));
if 1==2,
    figure,imshow(im1);
    title('Reference image')
    figure,imshow(show_border_clr(double(im2)/255,double(sup_1)>.5,[1,0,0],3))
    title('Query image')
end

%% determine regular point spacing in pixels
%% for fc = 1, we have fully dense points (used for paper figures)
%% for fc = 5, we sample one point per 5x5 patch (used here for speed) 
fc = 10; 

%% compute dense features for original and transformed image
im1=imresize(im1,[64,64]);
[polar_1,desc_1,grd] = get_descriptors(im1,settings,fc);
[polar_2,desc_2,grd] = get_descriptors(im2,settings,fc);

clear feats_shown_1 feats_shown_2;
%% display features 
for s = [1:2],
    for an = [1:2]
        ang_wt  = [1:3];    %% feature orientations (8 are available)
        f_s_wt  = [s];      %% scale frequency (8 are available)
        f_a_wt  = [an];     %% angular frequency (14 are available)
        cn = 0;
        
        for a = ang_wt,
            for f_s = f_s_wt,
                for f_a = f_a_wt
                    cn =  cn + 1;
                    feats_shown_1(:,:,cn) = squeeze(desc_1(a,f_s,f_a,:,:));
                    feats_shown_2(:,:,cn) = squeeze(desc_2(a,f_s,f_a,:,:));
                end
            end
        end
        
        %% bring the features of the transformed image in registration
        %% with the features of the original image 
        [s1,s2,d] = size(feats_shown_1);
        sim     = size(im1);
        tformed = imresize(apply_transform(H,imresize(feats_shown_2,sim)),[s1,s2],'bicubic');
        
        %% stack the original and transformed features side-by-side, and shown them together
        
        shn = double(cat(2,feats_shown_1,tformed));
        shn = shn./max(abs(shn(:)));
        
        figure,
        imshow(shn);
        title(sprintf('Features from the two images, \\omega_s = %i \\omega_a = %i',s,an));
    end
end

%%------------------------------------------------------------
%% show query similarities to two points in the reference image
%%------------------------------------------------------------
ft0 = [[[407,355];[565,365]]];

for k = [1,2],
    %% descriptor on point k
    y1      = round(ft0(k,2)/fc);       x1  = round(ft0(k,1)/fc);
    ds_p1   = desc_1(:,:,:,y1,x1);
    
    %% L2 distance of descriptors in query image
    szd     = size(desc_1);
    dsts    = squeeze(sum(sum(sum((desc_2  - repmat(ds_p1,[1,1,1,szd([4,5])])).^2,1),2),3));   
    sim     = exp(-.1*(dsts - min(min(dsts(:,:)))));
    
    %% smooth a bit, for display
    sim_sm  = smooth_scale(double(sim),1); sim_sm = sim_sm./max(sim_sm(:));
    %sim_sm = sim;
    if k==1,
        sim_1 = sim_sm;
        sim_1o = sim;
    else
        sim_2 = sim_sm;
        sim_2o  = sim;
    end
end

clrs = {'r','g'};
figure,imshow(im1);
for k=1:size(ft0,1),
    hold on,
    scatter(ft0(k,1),ft0(k,2),81,'filled',clrs{k});
end


addpath('sc'); clear sc
t = cat(3,sim_1,double(im2(1:fc:end,1:fc:end))/255);
figure,sc(t,'prob');
title('similarity to red point')

t = cat(3,sim_2,double(im2(1:fc:end,1:fc:end))/255);
figure,sc(t,'prob');
title('similarity to green point')
