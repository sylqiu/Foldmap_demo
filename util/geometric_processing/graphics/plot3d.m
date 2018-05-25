function plot3d(face,vertex,new_vertex,k)
%auto plot simple 3d folds (face, v, new_v)
zcoord = (vertex(:,1)+vertex(:,2))*k;
new_vertex_3d = [new_vertex,zcoord];
gpp_plot_mesh(face,new_vertex_3d); view(2);
end