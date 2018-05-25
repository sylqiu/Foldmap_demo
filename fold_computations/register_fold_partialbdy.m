function [face,vertex,registered_vertex,mu,getface,new_constraints,full_cind] =...
    register_fold_partialbdy(singular_set_xy,b_ind,b,m,n,sx,sy,mm,nn,kk)
p = [(sx-1)/2,sy-1; (sx-1)/2,0; (sx-1)/2-m,0; (sx-1)/2-n,sy-1];
[mbdy_1,~,mbdy_3,~,bdy_xy] = gen_straight_sing(nn,mm,p);
b_xy = gen_straight_bdy(sx,sy,p,nn,mm,kk);
[vlist,elist] = get_straight_velist(mbdy_1,mbdy_3,b_xy);
[face,vertex] = gen_mesh_velist(vlist,elist,sx);
full_cind = 1:size(vlist,1);
% figure(3);gpp_plot_mesh(face, vertex); axis off;
getface = get_face(bdy_xy,face,vertex);
mu_angle = 0;
mu = complex(ones(size(face, 1), 1), zeros(size(face, 1), 1));
mu = mu./abs(mu);
mu(getface) = mu(getface)*1000*exp(1i*mu_angle);
mu(~getface) = mu(~getface)*0;
%% Constraints: only b and mbdy_1 
c_ind = [1:size(singular_set_xy,1),b_ind]';
% c = [singular_set_xy;gtf_vertex(bdy_ind,:)]; %% should be replaced by bdy_xy
c = [singular_set_xy;b];
new_constraints = [c_ind,c];

% new_v = get_locedge(face,vertex,mu);
% [X,Y] = get_relcoord(new_v);
% registered_vertex = my_asap(vertex(:,1:2),face,X,Y,new_constraints);
registered_vertex = lsqc_solver(face,vertex,mu,c_ind,c);
end