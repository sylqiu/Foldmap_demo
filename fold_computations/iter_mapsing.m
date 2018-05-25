% First version of iterative singular set search
% Inputs:
% face,vertex: user created inital parametrisation mesh
% registered_vertex: first registration result obtained;
% getface: flipped region
% nn,mm,kk: some original mesh parameters, needed, for naive_unfold, not
%        essential
% constraints: [c_cin,c], available constraints, may not be complete due to
%           occlusion

function [map,map_mu] = iter_mapsing(face,vertex,registered_vertex,getface,nn,mm,kk,constraints,corner)
[nu_vertex,~] = naive_unfold(face,registered_vertex,getface,nn,mm,kk);
mu_1 = compute_bc(face,nu_vertex,vertex,2);
mu_angle = 0;
new_mu = complex(ones(size(face, 1), 1), zeros(size(face, 1), 1));
new_mu = new_mu./abs(new_mu);
new_mu(getface) = new_mu(getface)*1000*exp(1i*mu_angle);
new_mu(~getface) = new_mu(~getface)*0;
% figure(9);
[map,map_mu] = lbs_rect(nu_vertex',face',mu_1,'corner',corner);
% gpp_plot_mesh(face,map');view(2);
% figure(2);plot(real(map_mu(getface)),imag(map_mu(getface)),'ro')
% figure(2);plot(real(map_mu),imag(map_mu),'b.')
itermax = 100;
% itertmapmax = 10;
iter = 1;
% load('DefaultParameterLM.mat');
% Operator = createOpt_fold(vertex,face,getface);
amu = compute_bc(face,map',registered_vertex,2);
amu(getface) = 1./amu(getface);
som_new = sum(abs(amu),1);
som_old = 0;
diff = abs(som_old - som_new);
map = map';
while iter <itermax && diff > size(face,1)/20000
%     penalty = P.sigma;
%     penalty = penalty + P.sigmaIncrease;
    [vertex_1,~] = twopt_bs(face,map,new_mu,constraints);
%     subplot(1,2,1);
    figure(11); subplot(1,4,1); set(gcf,'position',[50,50,1500,600]);
     plot3d(face,vertex,vertex_1,0.5);%axis off;  

    [nu_vertex,new_mu_1] = naive_unfold(face,vertex_1,getface,nn,mm,kk);
%     numu = compute_bc(face,nu_vertex,vertex_1);
%     numu(getface) = 1./numu(getface);
    
    new_mu_1 = mu_chop(new_mu_1,0,0);
%     new_mu_2 = new_mu_1;
%     full_c = nu_vertex(full_cind,:);
%     full_c = full_c(:,1:2);
%     k = 1;
%    while k < itertmapmax  && iter <10
%          new_mu_2 = mu_chop(mean(abs(new_mu_2)).*(cos(angle(new_mu_2)) + 1i*sin(angle(new_mu_2))),0.4,0.3);
% %           new_mu_2 = mu_chop(new_mu_2,0.2,0);
%          [nu_vertex,new_mu_2] = twopt_bs(face,vertex,new_mu_2,[full_cind',full_c]);
% %          figure(14);gpp_plot_mesh(face,nu_vertex);
%          k = k+1;
%     end
%     while k < itertmapmax  && iter <20
% %          new_mu_2 = mu_chop(mean(abs(new_mu_2)).*(cos(angle(new_mu_2)) + 1i*sin(angle(new_mu_2))),1,0.9);
%           new_mu_2 = mu_chop(new_mu_2,0.6,0);
%          [nu_vertex,new_mu_2] = twopt_bs(face,vertex,new_mu_2,[full_cind',full_c]);
% %          figure(14);gpp_plot_mesh(face,nu_vertex);
%          k = k+1;
%     end
     figure(11);subplot(1,4,2); 
    gpp_plot_mesh(face,nu_vertex);axis off;
%     Smooth_Operator = (1/(penalty))*(P.alpha*speye(size(vertex,1)) + ...
%         penalty*speye(size(vertex,1)) - Operator.laplacian/2);
%     new_mu_1 = mu_average(new_mu_1,face,vertex,sx,sy);
%     new_mu_1 = smoothing(new_mu_1,Smooth_Operator,Operator);
   
   
%     nu_vertex = [nu_vertex,zeros(size(nu_vertex,1),1)];
    [map,map_mu] = lbs_rect(nu_vertex',face',new_mu_1,'corner',corner);
%     figure(15);hist(abs(numu));
%     subplot(1,2,2);
%     figure(10);
    map = map(1:2,:)';

    figure(11); subplot(1,4,3);
    gpp_plot_mesh(face,map);view(2);axis off;
    
     figure(11); subplot(1,4,4);
     amu = compute_bc(face,map,vertex_1,2);
    amu(getface) = 1./amu(getface);
%     figure(20);
%     plot(real(amu),imag(amu),'.'); axis equal;
    histogram(abs(amu)); 
    drawnow;pause(0.1);
    som_old = som_new;
   som_new = sum(abs(amu),1);
   diff = abs(som_old - som_new);
   disp(diff);
%      new_mu_1 = mu_average(new_mu_1,face,vertex,sx,sy,-0.1);
%     new_mu_1 = new_mu_1*(itermax-iter)/itermax;
% figure(2);plot(real(new_mu_1),imag(new_mu_1),'b.'); 
%
%     [nu_vertex,new_mu_1] = twopt_bs(face,vertex,new_mu_1,unew_constraints);
    iter = iter+1;
end
end