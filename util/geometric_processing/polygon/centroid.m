function q = centroid(p)

% CENTROID  Centroid of polygon
%   q = CENTROID(p) computes centroid of a polygon defined by vertices p

b = p(1:end-1,1) .* p(2:end,2) - p(2:end,1) .* p(1:end-1,2);
a = sum(b) / 2;
x = sum((p(1:end-1,1) + p(2:end,1)) .* b) /6/a;
y = sum((p(1:end-1,2) + p(2:end,2)) .* b) /6/a;
q = [x, y];