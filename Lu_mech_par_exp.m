%function [ Mb,Kb,Rb,Mrl,Krl,Rrl,Mohc,Kohc,Rohc ] = Lu_mech_par_exp( n )
function [ err,Mb,Cb,Rb,Mo,Ko,Ro ] = Lu_mech_par_exp( n )
% This script produces the mechanical parameters of BM and Outer Hair Cells
% input: 'n' is number of segments of cochlea and should be an even number
% output= based on Table 1. of Liu and Neely (2009)
mid=n/2;
x=[1,mid,n];% Liu and Neely have calculated the parameters in the Base, middle and Apex of the Basilar membrane

%%
S=zeros(6,3);SS=zeros(6,n);err=zeros(6,4);
Mb_hat=[3.8e-5,2.8e-4,2.1e-3];S(1,:)=Mb_hat;%Mass of BM per unit area, [g.cm-2]
Cb_hat=1./[5.9e5,4e4,1.6e3];S(2,:)=Cb_hat;%Compliance of BM per unit area, [g.s-2.cm-2]
Rb_hat=[1.5,3.2,8.6];S(3,:)=Rb_hat;%Resistance of BM per unit area, [g.s-1.cm-2]

Mo_hat=[2.8e-8,5e-7,2.8e-5];S(4,:)=Mo_hat;% Mass in OHC load impedance [g]
Ko_hat=[200,11,0.76];S(5,:)=Ko_hat;%Stiffness in OHC load impedance [g.s-1]
Ro_hat=[9.4e-4,9.2e-4,2.7e-3];S(6,:)=Ro_hat;%Resistance in OHC load impedance [g.s-2]

%%
for i=1:6
    buff=S(i,:);
    buff=buff./buff(1);
    buff=log(buff);
    [Y,p]=polyfit(x,buff,1);
    SS(i,:)=S(i,1).*exp(Y(2)+(Y(1).*(1:n)));
    err(i,1:3)=(S(i,:)-[SS(i,1),SS(i,mid),SS(i,n)])./S(i,:);
    err(i,4)=100*sum(abs(err(i,1:3)))/3;
end

%% output
Mb=1e-3.*SS(1,:);%Mass of BM per unit area, [kg.cm-2]
Cb=1e3.*SS(2,:);%Compliance of BM per unit area, [kg.s-2.cm-2]
Rb=1e-3.*SS(3,:);%Resistance of BM per unit area, [kg.s-1.cm-2]
Mo=1e-3.*SS(4,:);% Mass in OHC load impedance [kg]
Ko=1e-3.*SS(5,:);%Stiffness in OHC load impedance [kg.s-1]
Ro=1e-3.*SS(6,:);%Resistance in OHC load impedance [kg.s-2]

