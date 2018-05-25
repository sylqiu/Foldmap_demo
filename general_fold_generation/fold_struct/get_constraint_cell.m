%each cell encodes a singular set structure (which
% encloses a corresponding flipped region), with indication which boundary portion is
% above and which is below.
%singular_set_cell: each cell is singular_set struct.
function constraint_cell = get_constraint_cell(singular_set_cell,vertex,...
                                            face)
N = size(singular_set_cell,2);
constraint_cell = cell(1,N);
for i = 1:N
   singular_set = singular_set_cell{i};
   constraint_cell{i} = get_singmesh_struct(face,vertex,singular_set);
end
end