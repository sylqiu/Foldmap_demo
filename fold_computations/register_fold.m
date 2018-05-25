% only support full constraint
% Inputt: 
% singular_set_xy: the coordinate of singular sets;
% b: coordinate of boundary vertices of foled mesh;
% m,n: parametrisation domain singular set (trapeze) parameter;
% sx,sy: image size;
% mm,nn: number of vertices on the trapeze edges
% mm,nn,kk: number of vertices on the boundary edges
% 
% Outputs:
% new_constriants: {c_ind,c)
function [face,vertex,registered_vertex,mu,getface,new_constraints] = register_fold(singular_set_xy,b,...
    m,n,sx,sy,mm,nn,kk)
p = [(sx-1)/2,sy-1; (sx-1)/2,0; (sx-1)/2-m,0; (sx-1)/2-n,sy-1];
[mbdy_1,~,mbdy_3,~,bdy_xy] = gen_straight_sing(nn,mm,p);
b_xy = gen_straight_bdy(sx,sy,p,nn,mm,kk);
[vlist,elist] = get_straight_velist(mbdy_1,mbdy_3,b_xy);
[face,vertex] = gen_mesh_velist(vlist,elist,sx);
% figure;gpp_plot_mesh(face, vertex);
getface = get_face(bdy_xy,face,vertex);
mu_angle = 0;
mu = complex(ones(size(face, 1), 1), zeros(size(face, 1), 1));
mu = mu./abs(mu);
mu(getface) = mu(getface)*1000*exp(1i*mu_angle);
mu(~getface) = mu(~getface)*0;
%% Constraints: fix all bdy points
c_ind = [1:size(vlist,1)]';
% c = [singular_set_xy;gtf_vertex(bdy_ind,:)]; %% should be replaced by bdy_xy
c = [singular_set_xy;b];
new_constraints = [c_ind,c];

new_v = get_locedge(face,vertex,mu);
[X,Y] = get_relcoord(new_v);
registered_vertex = my_asap(vertex(:,1:2),face,X,Y,new_constraints);
end