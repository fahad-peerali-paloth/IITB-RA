function [ex,ey,ez] = ecomponents(N,R,P,Y)
ex=zeros(N,3);
ey=zeros(N,3);
ez=zeros(N,3);
for i=1:N
    ex(i,1)=cos(Y(i))*cos(P(i));
    ex(i,2)=-sin(Y(i))*cos(P(i));
    ex(i,3)=sin(P(i));
    ey(i,1)=-cos(R(i))*sin(Y(i))+sin(R(i))*cos(Y(i))*sin(P(i));
    ey(i,2)=-cos(R(i))*cos(Y(i))-sin(R(i))*sin(Y(i))*sin(P(i));
    ey(i,3)=-sin(R(i))*cos(P(i));
    ez(i,1)=sin(R(i))*sin(Y(i))+cos(R(i))*cos(Y(i))*sin(P(i));
    ez(i,2)=sin(R(i))*cos(Y(i))-cos(R(i))*sin(Y(i))*sin(P(i));
    ez(i,3)=-cos(R(i))*cos(P(i));
end
end

