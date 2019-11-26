%landmark is the index of the landmarked verteices, target is the
%constrained position
function [uv_new,M] = lsqc_solver(face,vertex,mu,landmark,target)
landmark = [landmark;size(vertex,1)+landmark];
target = reshape(target,size(target,1)*2,1);
% L1 = cotmatrix(vertex,face);
L2 = div_PtP_grad(mu,face,vertex);
A = signed_area_matrix(vertex,face,mu);
L = blkdiag(L2,L2);
M =L-2*A;
b = -M(:,landmark)*target;
b(landmark,:) = target;
M(landmark,:) = 0; 
M(:,landmark) = 0;
M = M + sparse(landmark,landmark,ones(length(landmark),1), size(M,1), size(M,2));
uv_new = M\b;
%%
uv_new = reshape(uv_new,size(uv_new,1)/2,2);
% figure; gpp_plot_mesh(o_face,uv_new);
% mu_new = compute_bc(face,uv_new,vertex);
end
