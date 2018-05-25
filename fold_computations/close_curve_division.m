function Edge = close_curve_division(B,pt)
% -------------------------------------------------------
% Divide the close boundary into segments
% -------------------------------------------------------
% Input : 
%	B - close Boundary edges (nx2 or nx1)
%	pt - Points for dividing the boundary (kx1)
%
% Output :
%	Edge - segments of the close boundary (in cell)
% -------------------------------------------------------

if size(B,2) == 1;
    B = [B,[B(2:end);B(1)]];
end

if length(pt) < 2
    error('At least two nodes for division');
end

n = length(pt);
Edge = cell(1,n);
[~,location] = ismember(pt,B(:,1));

[sort_location,index] = sort(location);

for i = 1:n-1
    Edge{i} = B(sort_location(i,1):sort_location(i+1,1),1);
end
Edge{n} = [B(sort_location(end,1):end,1);B(1:sort_location(1,1),1)];

Edge = Edge(index);

if min(cellfun(@length,Edge)) == 0
	error('Something wrong! Please check the input!')
end

end
