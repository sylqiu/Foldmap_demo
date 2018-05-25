%generate singular_set struct which contains the boundary indices and
%coordinates in registered_vertex, as well as which portion is above and
%down. Assume boundary is oriented cwly

function singular_set = get_singular_struct(bdy1_xy,bdy2_xy,...
                                        bdy3_xy,bdy4_xy,bdy_xy,p,bdy1bool,singtype)
                                    
if strcmp(singtype,'st')
    f1 = 'bdy1_xy'; value1 = bdy1_xy;
    f2 = 'bdy2_xy'; value2 = bdy2_xy;
    f3 = 'bdy3_xy'; value3 = bdy3_xy;
    f4 = 'bdy4_xy'; value4 = bdy4_xy;
    f5 = 'bdy1bool'; value5 = bdy1bool;
    f6 = 'singular_set_xy'; v6 = [bdy1_xy;bdy3_xy];
    f7 = 'p'; v7 = p; %[bdy1_xy(1,:);bdy2_xy(1,:);bdy3_xy(1,:);bdy4_xy(1,:)];
    f8 = 'bdy_xy'; v8 = bdy_xy;
    singular_set = struct(f1,value1,f2,value2,f3,value3,f4,value4,f5,...
        value5,f6,v6,f7,v7,f8,v8,'singtype',singtype);
elseif strcmp(singtype,'cusp')
    f1 = 'bdy1_xy'; value1 = bdy1_xy;
    f2 = 'bdy2_xy'; value2 = bdy2_xy;
    f3 = 'bdy3_xy'; value3 = bdy3_xy;
    f5 = 'bdy1bool'; value5 = bdy1bool;
    f6 = 'singular_set_xy'; v6 = [bdy1_xy;bdy2_xy(2:end,:)];
    f7 = 'p'; v7 = p; %[bdy1_xy(1,:);bdy2_xy(1,:);bdy3_xy(1,:);bdy4_xy(1,:)];
    f8 = 'bdy_xy'; v8 = bdy_xy;
    singular_set = struct(f1,value1,f2,value2,f3,value3,...
        f5,value5,f6,v6,f7,v7,f8,v8,'singtype',singtype);
else
    error('wrong singtype');
        
end
end