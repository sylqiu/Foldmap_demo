function [sing_cell,sing_xy_cell,bdy_ind,bdy_xy,new_vertex,vertex,new_constraints,varargout] = gen_straight_fold_wtexture(imagefilename,m,n,mm,nn,kk,wtexture)
%% ------------------------      GENERATE SINGUALAR SETS AND BOUNDARY SETS
im = imread(imagefilename);
sx = size(im, 2);
sy = size(im, 1);
p = [(sx-1)/2,sy-1; (sx-1)/2+5,0; (sx-1)/2-m,0; (sx-1)/2-n,sy-1];
[mbdy_1,~,mbdy_3,~,bdy_xy] = gen_straight_sing(nn,mm,p);
%% --------------------------------------GENERATE A MESH CORR TO THE DATA
b_xy = gen_straight_bdy(sx,sy,p,nn,mm,kk);
vlist = [mbdy_1;mbdy_3;b_xy];
elist = [[1:size(mbdy_1,1)-1]';size(mbdy_1,1)+[1:size(mbdy_3,1)-1]'];
% blist = size(elist,1)+2+[1:size(b_xy,1)-1]';
%  elist = [elist;blist];
elist = [elist,elist+1];
% elist = [elist;size(vlist,1),size(mbdy_1,1)+size(mbdy_3,1)+1];
[face,vertex] = gen_mesh_velist(vlist,elist,sx);
% [face,vertex] = gen_mesh2(vlist,elist);
%  mesh_bdy = compute_bd(face);
%  figure(1); plot(vertex(mesh_bdy,1),vertex(mesh_bdy,2),'o');
 figure(12);gpp_plot_mesh(face, vertex);axis off;

%% ------------------------------------------------------- GET FLIPPED FACE
getface = get_face(bdy_xy,face,vertex);

%% ------------------------------------------------------COMPUTE FOLDED MAP
mu_angle = 0;
mu = complex(ones(size(face, 1), 1), zeros(size(face, 1), 1));
mu = mu./abs(mu);
mu(getface) = mu(getface)*1000*exp(1i*mu_angle);
mu(~getface) = mu(~getface)*0; %.*rand(size(mu(~getface),1),1);

%fix two point
% c_ind = size(mbdy_1,1)+size(mbdy_3,1)+[1;122];
c_ind = [2*nn+1;4*kk+2*mm+3*nn-10];
c = [0,0;0,sy-1];
new_constraints = [c_ind,c];

% new_v = get_locedge(face,vertex,mu);
% [X,Y] = get_relcoord(new_v);
% new_vertex = my_asap(vertex(:,1:2),face,X,Y,new_constraints);
new_vertex = lsqc_solver(face,vertex(:,1:2),mu,c_ind,c);
%%
% figure;
% update_mu = compute_bc(face,new_vertex,vertex);
% % plot_facemu(face,vertex,update_mu);
%%
% folding_part = face(getface,:);
new_bdy = [1: size(bdy_xy,1)]';
% new_bdy = flipud(new_bdy);
% [~,order] = sort(new_bdy);

bdy_ind = size(mbdy_1,1)+size(mbdy_3,1)+[1:size(b_xy,1)]';
% bdy_xy = new_vertex(bdy_ind,:);

new_mbdy_1 = 1:size(mbdy_1,1);
new_mbdy_3 = size(mbdy_1,1)+[1: size(mbdy_3,1)];

sing_cell = {new_mbdy_1,new_mbdy_3,new_bdy};
sing_xy_cell = {new_vertex(new_mbdy_1,:),new_vertex(new_mbdy_3,:)};
%% -----------------------------------------------------------ADD 3D COORD
zcoord = (vertex(:,1)+vertex(:,2))*0.2;
new_vertex_3d = [new_vertex,zcoord];
% figure(2); gpp_plot_mesh(face,new_vertex);
% figure(2); gpp_plot_mesh(face,new_vertex_3d); view(2);axis off;
% figure(3);gpp_plot_mesh(face,[vertex(:,1)/sx,vertex(:,2)/sy]);
%% -----------------------------------------------------------TEXTURE COORD
if wtexture == 1 && nargout == 7
    texturecoor = [1-vertex(:,2)/sy,1-vertex(:,1)/sx];
    % texturecoor = [vertex(:,2)/sy,vertex(:,1)/sx];
    figure;
    patchtop(face,new_vertex_3d,face,texturecoor,im,128,1.5);
    shading flat; axis off; axis equal
    saveas(gcf,'test_straight.png');
    varargout{end} = imread('test_straight.png');
end
end
