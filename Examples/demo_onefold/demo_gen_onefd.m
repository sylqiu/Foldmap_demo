clear;clc;
[init_v, folded_v, true_unfold, iter_unfold, fold, face_1, face_2, face_3,muarray_1fold] = gen_onefld(18,14);
%%
% figure(1); gpp_plot_mesh(face_1, true_unfold);
figure(2);gpp_plot_mesh(face_2,iter_unfold);view(2); axis off; hold on;
sing_ind1 = 1:30; sing_ind2 = 31:60;
figure(2);plot(iter_unfold(sing_ind1,1),iter_unfold(sing_ind1,2),'Linewidth',3,'Color','b');hold on;
figure(2);plot(iter_unfold(sing_ind2,1),iter_unfold(sing_ind2,2),'Linewidth',3,'Color','r'); 
%%
% figure(3); gpp_plot_mesh(face_2,init_v); axis off;
%%
zcoord = (init_v(:,1)+init_v(:,2))*0.5;
fold = [fold,zcoord];
figure(4);gpp_plot_mesh(face_2,fold); axis off; hold on;
figure(4);plot3(fold(1:30,1),fold(1:30,2),fold(1:30,3),'Linewidth',3,'Color','b');hold on;
figure(4);plot3(fold(31:60,1),fold(31:60,2),fold(31:60,3),'Linewidth',3,'Color','r'); 
