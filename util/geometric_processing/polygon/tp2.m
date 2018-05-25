function [f, v] = tp(p, a, s)

% TP  Triangulate polygon.
%   [f,v] = TP(p, a) triangulates polygon defined by vertices p with
%   triangles of area not more than a.
% 
%   [f,v] = TP(p, a, 'show') is same as above, but with details of
%   triangulation being displayed.

s = (nargin == 3 && strcmp(s, 'show'));

n = size(p,1);
fid = fopen('A.poly', 'w');
A = [];
B = [];
lastPt = [];
lastId = 0;

for i = 1:n
  if isequal(lastPt, p(i,:))
    B(end) = lastId;
    lastId = 0;
  else
    A = [A; p(i,:)];
    B = [B; size(B,1)+2];
    if lastId == 0
      lastId = size(B,1);
      lastPt = p(i,:);
    end
  end
end

n = size(A, 1);
fprintf(fid, '%d 2 0 0\n', n);
for i = 1:n
  fprintf(fid, '%d %f %f\n', i, A(i,1), A(i,2));
end
fprintf(fid, '%d 0\n', n);
for i = 1:n
  fprintf(fid, '%d %d %d\n', i, i, B(i));
end
fprintf(fid, '0\n');
if nargin > 1
  par = sprintf('a%.4f', a);
else
  par = '';
end
[~, msg] = system(['.\triangle\triangle -gPNEq32', par, ' A.poly']);
if s
  fprintf('%s\n', msg);
end
[f, v] = read_off('A.1.off');
v(:, 3) = [];
v(1:n, :) = A;
