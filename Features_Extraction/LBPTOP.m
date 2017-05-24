function [H,HXY, HXT, HYT]=LBPTOP(Data,XRadius,YRadius,TRadius,XYNeighborPoints,XTNeighborPoints,YTNeighborPoints,mapping,mode)
[height width Length] = size(Data);
for p = 1:XYNeighborPoints
    XYpoints(p,1) = YRadius * sin((2 * pi * (p-1)) / XYNeighborPoints);
    XYpoints(p,2) = XRadius*cos((2 * pi * (p-1)) / XYNeighborPoints);
end
for p = 1:XTNeighborPoints
    XTpoints(p,1) =XRadius * cos((2 * pi * (p-1)) / XTNeighborPoints);
    XTpoints(p,2) = TRadius * sin((2 * pi * (p-1)) / XTNeighborPoints);
end
for p = 1:YTNeighborPoints
    YTpoints(p,1) =YRadius * sin((2 * pi * (p-1)) / YTNeighborPoints);
    YTpoints(p,2) = TRadius * cos((2 * pi * (p-1)) / YTNeighborPoints);
end
bins = (2^XYNeighborPoints)+(2^XTNeighborPoints)+(2^YTNeighborPoints);
%% XY Plane
dx=width-2*XRadius-1;
dy=height-2*YRadius-1;
originx=XRadius+1;
originy=YRadius+1;
LBPXY=zeros(dy+1,dx+1,Length-2);
for t=TRadius+1:Length-TRadius   
  im=Data(:,:,t);
  d_im=double(im);
  C=im(originy:originy+dy,originx:originx+dx);  
  d_C=double(C);
  for p=1:XYNeighborPoints      
   x = originx + XYpoints(p,2);
   y = originy - XYpoints(p,1);
   fy = floor(y); cy = ceil(y); ry = round(y);
   fx = floor(x); cx = ceil(x); rx = round(x);
   if (abs(x - rx) < 1e-6) && (abs(y - ry) < 1e-6)
    % Interpolation is not needed, use original datatypes
    N = im(ry:ry+dy,rx:rx+dx);
    D = N >= C; 
  else
    % Interpolation needed, use double type images 
    ty = y - fy;
    tx = x - fx;

    % Calculate the interpolation weights.
%     w1 = roundn((1 - tx) * (1 - ty),-6);
%     w2 = roundn(tx * (1 - ty),-6);
%     w3 = roundn((1 - tx) * ty,-6) ;
%     % w4 = roundn(tx * ty,-6) ;
%     w4 = roundn(1 - w1 - w2 - w3, -6);
    w1 = (1 - tx) * (1 - ty);
    w2 = tx * (1 - ty);
    w3 = (1 - tx) * ty;
    w4 = tx * ty;
             
    % Compute interpolated pixel values
    N = w1*d_im(fy:fy+dy,fx:fx+dx) + w2*d_im(fy:fy+dy,cx:cx+dx) + ...
        w3*d_im(cy:cy+dy,fx:fx+dx) + w4*d_im(cy:cy+dy,cx:cx+dx);
    N = roundn(N,-4);
    D = N >= d_C; 
   end  
   % Update the result matrix.
   v = 2^(p-1);
   LBPXY(:,:,t-TRadius) = LBPXY(:,:,t-TRadius) + v*D;  
  end
end
%% XT Plane
dx=width-2*XRadius-1;
dz=Length-2*TRadius-1;
originx=XRadius+1;
originz=TRadius+1;
LBPXT=zeros(dx+1,dz+1,height-2);
for y=YRadius+1:height-YRadius   
  im=squeeze(Data(y,:,:));
  d_im=double(im);
  C=im(originx:originx+dx,originz:originz+dz);  
  d_C=double(C);
  for p=1:XTNeighborPoints      
   x = originx+ XTpoints(p,1);
   z = originz+ XTpoints(p,2);
   fz = floor(z); cz = ceil(z); rz = round(z);
   fx = floor(x); cx = ceil(x); rx = round(x);
   if (abs(x - rx) < 1e-6) && (abs(z - rz) < 1e-6)
    % Interpolation is not needed, use original datatypes
    N = im(rx:rx+dx,rz:rz+dz);
    D = N >= C; 
  else
    % Interpolation needed, use double type images 
    tz = z - fz;
    tx = x - fx;

    % Calculate the interpolation weights.
