function [v_lidar] = vcompensation(N,ex,v1,ey,v2,ez,v3,w4,w5,d)
v_lidar=zeros(N,3);
gx=zeros(N,3);
gy=zeros(N,3);
gz=zeros(N,3);
eh=-ez;
gx(:,1)=1;
gy(:,2)=1;
gz(:,3)=1;
for i=1:N
    v_lidar(i,:)=gx(i,:).*v1(i)+gy(i,:).*v2(i)+gz(i,:).*v3(i);+eh.*cross(ex(i,:).*w4(i),d(i,:))+eh.*cross(ey(i,:).*w5(i),d(i,:));
end
end

