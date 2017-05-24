function H=WLD_descriptor(image)
d_image=double(image);


% Determine the dimensions of the input image.
[ysize xsize] = size(image);


% Block size, each WLD code is computed within a block of size bsizey*bsizex
bsizey=3;
bsizex=3;

BELTA=5; % to avoid that center pixture is equal to zero
ALPHA=3; % like a lens to magnify or shrink the difference between neighbors
EPSILON=0.0000001;
PI=3.141592653589;
numNeighbors=8;  % using 3*3 patch for example

% Minimum allowed size for the input image depends
% on the radius of the used LBP operator.
if(xsize < bsizex || ysize < bsizey)
  error('Too small input image. Should be at least (2*radius+1) x (2*radius+1)');
end

% filter
%    1  2  3  4   5  6  7  8  9
f00=[1, 1, 1; 1, -8, 1; 1, 1, 1];


% Calculate dx and dy;
dx = xsize - bsizex;
dy = ysize - bsizey;

% two matriies 
% Initialize the result matrix with zeros.
d_differential_excitation = zeros(dy+1,dx+1);
d_gradient_orientation    = zeros(dy+1,dx+1);

%Compute the WLD code per pixle
for y = 2:ysize-1
    for x = 2:xsize-1
         N=d_image(y-1:y+1,x-1:x+1); % 3*3 block neighbors
         center=d_image(y,x);
        
        % step 1 compute differential excitationt
        v00=sum(sum(f00 .* N));
        v01=center + BELTA; % BELTA to avoid that center pixture is equal to zero

        if ( v01 ~= 0 )
            d_differential_excitation(y,x)=atan(ALPHA*v00/v01);% ALPHA like a lens to magnify or shrink the difference between neighbors
        else
            d_differential_excitation(y,x)=0.1;% set the phase of the current pixel directly by WLD
        end
        
         % step 2 compute gradient orientation
         N1=d_image(y-1,x);         N5=d_image(y+1,x);
         N3=d_image(y,x+1);         N7=d_image(y,x-1);
         
         if ( abs(N7-N3) < EPSILON)		d_gradient_orientation(y,x) = 0;
         else
             v10=N5-N1;		v11=N7-N3;
             d_gradient_orientation(y,x) = atan(v10/v11);
             
             % transform to a degree for convient visualization
             d_gradient_orientation(y,x)=d_gradient_orientation(y,x)*180/PI;
             
             if     (v11 >  EPSILON && v10 >  EPSILON)		
                 d_gradient_orientation(y,x)= d_gradient_orientation(y,x)+ 0;    % the first quadrant
             elseif (v11 < -EPSILON && v10 >  EPSILON)      
                 d_gradient_orientation(y,x)= d_gradient_orientation(y,x)+ 180;  % the second quadrant
             elseif (v11 < -EPSILON && v10 < -EPSILON)      
                 d_gradient_orientation(y,x)= d_gradient_orientation(y,x)+ 180;  % the third quadrant
             elseif (v11 >  EPSILON && v10 < -EPSILON)		
                 d_gradient_orientation(y,x)= d_gradient_orientation(y,x)+ 360;  % the fourth quadrant
             end
         end
    end
end
image_DE = (255* (d_differential_excitation - (-PI/2))/((PI/2)-(-PI/2)));% by mapping the differential excitation to [0,255]
% image_DE=uint8(image_DE);
% h=hist(image_DE(:),0:255);
% h=h/sum(h);
indices=find((d_gradient_orientation>=0)&(d_gradient_orientation<90));
H1=hist(d_gradient_orientation(indices),0:255);
indices=find((d_gradient_orientation>=90)&(d_gradient_orientation<180));
H2=hist(d_gradient_orientation(indices),0:255);
indices=find((d_gradient_orientation>=180)&(d_gradient_orientation<270));
H3=hist(d_gradient_orientation(indices),0:255);
indices=find((d_gradient_orientation>=270)&(d_gradient_orientation<360));
H4=hist(d_gradient_orientation(indices),0:255);
H=[H1 H2 H3 H4];
H=H/sum(H);