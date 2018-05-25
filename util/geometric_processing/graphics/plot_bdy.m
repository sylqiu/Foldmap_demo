% bdy nx1

function plot_bdy(bdy,vertex)
figure;hold on;
for i = 1:size(bdy,1)
    plot(vertex(bdy(i),1),vertex(bdy(i),2),'.-');
    drawnow;
   pause(0.01);
end
hold off;
end