%     w1 = roundn((1 - tx) * (1 - tz),-6);
%     w2 = roundn(tz * (1 - tx),-6);
%     w3 = roundn((1 - tz) * tx,-6) ;
%     % w4 = roundn(tx * ty,-6) ;
%     w4 = roundn(1 - w1 - w2 - w3, -6);
    w1 = (1 - tx) * (1 - tz);
    w2 = tz * (1 - tx);
    w3 = (1 - tz) * tx ;
    w4 = tx * tz ;
   
            
    % Compute interpolated pixel values
    N = w1*d_im(fx:fx+dx,fz:fz+dz) + w2*d_im(fx:fx+dx,cz:cz+dz) + ...
        w3*d_im(cx:cx+dx,fz:fz+dz) + w4*d_im(cx:cx+dx,cz:cz+dz);
    N = roundn(N,-4);
    D = N >= d_C; 
   end  
   % Update the result matrix.
   v = 2^(p-1);
   LBPXT(:,:,y-YRadius) = LBPXT(:,:,y-YRadius) + v*D;  
  end
end
%% YT Plane
dy=height-2*YRadius-1;
dz=Length-2*TRadius-1;
originy=YRadius+1;
originz=TRadius+1;
LBPYT=zeros(dy+1,dz+1,width-2);
for x=XRadius+1:width-XRadius   
  im=squeeze(Data(:,x,:));
  d_im=double(im);
  C=im(originy:originy+dy,originz:originz+dz);  
  d_C=double(C);
  for p=1:YTNeighborPoints      
   y = originy - YTpoints(p,1);
   z = originz + YTpoints(p,2);
   fz = floor(z); cz = ceil(z); rz = round(z);
   fy = floor(y); cy = ceil(y); ry = round(y);
   if (abs(y - ry) < 1e-6) && (abs(z - rz) < 1e-6)
    % Interpolation is not needed, use original datatypes
    N = im(ry:ry+dy,rz:rz+dz);
    D = N >= C; 
  else
    % Interpolation needed, use double type images 
    tz = z - fz;
    ty = y - fy;
    % Calculate the interpolation weights.
%     w1 = roundn((1 - tz) * (1 - ty),-6);
%     w2 = roundn(tz * (1 - ty),-6);
%     w3 = roundn((1 - tz) * ty,-6) ;
%     % w4 = roundn(tx * ty,-6) ;
%     w4 = roundn(1 - w1 - w2 - w3, -6);
    w1 = (1 - tz) * (1 - ty);
    w2 = tz * (1 - ty);
    w3 = (1 - tz) * ty ;
    w4 = tz* ty ;  
            
    % Compute interpolated pixel values
    N = w1*d_im(fy:fy+dy,fz:fz+dz) + w2*d_im(fy:fy+dy,cz:cz+dz) + ...
        w3*d_im(cy:cy+dy,fz:fz+dz) + w4*d_im(cy:cy+dy,cz:cz+dz);
    N = roundn(N,-4);
    D = N >= d_C; 
   end  
    % Update the result matrix.
    v = 2^(p-1);
    LBPYT(:,:,x-XRadius) = LBPYT(:,:,x-XRadius) + v*D;  
   end
end
%% Apply mapping if it is defined
if isstruct(mapping)
    bins = mapping.num;
    for i = 1:size(LBPXY,1)
        for j = 1:size(LBPXY,2)
            for k = 1:size(LBPXY,3)
              LBPXY(i,j,k) = mapping.table(LBPXY(i,j,k)+1);
              LBPXT(j,k,i) = mapping.table(LBPXT(j,k,i)+1);
              LBPYT(i,k,j) = mapping.table(LBPYT(i,k,j)+1);
            end           
        end
    end
 end
%%  Results 
if (strcmp(mode,'h') || strcmp(mode,'hist') || strcmp(mode,'nh'))
    % Return with LBP histogram if mode equals 'hist'.
    HXY=hist(LBPXY(:),0:(bins-1));
    HXT=hist(LBPXT(:),0:(bins-1));
    HYT=hist(LBPYT(:),0:(bins-1));
    if (strcmp(mode,'nh'))
        HXY=HXY/sum(HXY);
        HXT=HXT/sum(HXT);
        HYT=HYT/sum(HYT);
    end
    H=[HXY HXT HYT];
else
    if ((bins-1)<=intmax('uint8'))
        HXY=uint8(LBPXY);
        HXT=uint8(LBPXT);
        HYT=uint8(LBPYT);
    else
        if ((bins-1)<=intmax('uint16'))
        HXY=uint16(LBPXY);
        HXT=uint16(LBPXT);
        LBPYT=uint16(LBPYT);
       else
        HXY=uint32(LBPXY);
        HXT=uint32(LBPXT);
        HYT=uint32(LBPYT);
        end
    end
  end
end
%% 
function x = roundn(x, n)
error(nargchk(2, 2, nargin, 'struct'))
validateattributes(x, {'single', 'double'}, {}, 'ROUNDN', 'X')
validateattributes(n, ...
    {'numeric'}, {'scalar', 'real', 'integer'}, 'ROUNDN', 'N')

if n < 0
    p = 10 ^ -n;
    x = round(p * x) / p;
elseif n > 0
    p = 10 ^ n;
    x = p * round(x / p);
else
    x = round(x);
end
end
