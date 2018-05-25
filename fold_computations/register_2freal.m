function [face,vertex,registered_vertex,mu,getface,new_constraints,full_cind]=...
    register_2freal(singular_set_xy,par_b_ind,b,m1,n1,sx,sy,mm,kk,ll,lll,kkk,c_ind)

p1 = [(sx-1)/2,sy-1; (sx-1)/2,(sy-1)/2+m1; (sx-1)/2,(sy-1)/2; (sx-1)/2,0;
     (sx-1)/2-n1,0; (sx-1)/2-n1,(sy-1)/2; (sx-1)/2-n1,(sy-1)/2+m1;(sx-1)/2-n1,sy-1];

p2 = [sx-1,(sy-1)/2; (sx-1)/2,(sy-1)/2; (sx-1)/2-m1,(sy-1)/2; 0,(sy-1)/2; 
    0,(sy-1)/2+m1; (sx-1)/2-m1,(sy-1)/2+m1; (sx-1)/2,(sy-1)/2+m1;sx-1,(sy-1)/2+n1];
p_cell = {p1,p2};
%
singular_cell = gen_mult_singreal(p_cell,mm,lll,kkk,ll);
% --------------------------------------GENERATE A MESH CORR TO THE DATA
bdy_p = [0,0,kk; p1(5,:),mm; p1(4,:),kk;  
         sx-1,0,kk; p2(1,:),mm; p2(8,:),kk;
         sx-1,sy-1,kk; p1(1,:),mm; p1(8,:),kk;
         0,sy-1,kk; p2(5,:),mm; p2(4,:),kk; 0,0,0];
b_xy = gen_mult_bdy(bdy_p,sx,sy); 

vlist = [singular_cell{1}.singular_set_xy;singular_cell{2}.singular_set_xy([1:9,11:18,20:37,39:46,48:end],:);b_xy];
elist = [(1:(size(singular_cell{1}.singular_set_xy,1)/2-1))';...
    (size(singular_cell{1}.singular_set_xy,1)/2)+(1:(size(singular_cell{1}.singular_set_xy,1)/2)-1)';...
    size(singular_cell{1}.singular_set_xy,1)+(1:8)';
    size(singular_cell{1}.singular_set_xy,1)+9+(1:7)';...
    size(singular_cell{1}.singular_set_xy,1)+9+8+(1:8)';...
    size(singular_cell{1}.singular_set_xy,1)+9+8+9+(1:8)';
    size(singular_cell{1}.singular_set_xy,1)+9+8+9+9+(1:7)';
    size(singular_cell{1}.singular_set_xy,1)+9+8+9+9+8+(1:8)'
    ];
elist = [elist,elist+1;
    size(singular_cell{1}.singular_set_xy,1)+9,19;
    19,size(singular_cell{1}.singular_set_xy,1)+10;
    size(singular_cell{1}.singular_set_xy,1)+18,38;
    size(singular_cell{1}.singular_set_xy,1)+35,47;
    47,size(singular_cell{1}.singular_set_xy,1)+36;
    size(singular_cell{1}.singular_set_xy,1)+43,10;
    10,size(singular_cell{1}.singular_set_xy,1)+44];

[face,vertex] = gen_mesh_velist(vlist,elist,sx/10);

full_cind = 1:size(vlist,1);
 figure(1);
%  gpp_plot_mesh(face, vertex);
 constraint_cell = get_constraint_cellreal(singular_cell,vertex,face);
 % get the boundary indices of getface, for later remeshing
%  getface1 = constraint_cell{1}.getface;
%  gpp_plot_mesh(face(getface1,:),vertex);
%  getface_bdy1 = compute_orderbd(face(getface1,:));
%  getface2 = constraint_cell{2}.getface;
%  getface_bdy2 = compute_orderbd(face(getface2,:));
%  getface_bdycell = {getface_bdy1,getface_bdy2};
getface = mod(constraint_cell{1}.getface + constraint_cell{2}.getface,2);
getface = logical(getface);
 mu_angle = 0;
mu = complex(ones(size(face, 1), 1), zeros(size(face, 1), 1));
mu = mu./abs(mu);
mu(getface) = mu(getface)*1000*exp(1i*mu_angle);
mu(~getface) = mu(~getface)*0;
% plot_facemu(face,vertex,mu);
uc_ind = [161;236];
uc = [0,0;0,100];
unew_constraints = [uc_ind,uc];
fold_vertex = twopt_bs(face,vertex,mu,unew_constraints);
gpp_plot_mesh(face,fold_vertex);
%% Constraints

plot(fold_vertex(c_ind,1),fold_vertex(c_ind,2),'o');
% c = [singular_set_xy;gtf_vertex(bdy_ind,:)]; %% should be replaced by bdy_xy
c = [singular_set_xy;b];
new_constraints = [c_ind,c];

new_v = get_locedge(face,fold_vertex,mu*0);
[X,Y] = get_relcoord(new_v);
registered_vertex = my_asap(fold_vertex(:,1:2),face,X,Y,new_constraints);
plot3d(face,vertex,registered_vertex,0.5);
end