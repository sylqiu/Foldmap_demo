function new_vertex = straighten_sing(singind_cell,vertex)
new_vertex = vertex;
for i = 1:size(singind_cell,2)
   v = proj_line(singind_cell{i},vertex);
   new_vertex(singind_cell{i},:) = v;
end
end