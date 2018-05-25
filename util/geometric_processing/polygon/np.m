function q = np(p)

% NP  Normalize polygon.
%   q = NP(p) shifts the polygon define by vertices p to zero centroid.

q = p - repmat(centroid(p), size(p,1), 1);