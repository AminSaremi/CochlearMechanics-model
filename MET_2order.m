function [Ir1,slope1,sens]= MET_2order(x,Imax)
%%
% This function estomates the current produced by the hair cell (Ir1).
% x= The displacement of the stereocillia,
% Imax = The maximum current produced by the hair cell.

%%

x=x*1e6;
P1=0.08;P2=0.14; % x-axis position bias
A1=20.8; A2=8.47; % sharpness bias
Imax2=Imax/2;

Ir1=Imax./((1+exp(A2.*(P2-x))).*(1+exp(A1.*(P1-x)))); % according to Jeffrey R. Holt,1 David P. Corey and Ruth Anne Eatock, 1997
Ir2=Imax2./((1+exp(A2.*(P2-x))).*(1+exp(A1.*(P1-x)))); % according to Jeffrey R. Holt,1 David P. Corey and Ruth Anne Eatock, 1997
slope1=zeros(1,length(Ir1)); sens=zeros(1,length(Ir1)); slope2=slope1;
x=x.*1e-6;
for i=1:length(Ir1)-1
    slope1(i)=(Ir1(i+1)-Ir1(i))/(x(i+1)-x(i));
end

for i=1:length(Ir2)-1
    slope2(i)=(Ir2(i+1)-Ir2(i))/(x(i+1)-x(i));
end

for i=1:length(Ir1)-1
    sens(i)=(slope1(i+1)-slope1(i))/(x(i+1)-x(i));
end
delta_x=x;
figure(10),
plot(delta_x,Ir1,'K')
hold on, plot(delta_x,Ir2,'--K');
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',14)
title('Mechano-electrical transduction of OHC');
xlabel('HB displacement [m]'), ylabel('current [A]');
%axis([-4e-7,11e-7,-1e-10,6e-10]),

figure(20),
plot(delta_x,slope1,'K')
hold on, plot(delta_x,slope2,'--K');
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',14)
title('slope of MET curve');
xlabel('HB displacement [m]'), ylabel('[]');
legend('EP=89mV','EP=44.5mV'),
%axis([-4e-7,11e-7,-1e-10,6e-10]),
