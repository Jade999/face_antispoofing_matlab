%% Demonstration of 
%% (1) sparse descriptor extraction 
%% (2) descriptor covariance with scale and rotation (prior to FFT)
%%
%% Used to generate the Figure 2 in paper submission
%% 
%% Iasonas Kokkinos
%% iasonas.kokkinos@ecp.fr
%% 

%% Generate synthetic pattern (square), transform it,
%% and verify that similar descriptors are obtained at corresponding points


%% (x,y) domain where square is defined 
[gr_x,gr_y] = meshgrid([-100:100],[-100:100]);

%% indicator function for interior of square
square  = inline('(abs(gx)<s1).*(abs(gy)<s2)','gx','gy','s1','s2');
%% transformation parameters 
th     = pi/3;
sc     = 2; 
rot    = [cos(th),-sin(th);sin(th),cos(th)];
gr_xr  = (rot(1,1)*gr_x  +rot(1,2)*gr_y)*sc;
gr_yr  = (rot(2,1)*gr_x  +rot(2,2)*gr_y)*sc;

%% square pattern and rotated version 
s1 = 70; s2 = 70;
im_in  = square(gr_x,gr_y,s1,s2);
im_inr = square(gr_xr,gr_yr,s1,s2);

%% point in square interior (first image)
p1x = -30;  p2x = -30;
d1 = (gr_x - p1x).^2  + (gr_y - p2x).^2;
%% coordinates of point in first image 
[y,x] = find(d1==min(d1(:)));

d1r     = (gr_xr - p1x).^2  + (gr_yr - p2x).^2;
%% coordinates of point in second image 
[yr,xr] = find(d1r==min(d1r(:)));


%% descriptor settings 
settings.sc_sig = 0.1400; %% Gaussian scale/distance from center ratio
settings.sc_min = 3.5;    %% min radius
settings.sc_max = 231;    %% max radius
settings.nsteps = 32;     %% number of rings
settings.nors   = 4;      %% number of derivative orientations
settings.nrays  = 28;
settings.cmp    = 1;      %% compress the invariant descriptor


[desc, desc_invar  grd] = get_descriptors(im_in, settings,[],x, y );
[descr,descr_invar,grd] = get_descriptors(im_inr,settings,[],xr,yr);


for it=[1,2]
    if it==1,
        off_y = y;
        off_x = x;
        im_sh = im_in;
        desc_pol = desc;
    else
        off_y = yr;
        off_x = xr;
        im_sh = im_inr;
        desc_pol = descr;
    end
   
    wd = 4;
    figure(1+3);
    subplot(1,2,it);
    imshow(im_sh); 
    hold on,
    scatter(off_x,off_y,81,'filled','r')
    desc_pol = permute(desc_pol,[1,3,2]);
    %% more convenient for display 
    show_polar_descriptor(grd,5*desc_pol,off_x,off_y,1,wd)
    figure(1+it+3)
    for k=1:8,
        subplot(2,4,k)
        imagesc(squeeze(desc_pol(k,:,:)),[0,2]); 
        axis off;
        axis equal;
    end
end


%figure,imagesc(desc_pol(:,
%print('-depsc', fullfile(paperdir,'im0'));
