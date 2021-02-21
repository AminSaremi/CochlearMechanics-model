function [ Pos,CF ] = Pos_Fre( Flow,Fhigh,N )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% Greenwoood parameters
A = 165.44; % for human auditory span it is A=160.1377
alfa = 2.1;
k = 1;
Plow=(log10((Flow/A)+k)/alfa);
Phigh=(log10((Fhigh/A)+k)/alfa);
buff=zeros(1,N+1);Pos=zeros(1,N);
for i=1:N
    Pos(i)=((Plow-Phigh)/(N-1))*(i-1)+Phigh;
end

%%
CF=zeros(size(Pos));
CF=A.*(10.^(alfa.*Pos)-k);
Pos=1-Pos;
%%

