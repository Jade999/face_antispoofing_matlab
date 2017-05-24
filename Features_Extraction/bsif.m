function bsifdescription = bsif(img,texturefilters,mode)

%% Default parameters
%sigmaBase=1;
%scl=[1 2 4 8]; %sigma=scl(i)*sigmaBase;

% Output mode
if nargin<3
    mode='nh'; % return normalized histogram as default
end

%% Check that input is gray scale
if size(img,3)>1
    error('Only gray scale input');
end

%% Initialize
img=double(img); % Convert image to double
numScl=size(texturefilters,3);%length(scl);
codeImg=ones(size(img));

% Make spatial coordinates for sliding window
r=floor(size(texturefilters,1)/2);%3*max(scl)*sigmaBase;
x=-r:r;

% Wrap image (increase image size according to maximum filter radius by wrapping around)
upimg=img(1:r,:);
btimg=img((end-r+1):end,:);
lfimg=img(:,1:r);
rtimg=img(:,(end-r+1):end);
cr11=img(1:r,1:r);
cr12=img(1:r,(end-r+1):end);
cr21=img((end-r+1):end,1:r);
cr22=img((end-r+1):end,(end-r+1):end);
imgWrap=[cr22,btimg,cr21;rtimg,img,lfimg;cr12,upimg,cr11];

%% Loop over scales
%figf=figure;subplot(numScl/2,2,1);
%counter=1;
for i=1:numScl
  tmp=texturefilters(:,:,numScl-i+1);
  %figure;imagesc(tmp);axis image;axis off; colormap('gray');
  ci=filter2(tmp,imgWrap,'valid');
  
  %figure(figf);subplot(numScl/2,2,i);
  %imagesc(ci);axis image;axis off;
  
  codeImg=codeImg+(ci>0)*(2^(i-1));
    
end

%% Return code image if needed
if strcmp(mode,'im')
    bsifdescription=codeImg;
end

%% Histogram if needed
if strcmp(mode,'nh') || strcmp(mode,'h')
    bsifdescription=hist(codeImg(:),1:(2^numScl));
end

%% Normalize histogram if needed
if strcmp(mode,'nh')
    bsifdescription=bsifdescription/sum(bsifdescription);
end


