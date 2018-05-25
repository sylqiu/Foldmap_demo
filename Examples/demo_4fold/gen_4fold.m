clear; clc; close all;
sy = 20; sx = 26.5; kkk = 10; lll =10; mm = 10; ll = 10; kk = 10;
load('4fold_keypoint.mat');
%
p_cell_b = {sp1,sp2,sp3,sp4};
singular_cell = gen_mult_singreal3(p_cell_b,mm,lll,kkk,ll);
sp3(1,:) = [];
p_cell = {sp1,sp2,sp3,sp4};
% bdy_p = [bdy_p, 10*ones(size(bdy_p,1),1)];
% bdy_p(end,2) = 0;
b_xy = gen_mult_bdy3(bdy_p,sx+1,sy+1);
% b_xy = setdiff(b_xy,[0,sy],'rows');
%
[vlist,elist,full_cind,singind_cell] = generate_domain(bdy_p, p_cell);

%
% figure;hold on; axis equal;
% for i = 1:size(elist,1)
%   plot(vlist(elist(i, :),1),vlist(elist(i, :),2));
% %    drawnow; pause(0.01);
% end
 %
bdy_start_ind = size(vlist,1)+1;
vlist = [vlist;b_xy];
[face,vertex] = gen_mesh_velist(vlist,elist,10);
% figure(1);gpp_plot_mesh(face,vertex); hold off;
%
%
constraint_cell = get_constraint_cellreal(singular_cell,vertex,face);
getface = mod(constraint_cell{1}.getface + constraint_cell{2}.getface+...
    constraint_cell{3}.getface+constraint_cell{4}.getface,2);
getface = logical(getface);
figure(1);gpp_plot_mesh(face(getface,:),vertex);
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
% plot3d(face,vertex,new_vertex,5);
%
bdy_ind = bdy_start_ind + [1:size(b_xy,1)-1];
%
% figure(1);plot3d(face,vertex,new_vertex,5); hold on;
% plot(new_vertex(bdy_ind,1),new_vertex(bdy_ind,2),'ro'); hold off;
%
part_bdy_ind = bdy_ind([1:15, 19:22, 31:50, 58:65, 81:90, 100:107, 125:132, ...
    142:end ]);
% figure(2); gpp_plot_mesh(face,new_vertex); hold on;
% plot(new_vertex(part_bdy_ind,1),new_vertex(part_bdy_ind,2),'ro'); hold off;

%
% cc = [1,3,5,7,9,11,21,17,15,29,31,35,40,44,50,52,56];
cc = [1,3,5,7,21,17,15,29,31,35,50,52,56];
% cc = [1,3,5,7,9,11,21,17,15,29,31,35,40,44,50,52,56];
% cc = 1:56;
% cc = 26;
con_ind = [];
for ii = cc
   if ismember(ii,[22,28,29,31,35,56,50,52])
      con_ind = [con_ind, singind_cell{ii}(2:end-2)]; 
   else
      con_ind = [con_ind, singind_cell{ii}(2:end-2)];  
   end
end
con_ind = [con_ind,part_bdy_ind]';
figure(4); gpp_plot_mesh(face,new_vertex); hold on;
plot(new_vertex(con_ind,1),new_vertex(con_ind,2),'ro'); hold off;
% 
 c_xy = new_vertex(con_ind,:);
 [con_ind,ia] = unique(con_ind);
 c_xy = c_xy(ia,:);
%%












