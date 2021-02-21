function [kB]= stiffness(n,Y)
Cb_hat=1./[5.9e5,4e4,1.6e3];
mid=n/2;
x=[1,mid,n];
Cb_human=1e3.*Cb_hat(1).*exp(Y(2)+(Y(1).*(1:n)));
kB=1./Cb_human;