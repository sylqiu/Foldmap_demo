clear;clc;
% load('cuspinit.mat'); %load('cusp_cxy.mat');
load('cuspfullinit.mat'); load('cusp_fullcxy.mat');
gpp_plot_mesh(init_face,init_vertex);
%%
mu = zeros(size(init_face,1),1);
mu(getface) = 1000;
registered_vertex = lsqc_solver(init_face,init_vertex,mu,[64;19],[0,0;1,0]);
figure(1); gpp_plot_mesh(init_face,init_vertex);
figure(1);plot3d(init_face,init_vertex,registered_vertex,0.05);
%%
c_ind1 = c_ind([1:20,30:40,50:60],:);
c_xy1 = c_xy([1:20,30:40,50:60],:);
registered_vertex = lsqc_solver(init_face,init_vertex,mu,c_ind1,c_xy1);
figure(2);plot3d(init_face,init_vertex,registered_vertex,0.05);axis off;
%%

%%
constraints = [c_ind1,c_xy1];
gpp_plot_mesh(init_face(getface,:),init_vertex);
%%
nn=10;mm = 10; kk = 10; corner = [64;19;138;73];
[unfolded,map_mu,muarray,folded] = iter_test(init_face,init_vertex,registered_vertex,getface,nn,mm,kk,...
    constraints,corner,full_cind',singind_cell);
%%
figure; plot3d(init_face,init_vertex,folded,0.05);axis off;
%%
figure;plot(log([1:199]),log(muarray),'linewidth',3,'color','r');