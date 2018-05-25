function singular_cell = gen_mult_singreal(p_cell,mm,lll,kkk,ll)
N = size(p_cell,2);
singular_cell =cell(1,N);
for i = 1:N
    if size(p_cell{i},1) >= 8
        if size(p_cell{i},1) == 8
             % add hoc: assumed only 8 vertices in st, need change
       [bdy1_xy,bdy2_xy,bdy3_xy,bdy4_xy,...
           bdy5_xy,bdy6_xy,bdy7_xy,bdy8_xy,bdy_xy] = gen_straight_singreal(kkk,lll,p_cell{i});
       singular_cell{i} = get_singular_structreal(bdy1_xy,bdy2_xy,...
                        bdy3_xy,bdy4_xy,bdy5_xy,bdy6_xy,bdy7_xy,bdy8_xy,...
                        bdy_xy,p_cell{i},0,'st');
        else
           [singular_set_xy,bdy_xy] = gen_straight_sing_general(kkk,lll,p_cell{i});
           singular_cell{i} = get_singular_structreal_mult([],[],...
                        [],[],[],[],[],[],...
                        singular_set_xy,bdy_xy,p_cell{i},0,'st'); 
        end
    elseif size(p_cell{i},1) == 3
        % add hoc: assumed only three vertices in cusp, need change
        [bdy1_xy,bdy2_xy,bdy3_xy,bdy_xy] = gen_cusp_sing(ll,mm,p_cell{i});
       singular_cell{i} = get_singular_struct(bdy1_xy,bdy2_xy,...
                        bdy3_xy,bdy4_xy,bdy_xy,p_cell{i},0,'cusp');
                    
    end
end
end