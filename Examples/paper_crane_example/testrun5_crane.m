clear;
vertex = [0,0; 0.78,0; 1,0; 2,0; 0.73,0.33;
          1.23,0.33; 1,0.44; 0.55,0.55; 0.71,0.71; 1.33,0.71;
          0,0.73; 0.33,0.73; 1.67,0.73; 0,1; 0.44,1;
          1,1;1.57,1;2,1;
          ];
vertex_upper  = (complex(vertex(:,1),vertex(:,2))-...
    [ones(size(vertex,1),1)+1i*ones(size(vertex,1),1)])*-1;
vertex_upper = [real(vertex_upper),imag(vertex_upper)]+...
    [ones(size(vertex,1),1),ones(size(vertex,1),1)];
 vertex = [vertex;vertex_upper(1:end-5,:)];

% vertex = vertex + ones(size(vertex));

% scatter(vertex(:,1),vertex(:,2))   

face = [1,5,2; 1,8,5; 1,12,8; 1,11,12; 11,14,12;  
        8,12,9; 8,9,5; 2,5,3; 12,14,15;12,15,9; 
        5,9,7; 3,5,7; 15,16,9; 7,9,16; 3,6,4;
        6,10,4; 10,13,4; 13,18,4; 3,7,6; 7,10,6; 
        10,17,13; 17,18,13; 16,10,7; 16,17,10;];
% f_flipind = [2,3,8,9,5,12,13,14,16,18,19,21];

f_flipind = [2,3,8,9,5,12,13,14,15,17,20,23,22]; 
% figure(3);gpp_plot_mesh(face(f_flipind,:),vertex); axis equal;

face_upp = face + 18*ones(size(face,1),3);
face_upp = reshape(face_upp,[3*size(face_upp,1),1]);
for n = 1:size(face_upp,1)
   switch face_upp(n)
       case 32
           face_upp(n) = 18;
       case 33
           face_upp(n) = 17;
       case 34
           face_upp(n) = 16;
       case 35
           face_upp(n) = 15;    
       case 36
           face_upp(n) = 14;
   end
end
face_upp = reshape(face_upp,[size(face_upp,1)/3,3]);
face = [face;face_upp];
figure(1);gpp_plot_mesh(face,vertex)
 

flip_v_ind = [22,14,31; 22,28,24; 15,28,16; 15,31,28; 
    19,20,23; 19,30,29; 25,23,27; 27,23,26; 27,26,30;
    27,30,17; 24,21,25];
f_flipind_upp = [];
A = [1:size(face,1)];
for f = 1:size(flip_v_ind,1)
    aa = sum(ismember(face,flip_v_ind(f,:)),2) == 3;
    f_flipind_upp = [f_flipind_upp, A(aa)];
end
% f_flipind_upp = sum(aa,2) == 3;

    


%flip face index  
% f_flipind = [2,3,8,9,5,12,13,14,16,18,19,21];
%   f_flipind_upp = setdiff([1:24],f_flipind)+18;

f_flipindf = [f_flipind,f_flipind_upp];
getface = false(48, 1);
getface(f_flipindf) = 1;
%mu 
amu = complex(ones(size(face, 1), 1), zeros(size(face, 1), 1));
amu = amu./abs(amu);
amu(getface) = amu(getface)*1000*1;
amu(~getface) = amu(~getface)*0;


figure(2);plot_facemu(face,vertex,amu); axis equal; axis off;

% %constraint
new_v = get_locedge(face,vertex(:,1:2),amu);
% c_ind = [4;22;1;19;14;23];
% c = [0.2,2; 2,2; 1,.5; 1,.5; 1.5,1.2; 1.5,1.2];
 c_ind = [4;22];
 c = [0.2,2; 2,2];
% 
new_constraints3 = [c_ind,c];
% 
[X,Y] = get_relcoord(new_v);
% 
intp_vertex1 = my_arap(vertex(:,1:2),face,X,Y,new_constraints3);
figure(4);plot3d(face,vertex,intp_vertex1,0.1); axis off;
amu = compute_bc(face,intp_vertex1,vertex);
%%
map = lsqc_solver(face,vertex,amu,c_ind,c);
figure(4);plot3d(face,vertex,map,0.1); axis off;
% % intp_vertex2_3d = [intp_vertex1,(vertex(:,1).^.2+vertex(:,2).^.7)*.6];
% intp_vertex2_3d = [intp_vertex1,(vertex(:,1).^.2+vertex(:,2).^.7)*.3];
%% 
% for iter = 1:20
% [paper,~] = lsqc_solver(face,intp_vertex1,amu,c_ind,c); 
% [paper,~] = lbs_rect(paper',face',zeros(size(face,1),1),'corner',[1,4,19,22],'height',1);
% paper = paper';
% intp_vertex1 = my_arap(paper(:,1:2),face,X,Y,new_constraints3);
% figure(4);gpp_plot_mesh(face,paper); view(2);drawnow; pause(0.05); axis equal;
% % figure(4);plot3d(face,paper,intp_vertex1,0.1);drawnow; pause(0.05); axis off;
% end
%%
figure(5);
% gpp_plot_mesh(face,intp_vertex2_3d);
plot3d(face,vertex,intp_vertex1,0.05); axis off;

%  gpp_plot_mesh(face,intp_vertex1);
 