% Generate the boundary of a rectangle, with provided boundary correspondence
% 
% Parameters:
% sx,xy: x,y-sizes of the rectangle;
% p:     points that specify the intersection of the folding lines with the
%        boundary rectangle; assume p is 
%              p4 ------ p1
%              |         |  n
%        0--k--p3---m----p2--k--
%
% n:     number of points assigned to edges
% m:     number of points in between points in p on the same edge

% p.s. k-m better be even?
% Returns:
% bdy_xy: the boundary of a rectangle, with provided boundary correspondence

function bdy_xy = gen_straight_bdy(sx,sy,p,n,m,k)
sx = sx-1;
sy = sy-1;
bdy_xy11 = [linspace(0,p(3,1),k)',zeros(k,1)];
bdy_xy12 = [linspace(p(3,1),p(2,1),m)',zeros(m,1)];
bdy_xy13 = [linspace(p(2,1),sx,k)',zeros(k,1)];
bdy_xy2 = [sx*ones(n,1),linspace(0,sy,n)'];
bdy_xy31 = [linspace(sx,p(1,1),k)',sy*ones(k,1)];
bdy_xy32 = [linspace(p(1,1),p(4,1),m)',sy*ones(m,1)];
bdy_xy33 = [linspace(p(4,1),0,k)',sy*ones(k,1)];
bdy_xy4 = [0*ones(n,1),linspace(sy,0,n)'];

bdy_xy = [bdy_xy11(1:end-1,:);bdy_xy12(2:end-1,:);bdy_xy13(2:end,:);...
    bdy_xy2(2:end,:);...
    bdy_xy31(2:end-1,:);bdy_xy32(2:end-1,:);...
    bdy_xy33(2:end,:);bdy_xy4(2:end-1,:)];
end