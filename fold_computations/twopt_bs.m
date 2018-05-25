function [map,update_mu] = twopt_bs(face,vertex,mu,constraints)
% new_v = get_locedge(face,vertex,mu);
% [X,Y] = get_relcoord(new_v);
% map = my_arap(vertex(:,1:2),face,X,Y,constraints);
map = lsqc_solver(face,vertex(:,1:2),mu,constraints(:,1),constraints(:,2:3));
% update_mu = compute_bc(face,vertex,map,2);
update_mu = nan;
end