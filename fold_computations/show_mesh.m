% drawing mesh 
% parameters:
%   v: vertex vector 
%   f: face vector

function show_mesh(v,f,arg3)

if nargin < 3
    graph = figure; patch('Faces',f','Vertices',v','FaceColor','none',...
        'EdgeColor',[64,150,190]/255,'LineWidth',0.5);
else
    if ~isreal(arg3)
        arg3 = abs(arg3);
    end
    graph = figure; patch('Faces',f','Vertices',v','FaceColor','flat','FaceVertexCData',arg3,...
        'EdgeColor','k', 'LineWidth',0.1);
    colorbar
end

axis equal
axis tight
axis vis3d
set(gcf,'Color','white');


assetData = struct('Vertex',v);
setappdata(gca,'AssetData',assetData);

dcm_obj = datacursormode(graph);
set(dcm_obj,'UpdateFcn',@ID_display,'Enable','on')
end

function txt = ID_display(obj,event_obj)

hAxes = get(get(event_obj,'Target'),'Parent');
assetData = getappdata(hAxes,'AssetData');

pos = get(event_obj,'Position');
id = vertex_search([pos(1),pos(2),pos(3)],assetData.Vertex);
txt = {['(x,y,z) : (',num2str(pos(1)),',',num2str(pos(2)),',',num2str(pos(3)),')'],...
    ['vertex ID : ',int2str(id)]};

end

%% reference
%% http://www.mathworks.in/matlabcentral/answers/447