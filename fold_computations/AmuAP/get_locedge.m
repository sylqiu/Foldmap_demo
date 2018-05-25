function v = get_locedge(face,vertex,mu)
re = real(mu);
im = imag(mu);

fk = face(:,3);
fi = face(:,1);
fj = face(:,2);
%Ai is the negative of y-coord of vector edge i, etc
A1 = vertex(fk,2) - vertex(fi,2);
A2 = vertex(fi,2) - vertex(fj,2);
B1 = vertex(fi,1) - vertex(fk,1);
B2 = vertex(fj,1) - vertex(fi,1);
%solve for v2'
A = sparse(length(face(:,1))*2,length(face(:,1))*2);
for i = 1:length(face(:,1))
    A(2*i-1,2*i-1) = re(i)*A2(i) +im(i)*B2(i) - A2(i);
    A(2*i-1,2*i) = re(i)*B2(i)  -im(i)*A2(i) + B2(i);
    A(2*i,2*i-1) = -re(i)*B2(i) +im(i)*A2(i) - B2(i);
    A(2*i,2*i) = re(i)*A2(i) +im(i)*B2(i) - A2(i);
end

b = zeros(length(face(:,1))*2,1);
b(1:2:end) = (1-re).*A1 - im.*B1;
b(2:2:end) = (1+re).*B1 - im.*A1;
v = A\b;  
v = [v(1:2:end),v(2:2:end)];
end


