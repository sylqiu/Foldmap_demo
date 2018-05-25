clear;clc;
sx = 19; sy = 19; kkk = 10; lll =10; mm = 10; ll = 10; kk = 10;
% the second point must be cusp
sp1 = [13.8,0; 9.5,9.5; 19,0]; 
sp3 = [9.5,0;  9.5,9.5; 1.2, 19];
sp2 = [6.25, 19; 9.5,9.5; 9.5,19];
bdy_p = [0,0; 9.5,0; 13.8,0; 19,0; 19,19; 9.5,19; 6.25,19; 1.2,19;
    0,19; 0,0];
bdy_p = [bdy_p,10*ones(size(bdy_p,1),1)];
bdy_p(end,3) = 0;
p_cell = {sp1,sp2,sp3};
ob_xy = gen_mult_bdy3(bdy_p,sx+1,sy+1);
[vlist,elist,full_cind,singind_cell,singular_cell] = generate_cuspdomain(bdy_p, p_cell);


%
% figure;hold on; axis equal;
% for i = 1:size(elist,1)
%   plot(vlist(elist(i, :),1),vlist(elist(i, :),2));
%    drawnow; pause(0.01);
% end
%
aa = singular_cell{3}.bdy3_xy;
vlist = [vlist; aa(2:end-1,:)];
%
temp_elist = 54+ [1:9]';
temp_elist = [temp_elist, temp_elist+1];
temp_elist(end,2) = 38;
elist = [elist; temp_elist];
% figure;hold on; axis equal;
% for i = 1:size(elist,1)
%   plot(vlist(elist(i, :),1),vlist(elist(i, :),2));
%    drawnow; pause(0.01);
% end
%
b_xy = setdiff(ob_xy,[19,0],'rows');
bdy_start_ind = size(vlist,1);
vlist = [vlist;b_xy];
[face,vertex] = gen_mesh_velist(vlist,elist,10);
% gpp_plot_mesh(init_face,init_vertex);
%
constraint_cell = get_constraint_cellreal(singular_cell,vertex,face);
getface = mod(constraint_cell{1}.getface + constraint_cell{2}.getface+...
    constraint_cell{3}.getface,2);
getface = logical(getface);
% figure(1);gpp_plot_mesh(init_face(getface,:),init_vertex);
%
mu_angle = 0;
mu = complex(ones(size(face, 1), 1), zeros(size(face, 1), 1));
mu = mu./abs(mu);
mu(getface) = mu(getface)*1000*exp(1i*mu_angle);
mu(~getface) = mu(~getface)*0; %.*rand(size(mu(~getface),1),1);
c_ind = [161;236];
c = [0,0;0,sy-1];
new_constraints = [c_ind,c];
new_vertex = twopt_bs(face,vertex,mu,new_constraints);
% gpp_plot_mesh(face,new_vertex);
plot3d(face,vertex,new_vertex,0.5);
%
bdy_ind = bdy_start_ind + [1:size(b_xy,1)];
bdy_ind(end+1) = 19;
% part_bdy_ind = bdy_ind([1:28,44,55:75]);
part_bdy_ind = bdy_ind;
%
% figure; hold on;
% for i = 1:size(part_bdy_ind,2)
%     j = part_bdy_ind(i);
%     plot(init_vertex(j,1),init_vertex(j,2),'o'); drawnow; pause(0.01);
% end
%
figure(2); gpp_plot_mesh(face,new_vertex); hold on;
plot(new_vertex(part_bdy_ind,1),new_vertex(part_bdy_ind,2),'ro'); hold off;
%
% c_ind = [10:19,29:37,48:55];
c_ind = elist(:,1);
c_ind = [c_ind',part_bdy_ind]';
figure(4); gpp_plot_mesh(face,new_vertex); hold on;
plot(new_vertex(c_ind,1),new_vertex(c_ind,2),'ro'); hold off;
% 
 c_xy = new_vertex(c_ind,:);
 [c_ind,ia] = unique(c_ind);
 c_xy = c_xy(ia,:);