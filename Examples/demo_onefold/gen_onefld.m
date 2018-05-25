% generate different one folds
% input trapeze size 
% Example: m = 5; n = 15;
% face_1 corresponds to ture_unfold, face_2 corresponds to init_v,
% iter_unfold, face_3 corresponds to folded_v
function [init_v, folded_v, true_unfold, iter_unfold, fold, face_1, face_2,face_3,muarray] = gen_onefld(m,n)
% number of points in edges
mm = 10;nn = 30;kk=30;
% size
sx = 100;
sy = 100;
% generate synthetic fold
% p = [(sx-1)/2,sy-1; (sx-1)/2+5,0; (sx-1)/2-m,0; (sx-1)/2-n,sy-1];
%  p = [(sx-1)*0.6,sy-1; (sx-1)*0.6+5,0; (sx-1)*0.6-m,0; (sx-1)*0.6-n,sy-1];
 p = [(sx-1)*0.6,sy-1; (sx-1)*0.6+5,0; (sx-1)*0.6-m,0; (sx-1)*0.6-n,sy-1];
[mbdy_1,~,mbdy_3,~,~] = gen_straight_sing(nn,mm,p);
b_xy = gen_straight_bdy(sx,sy,p,nn,mm,kk);
vlist = [mbdy_1;mbdy_3;b_xy];
elist = [[1:size(mbdy_1,1)-1]';size(mbdy_1,1)+[1:size(mbdy_3,1)-1]'];
elist = [elist,elist+1];
[face_1,true_unfold] = gen_mesh_velist(vlist,elist,sx);
[~,sing_xy_cell,bdy_ind,~,folded_v,face_3,~,~] = gen_straight_fold_wtexture2(sx,sy,m,n,mm,nn,kk,0);
% only half of the singular set, and partial boundary
singular_set_xy = [sing_xy_cell{1}];
% Choice of partial boundary index
part_bdy_ind = bdy_ind([1:kk-mm+7,kk+mm+1:3*kk+nn,3*kk+3*mm+nn-18:end]);
b_xy = folded_v(part_bdy_ind,:);

% initial map and preparation
m2 = 15; n2 = 15; 
[face_2,init_v,registered_vertex,~,getface,part_constraints,~] = register_fold_partialbdy2(singular_set_xy,part_bdy_ind',b_xy,...
    m2,n2,sx,sy,mm,nn,kk);
% iter_sing is the version without corner constraint
[iter_unfold,muarray,fold] = iter_sing2(face_2,init_v,registered_vertex,getface,nn,mm,kk,part_constraints);

end

function [sing_cell,sing_xy_cell,bdy_ind,bdy_xy,new_vertex,face_3,vertex,new_constraints,varargout] = gen_straight_fold_wtexture2(sx,sy,m,n,mm,nn,kk,wtexture)
%% ------------------------      GENERATE SINGUALAR SETS AND BOUNDARY SETS
% im = imread(imagefilename);
% sx = size(im, 2);
% sy = size(im, 1);
% p = [(sx-1)/2,sy-1; (sx-1)/2+5,0; (sx-1)/2-m,0; (sx-1)/2-n,sy-1];
 p = [(sx-1)*0.6,sy-1; (sx-1)*0.6+5,0; (sx-1)*0.6-m,0; (sx-1)*0.6-n,sy-1];
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
% gpp_plot_mesh(face,vertex);
face_3 = face;
% [face,vertex] = gen_mesh2(vlist,elist);
%  mesh_bdy = compute_bd(face);
%  figure(1); plot(vertex(mesh_bdy,1),vertex(mesh_bdy,2),'o');
%  figure(12);gpp_plot_mesh(face, vertex);axis off;

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
% gpp_plot_mesh(face,new_vertex);
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
% A = cell2mat(sing_xy_cell(2));
% plot(A(:,1),A(:,2));axis equal;
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

function [map,muarray,vertex_1] = iter_sing2(face,vertex,registered_vertex,getface,nn,mm,kk,constraints)
[nu_vertex,~] = naive_unfold(face,registered_vertex,getface,nn,mm,kk);
mu_1 = compute_bc(face,vertex,nu_vertex,2);
mu_angle = 0;
new_mu = complex(ones(size(face, 1), 1), zeros(size(face, 1), 1));
new_mu = new_mu./abs(new_mu);
new_mu(getface) = new_mu(getface)*1000*exp(1i*mu_angle);
new_mu(~getface) = new_mu(~getface)*0;
% figure(9);
% plot3d(face,vertex,registered_vertex,0.5);axis off;
[map,map_mu] = lbs_rect(nu_vertex',face',mu_1);
map = map';
%  gpp_plot_mesh(face,map);view(2);
% figure(2);plot(real(map_mu(getface)),imag(map_mu(getface)),'ro')
% figure(2);plot(real(map_mu),imag(map_mu),'b.')
itermax = 201;
iter = 1;
% load('DefaultParameterLM.mat');
% Operator = createOpt_fold(vertex,face,getface);
corner = [61;126;155;220];
amu = compute_bc(face,map,registered_vertex,2);
amu(getface) = 1./amu(getface);
som_new = sum(abs(amu),1);
som_old = 0;
diff = abs(som_old - som_new);
muarray = [];
while iter <itermax %&& diff > size(face,1)/200000
%     penalty = P.sigma;
%     penalty = penalty + P.sigmaIncrease;
    [vertex_1,~] = twopt_bs(face,map,new_mu,constraints);
