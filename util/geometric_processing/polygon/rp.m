function q = rp(p,s)

% RP  Refine polygon.
%   q = RP(p,s) refines the polygon p by adding s points to each edge.

n = size(p,1);
d = 0;
ds = @(x,y) norm(p(x,:) - p(y,:));
ls = @(x,y,z,w) linspace(p(x,z), p(y,z), w)';
for i = 1:n-1
    d = d + ds(i, i+1);
end
d = d/s;
q = [];
for i = 1:n-1
    c = floor(ds(i, i+1)/d) + 1;
    q = [q; ls(i, i+1, 1, c), ls(i, i+1, 2, c)];
    q(end,:) = [];
end
q = [q; p(end,:)];
