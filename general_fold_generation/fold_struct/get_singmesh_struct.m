% obtain the singular set information from the generated mesh
function singmesh = get_singmesh_struct(face, vertex, singstruct)
if strcmp(singstruct.singtype,'st')
    f1 = 'bdy1_ind'; v1 = find(ismember(vertex,singstruct.bdy1_xy,'rows'));
    f2 = 'bdy2_ind'; v2 = find(ismember(vertex,singstruct.bdy2_xy,'rows'));
    f3 = 'bdy3_ind'; v3 = find(ismember(vertex,singstruct.bdy3_xy,'rows'));
    f4 = 'bdy4_ind'; v4 = find(ismember(vertex,singstruct.bdy4_xy,'rows'));
    bdy = [singstruct.bdy1_xy;
           singstruct.bdy2_xy;
           singstruct.bdy3_xy;
           singstruct.bdy4_xy];
    f5 = 'getface'; v5 = get_face(bdy,face,vertex);
    singmesh = struct(f1,v1,f2,v2,f3,v3,f4,v4,f5,v5);
elseif strcmp(singstruct.singtype,'cusp')
    f1 = 'bdy1_ind'; v1 = find(ismember(vertex,singstruct.bdy1_xy,'rows'));
    f2 = 'bdy2_ind'; v2 = find(ismember(vertex,singstruct.bdy2_xy,'rows'));
    f3 = 'bdy3_ind'; v3 = find(ismember(vertex,singstruct.bdy3_xy,'rows'));
    bdy = [singstruct.bdy1_xy;
           singstruct.bdy2_xy;
           singstruct.bdy3_xy];
    f5 = 'getface'; v5 = get_face(bdy,face,vertex);
    singmesh = struct(f1,v1,f2,v2,f3,v3,f5,v5);
end
end