%     gpp_plot_mesh(face,vertex_1);
%     subplot(1,2,1);
%     figure(11); subplot(1,3,1); set(gcf,'position',[50,50,800,400]);
%     plot3d(face,vertex,vertex_1,0.5);axis off;  

    [nu_vertex,~] = naive_unfold(face,vertex_1,getface,nn,mm,kk);
%     figure(13);
%     gpp_plot_mesh(face,nu_vertex);axis off;

   
    new_mu_1 = zeros(size(face,1),1);
%     nu_vertex = [nu_vertex,zeros(size(nu_vertex,1),1)];
    [map,map_mu] = lbs_rect(nu_vertex',face',new_mu_1,'corner',corner);
    map = map';
%     subplot(1,2,2);
%     figure(10);
%     figure(11); subplot(1,3,2);gpp_plot_mesh(face,map);view(2);axis off;
%     drawnow;pause(0.1);
%      new_mu_1 = mu_average(new_mu_1,face,vertex,sx,sy,-0.1);
%     new_mu_1 = new_mu_1*(itermax-iter)/itermax;
% figure(2);plot(real(new_mu_1),imag(new_mu_1),'b.'); 
%
%     [nu_vertex,new_mu_1] = twopt_bs(face,vertex,new_mu_1,unew_constraints);
 if iter == 50 || iter == 2 || iter == 200
    figure(20);gpp_plot_mesh(face,map);view(2); axis off; hold on;
    sing_ind1 = 1:30; sing_ind2 = 31:60;
    figure(20);plot(map(sing_ind1,1),map(sing_ind1,2),'Linewidth',3,'Color','b');hold on;
    figure(20);plot(map(sing_ind2,1),map(sing_ind2,2),'Linewidth',3,'Color','r');  
 end
 %% compute some quantities
%     figure(11); subplot(1,3,3);
    diff = diff_operator(vertex_1',face');
    amu(~getface) = amu(~getface).* abs(diff.Dz(~getface,:)*complex(map(:,1),map(:,2)));
    amu(getface) = 1./amu(getface).*abs(diff.Dc(getface,:)*complex(map(:,1),map(:,2)));
%     amu = compute_bc(face,map,vertex_1,2);
%     amu(getface) = 1./amu(getface);
%     histogram(abs(amu)); 
%     drawnow;pause(0.1);
    muarray = [muarray,sum(abs(amu).^2)];
    som_old = som_new;
    som_new = sum(abs(amu),1);
    diff = abs(som_old - som_new);
    disp(diff);
    iter = iter+1;
end
end
function [face,vertex,registered_vertex,mu,getface,new_constraints,full_cind] =...
    register_fold_partialbdy2(singular_set_xy,b_ind,b,m,n,sx,sy,mm,nn,kk)
p = [(sx-1)/2,sy-1; (sx-1)/2+10,0; (sx-1)/2-m,0; (sx-1)/2-n,sy-1];
%  p = [(sx-1)*0.6,sy-1; (sx-1)*0.6,0; (sx-1)*0.6-m,0; (sx-1)*0.6-n,sy-1];
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
% plot(c(:,1),c(:,2),'o');
new_constraints = [c_ind,c];

% new_v = get_locedge(face,vertex,mu);
% [X,Y] = get_relcoord(new_v);
% registered_vertex = my_asap(vertex(:,1:2),face,X,Y,new_constraints);
registered_vertex = lsqc_solver(face,vertex,mu,c_ind,c);
% gpp_plot_mesh(face,registered_vertex);
end
function MyDifferential = diff_operator(vertex, face)
    n = size(face, 2);                     %get number of faces
    Mi = reshape([1:n;1:n;1:n], [1,3*n]);  %labels
    Mj = reshape(face, [1,3*n]);

 
    [e1,e2,e3]= GetEdge(vertex,face);

    
    area = GetSignedArea_edge(e1, e2);
    area = [area;area;area];

 
    Mx = reshape([e1(2,:);e2(2,:);e3(2,:)]./area /2 , [1, 3*n]);
    My = -reshape([e1(1,:);e2(1,:);e3(1,:)]./area /2 , [1, 3*n]);

 
    Dx = sparse(Mi,Mj,Mx);
    Dy = sparse(Mi,Mj,My);
    Dz = (Dx - 1i*Dy) / 2; Dc = (Dx + 1i*Dy) / 2;

 
    MyDifferential = struct('Dx', Dx, 'Dy', Dy, 'Dz', Dz, 'Dc', Dc);

 
end

 

 
function [e1, e2, e3] = GetEdge(vertex,face)
    e1 = vertex(1:2,face(3,:)) - vertex(1:2,face(2,:));
    e2 = vertex(1:2,face(1,:)) - vertex(1:2,face(3,:));
    e3 = vertex(1:2,face(2,:)) - vertex(1:2,face(1,:));
end

 
function area = GetSignedArea_edge(e1, e2)
    xb = -e1(1,:);
    yb = -e1(2,:);
    xa = e2(1,:);
    ya = e2(2,:);
    area = ( xa.*yb - xb.*ya )/2;
end