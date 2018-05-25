function [f,v] = tp3(vertex_list,edge_list, a)
nv = size(vertex_list,1);
ne = size(edge_list,1);
fid = fopen('B.poly', 'w');


% if isequal(q, [])
    fprintf(fid, '%d 2 0 0\n', nv);
    for i = 1:nv
      fprintf(fid, '%d %f %f\n', i, vertex_list(i,1), vertex_list(i,2));
    end
    fprintf(fid, '%d 0\n', ne);
    for i = 1:ne
      fprintf(fid, '%d %d %d\n', i, edge_list(i,1), edge_list(i,2));
    end
% else
%     fprintf(fid, '%d 2 0 0\n', nv+4);
%     for i = 1:nv
%       fprintf(fid, '%d %f %f\n', i, vertex_list(i,1), vertex_list(i,2));
%     end
% 
%     for i = 1 : 4
%       fprintf(fid, '%d %f %f\n', i+nv, q(i, 1), q(i, 2));
%     end
% 
%     fprintf(fid, '%d 0\n', ne+4);
%     for i = 1:ne
%       fprintf(fid, '%d %d %d\n', i, edge_list(i,1), edge_list(i,2));
%     end
% 
% %     fprintf(fid, '%d %d %d\n', ne+1, nv+1, nv+2);
% %     fprintf(fid, '%d %d %d\n', ne+2, nv+2, nv+3);
% %     fprintf(fid, '%d %d %d\n', ne+3, nv+3, nv+4);
% %     fprintf(fid, '%d %d %d\n', ne+4, nv+4, nv+1);
% end

fprintf(fid, '0\n');
if nargin > 1
  par = sprintf('a%.4f', a);
else
  par = '';
end
[~, ~] = system(['.\triangle\triangle -gPNEq30c', par, ' B.poly']);
% disp(msg);
[f, v] = read_off('B.1.off');
v(:, 3) = [];
v(1:nv, :) = vertex_list;
end