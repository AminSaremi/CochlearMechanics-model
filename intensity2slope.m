function [ratio]=intensity2slope(LdB,Imax,slope_max)

%% copy-paste this to check the nonlinearity:
% L=0:2:100; r=size(L);
% for i=1:length(L)
%     r(i)=intensity2slope(L(i),5e-10,0.001739);
% end
% plot(L,r)
%%


% L=2e-5*(10^(LdB/20));
% 
% L0=2e-5*(10^(10/20));% This is assumed to correspond to the hearing threshold, xr=5e-9 m (LdB=0 dB SPL)
% Lend=2e-5*(10^(100/20));% This is assumed to correspond to the end of the dynamic range, xr=1e-6 m (LdB=100 dB SPL)
% 
% a=((1e-6)-(5e-9))/(Lend-L0);
% Xr=(a*(L-L0))+5e-9
L0=-2;Xr0=2e-9;
Lend=100;Xrend=0.5e-6;
a=(Xrend-Xr0)/(Lend-L0);
Xr=(a*(LdB-L0))+Xr0;

[Ir,slope]=MET2_curve(Xr,Imax);
ratio=slope/slope_max;

%% 
function [Ir,slope]=MET2_curve(Xr,Imax)
x=Xr*1e6;
P1=0.08;P2=0.14; % x-axis position bias
A1=20.8; A2=8.47; % sharpness bias

Ir=Imax./((1+exp(A2.*(P2-x))).*(1+exp(A1.*(P1-x)))); % according to Jeffrey R. Holt,1 David P. Corey and Ruth Anne Eatock, 1997

X1=x*0.975; X2=x*1.025;% plus/minus 2.5%

Ir1=Imax./((1+exp(A2.*(P2-X1))).*(1+exp(A1.*(P1-X1))));
Ir2=Imax./((1+exp(A2.*(P2-X2))).*(1+exp(A1.*(P1-X2))));

slope=(Ir2-Ir1)/((X2-X1)/1e6);
