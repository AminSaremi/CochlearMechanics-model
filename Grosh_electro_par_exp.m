function [ err,T, K, alfa_d,alfa_v,Imax,G,C,Cg ] = electro_par_exp( n )
% This script produces the electro-mechanical parameters of Outer Hair Cells
% input: 'n' is number of segments of cochlea and should be an even number
% output= Exponential estimation based on data from Table 1. of Liu and Neely (2009)
mid=n/2;
x=[1,mid,n];% Liu and Neely have calculated the parameters in the Base, middle and Apex of the Basilar membrane
%%
S=zeros(6,3);SS=zeros(6,n);err=zeros(6,4);
alfa_d_hat=[1.6e-3,6.2e-4,2e-4];S(1,:)=alfa_d_hat;
alfa_v_hat=[4.4e-6,1.8e-6,6.8e-7];S(2,:)=alfa_v_hat;
Imax_hat=1e-12.*[670,320,83];S(3,:)=Imax_hat;
G_hat=1e-9.*[91,51,33];S(4,:)=G_hat;
C_hat=1e-12.*[14,32,79];S(5,:)=C_hat;
Cg_hat=1e-12.*[18,33,70];S(6,:)=Cg_hat;
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
%% Display
% for i=1:6
%     figure(i),
%     plot((1:n),SS(i,:));hold on,stem(x,S(i,:),'--r'),
% end
%% output
% alfa_d=SS(1,:);
% alfa_v=SS(2,:);
% Imax=SS(3,:);
alfa_d=1.6e-3.*ones(size(SS(1,:)));
alfa_v=4.4e-6.*ones(size(SS(1,:)));% Liu&Neely 2009
Imax=500e-12.*ones(size(SS(3,:)));
G=SS(4,:);
C=SS(5,:);
Cg=SS(6,:);
T=2e-13; % assumed
K=0.02;
