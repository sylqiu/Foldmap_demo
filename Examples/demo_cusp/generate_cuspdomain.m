function [vlist,elist,full_cind,singind_cell,singular_cell] = generate_cuspdomain(bdy_p, p_cell)
% test version
singular_cell = gen_mult_singreal3(p_cell,10,10,10,10);
% b_xy = gen_mult_bdy3(bdy_p,sx+1,sy+1);
b_key_pt = bdy_p(:,1:2);
cusp_pt = get_rep_pt(p_cell);

%% generate vlist: each singular cell has no repeated vertex
repeated_pt = [];
vlist = [];
elist = [];
rep_ind = [];
singind_cell = {};

for i = 1:size(p_cell,2)
    temp_v = singular_cell{i}.singular_set_xy;
    accu_temp_v = [];
    accu_temp_elist = [];
    accu_temp_vind = [];
    last_ind = size(vlist,1);
    
    for j = 1:size(temp_v,1)
        temp_elist = [];
        if isempty(vlist)
            lg_cusp_rep = 0;
        else
            lg_cusp_rep = ismember(vlist,temp_v(j,:),'rows');
        end
%         lgnxt = ismember(vlist,temp_v(j,:),'rows');
        lgbdy = ismember(b_key_pt, temp_v(j,:),'rows');
        if sum(lg_cusp_rep) == 1
% if temp_v(j,:) is a repeated cusp point, then it is not on the boundary, and the next one is interior
            
            temp_elist = zeros(1,2);
            temp_elist(1,1) = accu_temp_elist(end,2);
            temp_elist(1,2) = accu_temp_elist(end,1)+1;
            accu_temp_elist = [accu_temp_elist;temp_elist];
            % since repeated, no need add to accu_temp_v
            % restart temp_sind
            temp_sind = [temp_sind,temp_elist(1,1)];
            singind_cell{end+1} = temp_sind;
            temp_sind = temp_sind(end);
% if temp_v(j,:) is on the boundary, need to check the next point, no edge if
% next point is on the boudary, or it is the last point
        elseif sum(lgbdy) == 1
            if j == 1
                temp_elist = zeros(1,2);
                temp_elist(1,1) = last_ind + 1;
                temp_elist(1,2) = last_ind + 2; 
                accu_temp_vind = last_ind + 1;
                temp_sind = last_ind + 1;
            else
                if j ~= size(temp_v,1) && ~ismember(temp_v(j+1,:),b_key_pt,'rows')
                    %if next pt is not on the boundary
                    temp_elist = zeros(1,2);
                    accu_temp_vind = [accu_temp_vind; accu_temp_vind(end)+1];
                    temp_elist(1,1) = accu_temp_vind(end);
                    temp_elist(1,2) = accu_temp_vind(end)+1; 
                    temp_sind = temp_elist(1,1);
                elseif j ~= size(temp_v,1) % if next point is on the boundary
                    accu_temp_vind = [accu_temp_vind; accu_temp_vind(end)+1];
                    temp_sind = [temp_sind, accu_temp_vind(end)];
                    singind_cell{end+1} = temp_sind;
                    temp_sind = [];
                else % if the point is the last point
                   accu_temp_vind = [accu_temp_vind; accu_temp_vind(end)+1];
                   temp_sind = [temp_sind,accu_temp_vind(end)];
                   singind_cell{end+1} = temp_sind;
                   temp_sind = [];
                end           
            end
            accu_temp_v = [accu_temp_v; temp_v(j,:)];
            accu_temp_elist = [accu_temp_elist;temp_elist];
        else % if current point is interior
            if ismember(temp_v(j+1,:),cusp_pt,'rows') % if next point is cusp
                if isempty(vlist)
                    temp_lg = 0;
                else
                    temp_lg = ismember(vlist,temp_v(j+1,:),'rows');
                end
                if sum(temp_lg) == 1 % and repeated before
                    repeated_pt = [repeated_pt; temp_v(j+1,:)];
                    rep_ind = [rep_ind;find(temp_lg)];
                    temp_elist = zeros(1,2);
                    temp_elist(1,1) = accu_temp_elist(end,2);
                    temp_elist(1,2) = rep_ind(end);
                    accu_temp_elist = [accu_temp_elist;temp_elist];
                else % not repeated
                    temp_elist = zeros(1,2);
                    temp_elist(1,1) = accu_temp_elist(end,2);
                    temp_elist(1,2) = accu_temp_elist(end,2)+1;
                    accu_temp_elist = [accu_temp_elist;temp_elist];
                end
                
            else % next point is interior or at the boundary
                temp_elist = zeros(1,2);
                temp_elist(1,1) = accu_temp_elist(end,2);
                temp_elist(1,2) = accu_temp_elist(end,2)+1;  
                accu_temp_elist = [accu_temp_elist;temp_elist];
                
            end
            accu_temp_vind = [accu_temp_vind; accu_temp_vind(end)+1];
            accu_temp_v = [accu_temp_v; temp_v(j,:)];
            
            if ismember(temp_v(j,:), cusp_pt,'rows'); % restart temp_sind at non-repeated cusp point
                temp_sind = [temp_sind, temp_elist(1,1)];
                singind_cell{end+1} = temp_sind;
                temp_sind = temp_sind(end);
            else
                temp_sind = [temp_sind, temp_elist(1,1)];
            end
        end
    end
    vlist = [vlist;accu_temp_v];
    elist = [elist; accu_temp_elist];
end
full_cind = [elist(:,1); elist(end,2)];


end