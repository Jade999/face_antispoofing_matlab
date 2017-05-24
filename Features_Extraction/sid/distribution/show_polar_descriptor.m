function show_polar_descriptor(grd,descriptor,ch,cv,pol,wd)
%show_polar_descriptor(grd,descriptor,ch,cv,pol,wd)
%
% shows a log-polar descriptor
% grd is the grid used to construct the log-polar descriptor
% descriptor contains the directional derivative information,
% as encapsulated in the descriptor
% ch, cv are the descriptor coordinates
% wd is the linewidth
%
% Iasonas Kokkinos
% iasonas.kokkinos@ecp.fr

v1h = [];
v1v = [];
v2h = [];
v2v = [];
hs  = [];
vs  = [];
scs =[];
cnt = 0;
[nf,nscales,nrays] = size(descriptor);
%nf
if ~exist('pol','var'),
    pol = 0;
end
scsu = unique(unique(grd(:,1,3)));
for sci = 1:length(scsu),
    h = draw_circle([ch;cv], scsu(sci),[1/2,1/2,1/2]);
    set(h,'linewidth',wd/2);
end
for ray =  [1:nrays],
    grwt = grd(1,ray,:);
    or0 = atan2(grwt(2),grwt(3));
    h  = plot([ch+scsu(1)*sin(or0),ch + scsu(end)*sin(or0)],[cv+scsu(1)*cos(or0),cv + scsu(end)*cos(or0)],'color',[1/2,1/2,1/2],'linewidth',wd/2);
end

for ray =[1:nrays]
    for scd= [1:nscales],
        grwt = grd(scd,ray,:);
        cnt = cnt + 1;
        or0 = atan2(grwt(2),grwt(3));
        
        for it = [1:nf],
            
            sc = descriptor(it,scd,ray);
            or = 2*(it-1)*pi/nf;
            if pol,
                or = or0 + or;
            else
                or = or; 
            end
            crv = grwt(2);
            crh = grwt(3);
            
            scs = [scs,sc];
            hs=  [hs,crh+ch];
            vs = [vs,crv+cv];
            v1h = [v1h,sc*cos(or)];
            v1v = [v1v,sc*sin(or)];
            v2h = [v2h,-sc*cos(or)];
            v2v = [v2v,-sc*sin(or)];
            
        end
    end
end

pos = find(scs>0);
hold on;
for k=1:length(pos)
    plot(hs(pos(k))+[v1h(pos(k)),v2h(pos(k))]',vs(pos(k)) + [v1v(pos(k)),v2v(pos(k))]','color',[1,1/2,0],'linewidth',wd);
end

pos = find(scs<0);
hold on;
for k=1:length(pos)
    plot(hs(pos(k))+[v1h(pos(k)),v2h(pos(k))]',vs(pos(k)) + [v1v(pos(k)),v2v(pos(k))]','r','linewidth',wd);
end


function h = draw_circle(x, r, outline_color, fill_color)
% draw filled circles at centers x with radii r.
% x is a matrix of columns.  r is a row vector.

n = 40;					% resolution
radians = [0:(2*pi)/(n-1):2*pi];
unitC = [sin(radians); cos(radians)];

% extend r if necessary
if length(r) < size(x,2)
  r = [r repmat(r(length(r)), 1, cols(x)-length(r))];
end

h = [];
% hold is needed for fill()
held = ishold;
hold on
for i=1:cols(x)
  y = unitC*r(i) + repmat(x(:, i), 1, n);
  if nargin < 4
    h = [h line(y(1,:), y(2,:), 'Color', outline_color)];
  else
    h = [h fill(y(1,:), y(2,:), fill_color, 'EdgeColor', outline_color)];
  end
end
if ~held
  hold off
end

function res = cols(x);
res = size(x,2);
