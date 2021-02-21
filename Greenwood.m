function [f ] = Greenwood( segnum)
%GREENWOOD calculates the resonance frequency of each cochlear segment
%   This function used the Greenwood position-frequency map function (1996)

n=0:1/segnum:1;
f=zeros(1,length(n)-1);
seg=zeros(1,segnum);
for i=1:segnum
    seg(i)=(n(i)+n(i+1))/2;
end

%% Greenwoood parameters
A = 165.44; % for human auditory span it is A=160.1377
alfa = 2.1;
k = 1;
%% Calculate the Greenwood function
fe=zeros(size(seg));
fe=A.*(10.^(alfa.*seg)-k);
f=fliplr(fe);
%% Display if needed
% figure(1)
% stem(seg,f,':r'); 

