function [polar,invar,grd,X,Y] = get_descriptors(inim,settings,fc,X,Y);
% [polar,invar,grd,X,Y] = get_descriptors(inim,settings,fc,X,Y);
%
% Main function for scale-invariant descriptor construction
% See demo scripts for sparse- and dense- descriptor usage.
%
% Inputs
% inim          : input image
% settings      : settings struct for descriptor construction
% fc            : spacing of points, in pixels (1: fully dense descriptors)
%                 if empty, descriptor locations need to be specified.
% X,Y           : descriptor coordinates (used only if fc is empty)
%
% Outputs
% polar         : normalized orientation- and scale- covariant descriptor
% invar         : invariant descriptor
% grd           : grid used for descriptor construction
% [X,Y]         : locations where descriptors were constructed
%                 do not use if you want image-formated output
%
% Copyright (C) 2012  Iasonas Kokkinos
% iasonas.kokkinos@ecp.fr
%
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
%
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
%
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

if size(inim,3)>1,
    inim = rgb2gray(inim);
end
inim = single(inim);

%% convolution results used for daisy -like descriptors
[dzy,grd,settings]  = init_dzy(inim,settings);

[szv,szh] = size(inim);
if isempty(fc)
    X         = single(min(max(round(X),1),szh)-1);
    Y         = single(min(max(round(Y),1),szv)-1);
else
    [X,Y]     = meshgrid([1:fc:szh],[1:fc:szv]);
    [sz(1),sz(2)] = size(X);
    X         = X(:)';
    Y         = Y(:)';
end

desc     = mex_compute_all_descriptors(dzy.H, dzy.params, dzy.ogrid(:,:,1), dzy.ostable, single(0),single(X'),single(Y'))';
nf       = dzy.HQ;          % number of orientations x polarities
nr       = settings.nrays;  % number of rays
ns       = length(dzy.cind);% number of scales (radii)

