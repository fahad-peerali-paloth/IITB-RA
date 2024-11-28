filename = 'raw_file.xlsx';
data = readmatrix(filename);
alldata=data(:,:);
N=length(alldata);
phi=28;
theta=180;
velocity_scale=1; %knots to m/s conversion
theta_scale=pi()/180;
ux=zeros(N,12);
uy=zeros(N,12);
uz=zeros(N,12);
MCux=zeros(N,12);
MCuy=zeros(N,12);
MCuz=zeros(N,12);
U_uncompensated=zeros(N,12);
ux(:,:)=alldata(:,45:56);
uy(:,:)=alldata(:,57:68);
uz(:,:)=alldata(:,69:80);
MCux=alldata(:,9:20);
MCuy=alldata(:,21:32);
MCuz=alldata(:,33:44);
U_uncompensated=alldata(:,81:92);%%%%%%%%%%%edit ITTTTTTT

%bin 17 time stamps
Umean=zeros(N,12);
%Uxmean=zeros(1,n);
%Uymean=zeros(1,n);
%Uzmean=zeros(1,n);
Umean=alldata(:,93:104);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Assumed bouy motion data
R=zeros(1,N);
P=zeros(1,N);
Y=zeros(1,N);
R=alldata(:,3)*theta_scale;
P=alldata(:,4)*theta_scale;
Y=alldata(:,5)*theta_scale;
v1=zeros(1,N);
v2=zeros(1,N);
v3=zeros(1,N);
v4=zeros(1,N);
v5=zeros(1,N);
v6=zeros(1,N);
v1=alldata(:,6);%these are north,west,zenith components of platform so no need to coordinate conversion.
v2=alldata(:,7);%on IMU data one have to convert it to NWZ ground coordinate
v3=alldata(:,8);
%v4=alldata(:,13);
%v5=alldata(:,14);
%v6=alldata(:,15);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[northwind,westwind,zenithwind]=MRUtoGlobal(N,R,P,Y,ux,uy,uz);
[ex,ey,ez]=ecomponents(N,R,P,Y);
d_off=2.350; %lidar placement z offset
d=-d_off.*ez;
%[v_lidar]=vcompensation(N,ex,v1,ey,v2,ez,v3,v4,v5,d);
eh=-ez; %eLOS=eh; since single point data
%[v_lidar2]=LOScomp(eh,v_lidar,-phi*theta_scale);
%v_LOSi=eh.*v_lidar;
%v_LOS=[v_LOSi(:,1)*cos(phi*theta_scale)+v_LOSi(:,2)*sin(phi*theta_scale) v_LOSi(:,1)*sin(phi*theta_scale)-v_LOSi(:,2)*cos(phi*theta_scale) -v_LOSi(:,3)];
v_LOS(:,1)=v1;
v_LOS(:,2)=v2;
v_LOS(:,3)=v3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%giving an measurement error margin for each height due to wind shear at tht height
%wind shear: 
%first interpolate the Umean; for that you need at least U mean at two more height
%so we are going with an assupmtion that at h=57 m the wind U mean is 10to20% variation
%and at h=0m, U mean =0, assupmtion
h0=0;
h=[49 60 80 90 100 120 140 160 180 200 220 240];
Umean_0=zeros(N,1);
%for each h find delz
delz=zeros(N,12);
for i=1:N
    for k=1:12
        delz(i,k)=h(k)*(eh(i,3)-1);
    end
end

xx3=zeros(N,12);
yy3=zeros(N,12);
delUz=zeros(N,12);
%get value of U(z+delz) from U mean interpolation
for i=1:N
    for k=1:12
        xx3(i,k)=h(k)+delz(i,k);
        if (xx3(i,k)<0.0001)&&(xx3(i,k)>-0.0001)
            xx3(i,k)=0;
        end
        yy3(i,k)= interp1(h, Umean(i,:), xx3(i,k), 'linear', 'extrap');
        delUz(i,k)=Umean(i,k)-yy3(i,k);
    end
end

shear_err=zeros(N,3,12);
for i=1:N
    for k=1:12
        shear_err(i,:,k)=delUz(i,k).*eh(i,:);
    end
end

v_LOS2=zeros(N,3,12);
for k=1:12
    v_LOS2(:,:,k)=v_LOS+shear_err(:,:,k);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
u_compensatedi=zeros(N,3,12);
u_compensated=zeros(N,3,12);
U_compensated=zeros(N,12);
u_uncompensatedi=zeros(N,3,12);
u_uncompensated=zeros(N,3,12);
MCU_compensated=zeros(N,12);
for i=1:N
    for k=1:12
        u_uncompensatedi(i,:,k)=[northwind(i,k) westwind(i,k) zenithwind(i,k)];
        u_compensated(i,:,k)=u_uncompensatedi(i,:,k)-v_LOS2(i,:,k);
        U_compensated(i,k) = sqrt(u_compensated(i,1,k)^2 + u_compensated(i,2,k)^2 + u_compensated(i,3,k)^2);
        MCU_compensated(i,k)=sqrt(MCux(i,k)^2+MCuy(i,k)^2+MCuz(i,k)^2);
    end
end
filenamex='U_checkF16.xlsx';
writematrix(U_uncompensated, filenamex, 'Sheet', 'U_uncompensated');
writematrix(U_compensated, filenamex, 'Sheet', 'U_compensated');
writematrix(MCU_compensated, filenamex, 'Sheet', 'MCU_compensated');
writematrix(ux, filenamex, 'Sheet', 'uxUN');
writematrix(u_compensated(:,1,:), filenamex, 'Sheet', 'uxCOMP');
writematrix(MCux, filenamex, 'Sheet', 'uxMCU');
writematrix(uy, filenamex, 'Sheet', 'uyUN');
writematrix(u_compensated(:,2,:), filenamex, 'Sheet', 'uyCOMP');
writematrix(MCuy, filenamex, 'Sheet', 'uyMCU');
writematrix(uz, filenamex, 'Sheet', 'uzUN');
writematrix(u_compensated(:,3,:), filenamex, 'Sheet', 'uzCOMP');
writematrix(MCuz, filenamex, 'Sheet', 'uzMCU');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n=144;%%%%enter the number of bins you like to create
TI_comp=turbulencec(n,U_compensated);
TI_uncomp=turbulencec(n,U_uncompensated);
TI_mca=turbulencec(n,MCU_compensated);
filenamex='TI_checkF16.xlsx';
writematrix(TI_uncomp, filenamex, 'Sheet', 'TI_uncomp');
writematrix(TI_comp, filenamex, 'Sheet', 'TI_comp');
writematrix(TI_mca, filenamex, 'Sheet', 'TI_mca');
%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%