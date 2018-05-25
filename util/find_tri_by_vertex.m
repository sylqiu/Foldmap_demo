function f_ind_cell = find_tri_by_vertex(f,vind)
%for each vertex, find all faces contain it
    f_ind_cell = cell(size(vind,1),1);
    F = 1:size(f,1);
    for i = 1:size(vind,1)
        C = ismember(f,vind(i));
        C = sum(C,2)>0;
        f_ind_cell{i} = F(C);
    end
end