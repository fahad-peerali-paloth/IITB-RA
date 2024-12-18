function [TI] = turbulencec(n,u)
Umean=zeros(n,12);
std_u=zeros(n,12);
TI=zeros(n,12);
for i=1:n
    for j=1:12
        if i<n
            tru=(i-1)*564+1;
            sum=0;
            for k=tru:564*i
                sum=sum+u(k,j);
            end
            Umean(i,j)=(1/564)*sum;
        else
            tru=(i-1)*564+1;
            sum=0;
            for k=tru:564*i-4
                sum=sum+u(k,j);
            end
            Umean(i,j)=(1/560)*sum;
        end
    end
end
for i=1:n
    for j=1:12
        if i<n
            U=Umean(i,j);
            tru=(i-1)*564+1;
            sum=0;
            for k=tru:564*i
                sum=sum+(u(k,j)-U)^2;
            end
            std_u(i,j)=sqrt(1/564*sum);
            TI(i,j)=std_u(i,j)/U;
        else
            U=Umean(i,j);
            tru=(i-1)*564+1;
            sum=0;
            for k=tru:564*i-4
                sum=sum+(u(k,j)-U)^2;
            end
            std_u(i,j)=sqrt(1/560*sum);
            TI(i,j)=std_u(i,j)/U;
        end
    end
end
end
