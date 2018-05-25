function [nu_vertex,nu_mu] = naive_unfold(face,folded_vertex,getface,nn,mm,kk)
uc_ind = [2*nn+1;4*kk+2*mm+3*nn-8];
uc = [0,0;0,100];
unew_constraints = [uc_ind,uc];
mu = zeros(size(face,1),1);
mu(getface) = 100000;
nu_vertex = twopt_bs(face,folded_vertex,mu,unew_constraints);
% nu_mu = compute_bc(face,folded_vertex,nu_vertex,2);
nu_mu = nan;
% figure; gpp_plot_mesh(face,nu_vertex);
end