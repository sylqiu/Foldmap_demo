%% generating realistic twice-folded surface
clear;clc;

sp1 = [6.74,13.7;
    7.2,8;
    7.4,6.3;
    7.9,0;
    6.3,0;
    5.95,5.8;
    5.8,7.6;
    5.4,13.7];

sp2 = [13.7,5;
    7.4,6.3;

    5.95,5.8;
    0,7.4;
    0,8.61;
    5.8,7.6;
     7.2,8;
     13.7,7.05
   ];
kkk = 10; lll =10; mm = 10; ll = 10; kk = 10;
imagefilename = 'einstein.png';
im = imread(imagefilename); 
sx = size(im, 2);
sy = size(im, 1);
% figure(1); hold on;
%  plot(p1(:,1),p1(:,2),'o'); axis equal;
%   plot(p2(:,1),p2(:,2),'o'); axis equal;
[sing_cell,bdy_ind,new_vertex,~,elist] =  gen_2freal(imagefilename,sp1,sp2,mm,ll,kk,lll,kkk);
%%
singular_set_xy = [sing_cell{1}([1:9,22:28],:);sing_cell{2}(26+[1:7,17:26],:)];
% singular_set_xy = [sing_cell{1}([1:7,17:30,35:44,49:56],:);sing_cell{2}(0+[1:7,17:30,35:44,49:52],:)];

figure(3);plot(singular_set_xy(:,1),singular_set_xy(:,2),'o');
%%
part_bdy_ind = bdy_ind([1:7,17:35,36:60,61:80,95:end]);
% part_bdy_ind = bdy_ind;
c_ind = [1:9,22:28,56+26+[1:7,17:26],part_bdy_ind]';
% c_ind = [1:9,22:28,56+26+[1:7,17:26]]';
c_xy = new_vertex(c_ind,:);
%  figure(4); plot(c_xy(:,1),c_xy(:,2),'o'); axis equal;
% c_ind = [1:7,17:30,35:44,49:56,56+0+[1:7,17:30,35:44,49:52],part_bdy_ind]';
b_xy = new_vertex(part_bdy_ind,:);
 figure(4); plot(b_xy(:,1),b_xy(:,2),'o'); axis equal;
 %%
m2 = 14; n2 = 14; 
[face,vertex,registered_vertex,mu,getface,constraints,full_cind]=...
    register_2freal(singular_set_xy,part_bdy_ind,b_xy,m2,n2,sx,sy,mm,kk,ll,lll,kkk,c_ind);

%% 
singind_cell = {1:10,10:19,19:28,29:38,38:47,47:56,[57:65,19],...
    [19,66:73,38],[38,74:82],[83:91,47],[47,92:99,10],[10,100:108]};%,66:75,75:84,84:93,93:102,102:108};
% singind_cell = {1:10};%,10:19,19:28,29:38,38:47,47:56};
% singind_cell = {1:10,10:19,19:28,29:38,38:47,47:56};
%%
nn=10;corner = [109;134;159;184];
[unfolded,map_mu,muarray,folded] = iter_test(face,vertex,registered_vertex,getface,nn,mm,kk,...
    constraints,corner,full_cind,singind_cell);
%%

%%
singular_set_ind = cell2mat(singind_cell);
% gpp_plot_mesh(face,unfolded);
plot(unfolded(singular_set_ind,1),unfolded(singular_set_ind,2),'o');
boundary_ind = compute_bd(face);
boundary_xy = folded(boundary_ind,:);
[new_face,new_vertex,new_getface] = get_occ_from_straightfold(face,getface,folded,unfolded,singular_set_ind',sing_cell,boundary_xy,nn,sx,sy);
%%
figure(12);plot([1:117],log(muarray(3:end)),'r'); hold on;
figure(12); plot([1:117],log(1./sqrt([20:117+19]))+3,'b');


  