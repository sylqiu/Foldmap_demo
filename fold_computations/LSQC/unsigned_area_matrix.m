function mA = unsigned_area_matrix(vertex,face,mu)
% a = (1-2*real(mu)+abs(mu).^2)./(1.0-abs(mu).^2);
% b = -2*imag(mu)./(1.0-abs(mu).^2);
% g = (1+2*real(mu)+abs(mu).^2)./(1.0-abs(mu).^2);
a = 1*ones(size(mu,1),1);
b = a*0;
a(abs(mu)>1) = -a(abs(mu)>1);
g= a;
fi = face(:,1);
fj = face(:,2);
fk = face(:,3);
uxv0 = vertex(fj,2) - vertex(fk,2);
uyv0 = vertex(fk,1) - vertex(fj,1);
uxv1 = vertex(fk,2) - vertex(fi,2);
uyv1 = vertex(fi,1) - vertex(fk,1); 
uxv2 = vertex(fi,2) - vertex(fj,2);
uyv2 = vertex(fj,1) - vertex(fi,1);
%lengths
l = [sqrt(sum(uxv0.^2 + uyv0.^2,2)) ...
    sqrt(sum(uxv1.^2 + uyv1.^2,2)) ...
    sqrt(sum(uxv2.^2 + uyv2.^2,2))];
%half the perimeter of each triangle, denoted s
s = sum(l,2)*0.5;
%area of triangle with sides (a,b,c) = sqrt(s(s-a)(s-b)(s-c))
area = sqrt( s.*(s-l(:,1)).*(s-l(:,2)).*(s-l(:,3)));
area = sqrt(area);
A = uxv0./(2*area);
B = uxv1./(2*area);
C = uxv2./(2*area);
D = uyv0./(2*area);
E = uyv1./(2*area);
F = uyv2./(2*area);

q11 = A.*(A.*b-D.*a)+D.*(A.*g-D.*b);
q21 = A.*(B.*b-E.*a)+D.*(B.*g-E.*b);
q31 = A.*(C.*b-F.*a)+D.*(C.*g-F.*b);
q12 = B.*(A.*b-D.*a)+E.*(A.*g-D.*b);
q22 = B.*(B.*b-E.*a)+E.*(B.*g-E.*b);
q32 = B.*(C.*b-F.*a)+E.*(C.*g-F.*b);
q13 = C.*(A.*b-D.*a)+F.*(A.*g-D.*b);
q23 = C.*(B.*b-E.*a)+F.*(B.*g-E.*b);
q33 = C.*(C.*b-F.*a)+F.*(C.*g-F.*b);

N = size(vertex,1);
II = [fi;
      fj;
      fk;
      fi;
      fj;
      fi;
      fk;
      fj;
      fk;
      N+fi;
      N+fj;
      N+fk;
      N+fi;
      N+fj;
      N+fi;
      N+fk;
      N+fj;
      N+fk;
      ];
JJ = [N+fi;
      N+fj;
      N+fk;
      N+fj;
      N+fi;
      N+fk;
      N+fi;
      N+fk;
      N+fj;
      fi;
      fj;
      fk;
      fj;
      fi;
      fk;
      fi;
      fk;
      fj;
      ];
QQ = [q11;q22;q33;q12;q21;q13;q31;q23;q32;
    -q11;-q22;-q33;-q12;-q21;-q13;-q31;-q23;-q32];
mA = sparse(II,JJ,0.5*QQ);
end