% matlab-lisp: make polar and normalize descriptor
%polar =  normalize_polard(make_polard(reshape(desc',[nf,nr,ns,size(desc,1)])));

polar =  normalize_polard(make_polard(reshape(desc',[nf,nr,ns,size(desc,1)]),settings.nors));

if nargout==1,
    %% dense descriptors: reshape to be in original image size
    if ~isempty(fc)
        polar = reshape(polar,[nf,nr,ns,sz(1),sz(2)]);
    end
    return;
end
invar           = get_desc(polar,settings.cmp);

%% dense descriptors: reshape to be in original image size
if ~isempty(fc)
    szd             = size(invar);
    szp             = size(polar);
    invar           = reshape(invar,[szd(1:end-1),sz(1),sz(2)]);
    polar           = reshape(polar,[szp(1:end-1),sz(1),sz(2)]);
end

function descriptor =  make_polard(descriptor,nors)
%% `rotate' directional derivatives so that orientations become relative
%% to ray's angle (Fig. 3 in paper)

[nf,nrays,nsc,np]   = size(descriptor);
descriptor          = reshape(descriptor,[nf,nrays,nsc*np]);
descriptor_out      = zeros([2*nors,nrays,nsc*np],'single');
fracshifts          = nf*[0:nrays-1]/nrays;
angs                = [0:nf-1];
for r = 1:nrays,
        steering_matrix(:,1)   = cos((([0:nors-1]/nors*pi) + (r-1)/nrays*2*pi));
        steering_matrix(:,2)   = sin((([0:nors-1]/nors*pi) + (r-1)/nrays*2*pi));
        steering_matrix        = single(steering_matrix);
        %% steer derivative filters 
        prd                     = steering_matrix*squeeze(descriptor(:,r,:));
        %% polarize
        descriptor_out(:,    r,:) = max([prd;-prd],0);
    
end
descriptor = reshape(descriptor_out,[2*nors,nrays,nsc,np]);

function t = get_desc(feats,cmp)
%% FT of descriptors

%% normalization, so that points around the boundaries get a bit boosted
%% (otherwise their FT will be lower, due to the smaller number of non-zero
%% observations)

mxabs   = squeeze(any(feats,1));
sup     = single(mxabs~=0);
nr      = max(sum(double(mxabs~=0),2),1);
nt      = size(mxabs,2);
%% boosting part
nr      = nr + .5*(nt -nr);
nr      = repmat(1./nr,[1,size(mxabs,2),1]);

for it =size(feats,1):-1:1
    dc = abs(fft(fft(squeeze(feats(it,:,:,:)),[],2).*nr,[],1));
    if cmp==0
        dc = dc(2:[end/2],:,:);
    else
        dc = dc(2:(end/2-6),setdiff([1:end],ceil(end/2)+[-6:7]),:);
    end
    t(it,:,:,:) = dc;
end


function [feats_match] = normalize_polard(feats_match);
%% normalize polar descriptors separately per ring
[nf,nrays,ns,np] = size(feats_match);
rps  = zeros(size(feats_match));

for sc = 1:ns,
    fsc    = feats_match(:,:,sc,:);
    nrm_sc = (sum(sum(pow_2(fsc),1),2));
    
    %% ratio of observed points in ring (max with 1/nrays for robustness)
    cnt_sc = max(sum(any(fsc,1),2),1);
    %% energy in ray (normalized by # of observations)
    nrm_sc = max(sqrt(nrm_sc./cnt_sc),.1);
    feats_match(:,:,sc,:) = fsc./repmat(nrm_sc,[nf,nrays,1,1]);
end

function r = un(i)
r = i - 10*floor(i/10);

function r  = pow_2(x)
r = x.*x;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Daisy code, original by Tola, adapted for this project
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function [dzy,grd,settings] = init_dzy(imin, settings)
%%
SI = 1;
LI = 1;
NT = 1;

sc_min = settings.sc_min;
sc_max = settings.sc_max;
sc_sig = settings.sc_sig;
nsteps = settings.nsteps;
nrays  = settings.nrays;

[grid,sgs]  = log_polar_grid(sc_min,sc_max,nsteps,nrays);
ogrid       = compute_oriented_grid(grid,360);
csigma      = sgs*sc_sig;
cind        = 1:length(sgs);
cn          = length(cind);

im  = single(imin);
h   = size(im,1);
w   = size(im,2);

nors    = settings.nors;     %% how many orientations are estimated
nors_ft = 2*nors;            %% >> are stored (x2 for polarity)
ors = pi*[0:nors-1]/nors;
ors = [ors,ors+pi];

dim = double(im);
%% exploit x-y separability of directional derivative operator
nors = 2; nors_ft = 2;
settings.nors_ft    = nors_ft;
dzy.H               = zeros(h*w,nors_ft,cn,'single');

for r=1:cn
    cu  = max(csigma(r),.5);
    dx  = single((cu))*single(anigauss(dim,cu,cu, -90 , 0, 1));
    dy  = single((cu))*single(anigauss(dim,cu,cu,   0 , 0, 1));
    
    dzy.H(:,1,r) = reshape(dx',h*w,1);
    dzy.H(:,2,r) = reshape(dy',h*w,1);
end

%% compute histograms
HQ = size(dzy.H,2);
TQ = nrays;

dzy.h       = h;
dzy.w       = w;
dzy.TQ      = TQ;
dzy.HQ      = HQ;
dzy.HN      = size(grid,1);
dzy.DS      = dzy.HN*HQ;
dzy.grid    = grid;
dzy.ogrid   = ogrid;
dzy.cind    = cind;
dzy.csigma  = csigma;
dzy.ostable = compute_orientation_shift(HQ,1);
%fprintf(1,'-------------------------------------------------------\n');
dzy.SI = SI;
dzy.LI = LI;
dzy.NT = NT;
dzy.params = single([dzy.DS dzy.HN dzy.h dzy.w 0 0 TQ HQ SI LI NT length(dzy.ostable)]);
dzy.params(11) = 0;
grd = get_grid(dzy);

%% skip the first element
dzy.ogrid           = dzy.ogrid(2:end,:,:);
dzy.grid            = dzy.grid(2:end,:,:);
dzy.HN              = dzy.HN - 1;
dzy.params(2)       = dzy.params(2) - 1;
dzy.params(1)       = dzy.params(1) - 1*dzy.params(end-4);



%% Auxiliary functions  (Copyright by Tola)
% rotate the grid

function ogrid = compute_oriented_grid(grid,GOR)

GN = size(grid,1);
ogrid( GN, 3, GOR )=single(0);
for i=0
    %for i = 0,
    th = -i*2.0*pi/GOR;
    kos = cos( th );
    zin = sin( th );
    for k=1:GN
        y = grid(k,2);
        x = grid(k,3);
        ogrid(k,1,i+1) = grid(k,1);
        ogrid(k,2,i+1) = -x*zin+y*kos;
        ogrid(k,3,i+1) = x*kos+y*zin;
    end
end

% computes the required shift for each orientation
function ostable=compute_orientation_shift(hq,res)
if nargin==1
    res=1;
end
ostable = single(0:res:359)*hq/360;

%% Adaptation of the grid construction routine of Tola
function [grid,Rs]= log_polar_grid(Rmn,Rmx,nr,TQ)

Rs = logspace(log(Rmn)/log(10),log(Rmx)/log(10),nr);
ts = 2*pi/TQ;
RQ = length(Rs);
gs = RQ*TQ+1;

grid(gs,3)   = single(0);
grid(1,1:3)  = [1 0 0];
cnt=1;
for r=0:RQ-1
    for t=0:TQ-1
        cnt=cnt+1;
        rv = Rs(r+1);
        tv = t*ts;
        grid(cnt,1)=r+1;
        grid(cnt,2)=rv*sin(tv); % y
        grid(cnt,3)=rv*cos(tv); % x
    end
end

function grd = get_grid(dzy)
grd0        = squeeze(dzy.ogrid(:,:,1));
grd0 = grd0(2:end,:);
for d = [1:3],
    grd(:,:,d) = permute(reshape(grd0(:,d),[dzy.TQ,length(dzy.cind)]),[2,1]);
end
