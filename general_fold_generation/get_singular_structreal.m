%generate singular_set struct which contains the boundary indices and
%coordinates in registered_vertex, as well as which portion is above and
%down. Assume boundary is oriented cwly

function singular_set = get_singular_structreal(bdy1_xy,bdy2_xy,...
                                        bdy3_xy,bdy4_xy,...
                                        bdy5_xy,bdy6_xy,bdy7_xy,bdy8_xy,...
                                        bdy_xy,p,bdy1bool,singtype)
                                    
if strcmp(singtype,'st')
    f1 = 'bdy1_xy'; value1 = bdy1_xy;
    f2 = 'bdy2_xy'; value2 = bdy2_xy;
    f3 = 'bdy3_xy'; value3 = bdy3_xy;
    f4 = 'bdy4_xy'; value4 = bdy4_xy;
    ff1 = 'bdy5_xy'; vvalue1 = bdy5_xy;
    ff2 = 'bdy6_xy'; vvalue2 = bdy6_xy;
    ff3 = 'bdy7_xy'; vvalue3 = bdy7_xy;
    ff4 = 'bdy8_xy'; vvalue4 = bdy8_xy;
    f5 = 'bdy1bool'; value5 = bdy1bool;
    f6 = 'singular_set_xy';
    v6 = [bdy1_xy;bdy2_xy(2:end,:);bdy3_xy(2:end,:);...
    bdy5_xy;bdy6_xy(2:end,:);bdy7_xy(2:end,:)];
  
    f7 = 'p'; v7 = p; %[bdy1_xy(1,:);bdy2_xy(1,:);bdy3_xy(1,:);bdy4_xy(1,:)];
    f8 = 'bdy_xy'; v8 = bdy_xy;
    singular_set = struct(f1,value1,f2,value2,f3,value3,f4,value4,...
        ff1,vvalue1,ff2,vvalue2,ff3,vvalue3,ff4,vvalue4,...
        f5,value5,f6,v6,f7,v7,f8,v8,'singtype',singtype);
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