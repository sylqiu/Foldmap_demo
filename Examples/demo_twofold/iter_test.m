% First version of iterative singular set search
% Inputs:
% face,vertex: user created inital parametrisation mesh
% registered_vertex: first registration result obtained;
% getface: flipped region
% nn,mm,kk: some original mesh parameters, needed, for naive_unfold, not
%        essential
% constraints: [c_cin,c], available constraints, may not be complete due to
%           occlusion

function [map,map_mu,muarray,vertex_1] = iter_test(face,vertex,registered_vertex,getface,nn,mm,kk,constraints,corner,full_cind,singind_cell)
[nu_vertex,~] = naive_unfold(face,registered_vertex,getface,nn,mm,kk);

% gpp_plot_mesh(face,nu_vertex);

mu_1 = compute_bc(face,nu_vertex,vertex,2);
mu_angle = 0;
new_mu = complex(ones(size(face, 1), 1), zeros(size(face, 1), 1));
new_mu = new_mu./abs(new_mu);
new_mu(getface) = new_mu(getface)*10000*exp(1i*mu_angle);
new_mu(~getface) = new_mu(~getface)*0;
[map,map_mu] = lbs_rect(nu_vertex',face',0*mu_1,'corner',corner);
map = map'; % get the initial one, excess step, bad implementation
gpp_plot_mesh(face,map);
itermax = 201;
iter = 1;
amu = compute_bc(face,map,registered_vertex,2);
amu(getface) = 1./amu(getface);
som_new = sum(abs(amu),1);
som_old = 0;
diff = abs(som_old - som_new);
muarray = [];
while iter <itermax %&& abs(diff) > size(face,1)/30000
    %% paritial registration step
    [vertex_1,~] = twopt_bs(face,map,new_mu,constraints);
    
%     figure(11); subplot(1,4,1); set(gcf,'position',[50,50,1500,600]);
%     plot3d(face,vertex,vertex_1,0.5);%axis off;  
    %% inverse registration step
    [nu_vertex,~] = naive_unfold(face,vertex_1,getface,nn,mm,kk);    
    
%     figure(11);subplot(1,4,2); 
%     gpp_plot_mesh(face,nu_vertex);axis off;

    [map,~] = lbs_rect(vertex_1',face',zeros(size(face,1),1),'corner',corner);
    map = map(1:2,:)';
    %% edge straightening
%     if iter >2 && iter <4
%     map2 = straighten_sing(singind_cell,map);
%     st_constraint = [full_cind',map2(full_cind,:)];
%     [map,~] = twopt_bs(face,map,zeros(size(face,1),1),st_constraint);
%     end
%     figure(11); subplot(1,4,3);
%     gpp_plot_mesh(face,map);view(2);axis off;
    if iter == 50 || iter == 2 || iter == 200
        figure(20);gpp_plot_mesh(face,map);view(2); axis off; hold on;
        sing_ind1 = 1:10; sing_ind2 = 10:19; sing_ind3 = [20:28,10]; sing_ind4 = [10,29:37];
        sing_ind5 = [38:46,10]; sing_ind6 = [10, 47:55]; sing_ind7 = [55:63,38];
        figure(20);plot(map(sing_ind1,1),map(sing_ind1,2),'Linewidth',2,'Color','b');hold on;
        figure(20);plot(map(sing_ind2,1),map(sing_ind2,2),'Linewidth',2,'Color','r');  
        figure(20);plot(map(sing_ind3,1),map(sing_ind3,2),'Linewidth',2,'Color','b');
        figure(20);plot(map(sing_ind4,1),map(sing_ind4,2),'Linewidth',2,'Color','r');
        figure(20);plot(map(sing_ind5,1),map(sing_ind5,2),'Linewidth',2,'Color','b');
        figure(20);plot(map(sing_ind6,1),map(sing_ind6,2),'Linewidth',2,'Color','r');
        figure(20);plot(map(sing_ind7,1),map(sing_ind7,2),'Linewidth',2,'Color','b');
    end
    %% compute some quantities
%     figure(11); subplot(1,4,4);
    amu = compute_bc(face,map,vertex_1,2);
    amu(getface) = 1./amu(getface);
%     histogram(abs(amu)); 
%     drawnow;% pause;
%     pause(0.1);
    som_old = som_new;
    som_new = sum(abs(amu),1);
    diff = som_old - som_new;
    muarray = [muarray,sum(abs(amu).^2)];
    disp(diff);
   
   
    iter = iter+1;
end
% %% Bootstrapping iteration
% iter = 1; 
% constraints = [full_cind',vertex_1(full_cind,:)];
% while iter <itermax %&& diff > size(face,1)/200000
%     %% paritial registration step
%     [vertex_1,~] = twopt_bs(face,map,new_mu,constraints);
%     
%     figure(11); subplot(1,4,1); set(gcf,'position',[50,50,1500,600]);
%     plot3d(face,vertex,vertex_1,0.5);%axis off;  
%     %% inverse registration step
%     [nu_vertex,~] = naive_unfold(face,vertex_1,getface,nn,mm,kk);    
%     
%     figure(11);subplot(1,4,2); 
%     gpp_plot_mesh(face,nu_vertex);axis off;
% 
%     [map,~] = lbs_rect(vertex_1',face',zeros(size(face,1),1),'corner',corner);
%     map = map(1:2,:)';
% 
%     figure(11); subplot(1,4,3);
%     gpp_plot_mesh(face,map);view(2);axis off;
%     %% compute some quantities
%     figure(11); subplot(1,4,4);
%     amu = compute_bc(face,map,vertex_1,2);
%     amu(getface) = 1./amu(getface);
%     histogram(abs(amu)); 
%     drawnow;pause(0.1);
%     
%     som_old = som_new;
%     som_new = sum(abs(amu),1);
%     diff = abs(som_old - som_new);
%     disp(diff);
%    
%    
%     iter = iter+1;
% end

end