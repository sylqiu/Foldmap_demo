function [map,map_mu] = lbs_rect(v,f,mu,varargin)
%temp change
v = [v;zeros(1,size(v,2))];
% -------------------------------------------------------
% Linear Beltrami Solver designed for rectangular target.
% -------------------------------------------------------
% Input : 
% 	v - vertex (3xn)
% 	f - connection (3xm)
% 	mu - Beltrami coefficient (mx1 complex)
% Extra input : 
% 	Landmark - landmark point (vertex index, nx1)
% 	Target - target location ((x,y) coordinate, nx2)
% 	Corner - 4 corners (See Remarks)
% 	Height - Height of the target rectangular domain
%			 (Default : According to the mapping)
%	Width - Width of the target rectangular domain 
%		    (Default : 1)
%
% Output :
% 	map - the mapping result
% 	map_mu - Beltrami coefficient of the map
% -------------------------------------------------------
% Remarks on Corner input
%
% Defualt :
% 	4 extreme points are chosen.
%
% User input :
% 	Anti-clockwise location for the corners.
%   	P4 ---(Edge 3)--- P3
%   	|	       		   |
%	(Edge 4)			(Edge 2)
%   	|	               |
%   	P1 ---(Edge 1)--- P2
% -------------------------------------------------------
% Example :
%   load('test(lbs_rect).mat');
%   map_reconst = lbs_rect(v,f,mu);
% -------------------------------------------------------

heightflag = 0;
cornerflag = 0;
width = 1;
landmark = [];
target = [];

for i = 1:length(varargin)
    if isa(varargin{i},'double') 
        continue;
    end
    if ~isempty(regexp(varargin{i},'^[Cc]orner','match'))
        corner = varargin{i+1};
        cornerflag = 1;
    end
    if ~isempty(regexp(varargin{i},'^[Hh]eight','match'))
        height = varargin{i+1};
        heightflag = 1;
    end
    if ~isempty(regexp(varargin{i},'^[Ww]idth','match'))
        width = varargin{i+1};
    end
    if ~isempty(regexp(varargin{i},'^[Ll]andmark','match'))
        landmark = varargin{i+1};
    end
    if ~isempty(regexp(varargin{i},'^[Tt]arget','match'))
        target = varargin{i+1};
    end
    
end

if size(landmark,1) ~= size(target,1)
	error('Please check landmark & target input!');
end

if isempty(landmark)
    targetlmX = [];
    targetlmY = [];
else
    targetlmX = target(:,1);
    targetlmY = target(:,2);
end
    
[Ax,abc,area] = generalized_laplacian2D(v,f,mu); Ay = Ax;
bx = zeros(length(v),1); by = bx;
if ~cornerflag
    corner = vertex_search([...
        min(v(1,:)),min(v(2,:));
        max(v(1,:)),min(v(2,:));
        max(v(1,:)),max(v(2,:));
        min(v(1,:)),max(v(2,:))],v);
end
Edge = close_curve_division(freeBoundary(triangulation(f',v')),corner);

VBdyC = [Edge{4};Edge{2}]; VBdy = [Edge{4}*0; Edge{2}*0 + width];
landmarkx = [landmark;VBdyC]; targetx = [targetlmX;VBdy];
bx(landmarkx) = targetx;
Ax(landmarkx,:) = 0;
Ax(landmarkx,landmarkx) = diag(ones(length(landmarkx),1));
mapx = Ax\bx;

if ~heightflag
    F = f(:);
    ux = mapx(F(1:3:end-2)).*(v(2,F(2:3:end-1))' - v(2,F(3:3:end))') -...
        mapx(F(2:3:end-1)).*(v(2,F(1:3:end-2))' - v(2,F(3:3:end))') +...
        mapx(F(3:3:end)).*(v(2,F(1:3:end-2))' - v(2,F(2:3:end-1))');
    uy = mapx(F(2:3:end-1)).*(v(1,F(1:3:end-2))' - v(1,F(3:3:end))') -...
        mapx(F(1:3:end-2)).*(v(1,F(2:3:end-1))' - v(1,F(3:3:end))') -...
        mapx(F(3:3:end)).*(v(1,F(1:3:end-2))' - v(1,F(2:3:end-1))');
    height = 0.25*sum((abc(:,1).*ux.^2 + 2*abc(:,2).*ux.*uy + abc(:,3).*uy.^2)./area);
end

HBdyC = [Edge{1};Edge{3}]; HBdy = [Edge{1}*0; Edge{3}*0 + height];
landmarky = [landmark;HBdyC]; targety = [targetlmY;HBdy];
by(landmarky) = targety;
Ay(landmarky,:) = 0;
Ay(landmarky,landmarky) = diag(ones(length(landmarky),1));
mapy = Ay\by;

map = [mapx';mapy';0*v(1,:)+1];
map_mu = bc_metric(v,f,map,2);

end