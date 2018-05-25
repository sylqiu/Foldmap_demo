function [f_ind,flip] = find_tri_by_edge(f,E)
% assume for each edge in E there are only one face corresponding to it
% (i.e. boudnary edge)
% this end up only to be used for one face and one edge, bugs may exist 
    flip = zeros(size(f,1),1);
    edge_vec1 = [f(:,1),f(:,2)];
    edge_vec2 = [f(:,2),f(:,3)];
    edge_vec3 = [f(:,3),f(:,1)];
    A1 = ismember(edge_vec1,E,'rows');
    B1 = ismember(edge_vec1,E(:,[2,1]),'rows');
    C1 = A1+B1;
    A2 = ismember(edge_vec2,E,'rows');
    B2 = ismember(edge_vec2,E(:,[2,1]),'rows');
    C2 = A2+B2;
    A3 = ismember(edge_vec3,E,'rows');
    B3 = ismember(edge_vec3,E(:,[2,1]),'rows');
    C3 = A3+B3;
    C = C1+C2+C3;
    admis = C>0;
    pre_f_ind = 1:size(f,1);
    pre_f_ind = pre_f_ind(admis);
    
    B = (B1+B2+B3)>0;
    flip(B) = 1;
    
    %order them according to E,i.e. the first triangle contains the first
    %edge etc, f_ind may have repetitions
    f_ind = zeros(size(pre_f_ind,1),1);
    for i = 1:size(E,1)
        a1 = ismember(edge_vec1(pre_f_ind,:),E(i,:),'rows');
        b1 = ismember(edge_vec1(pre_f_ind,:),E(i,[2,1]),'rows');
        a2 = ismember(edge_vec2(pre_f_ind,:),E(i,:),'rows');
        b2 = ismember(edge_vec2(pre_f_ind,:),E(i,[2,1]),'rows');
        a3 = ismember(edge_vec3(pre_f_ind,:),E(i,:),'rows');
        b3 = ismember(edge_vec3(pre_f_ind,:),E(i,[2,1]),'rows');
        c= a1+b1+a2+b2+a3+b3;
        ad = c==1;
        f_ind(i) = pre_f_ind(ad);
    end
    flip = flip(f_ind);
end