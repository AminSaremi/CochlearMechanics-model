function [F_active,Bf_active,freq]=Saremi2015(segnum,LdB,fac)
%% This function calculates the cochlear amplification and cochlear position-frequency map using Saremi-Stenfelt model.

% INPUT parameters:
% Segnum : number of cochlear partitions
% LdB= the input sound intensity
% fac : the OHC integrity at each partition ('1'= fully healthy, '0'= dead)

% OUTPUT:
% F_active: The frequency response of each partition
% Bf_active : The best frequency (BF) of each partition.
% freq : Te frequency axis. 

%%
fs=44100;t_sec=1;
t=0:1/fs:t_sec;
le=length(t);
freq = ((1:le/2)-1)*fs/(le);
omega=freq';
%% recruit the mechanical parameters
centers=1:segnum;%the user specifies the number of cochlear partitions
[ err,Mb,Cb,Rb,Mo,Ko,Ro ] = Lu_mech_par_exp( segnum);%calculate the BM and OHC mechanical parameters of each segment using Liu and Neely (2001)
m_tot=Mb; r_tot=Rb;% The BM mechanical parameters per unit area (per cm2)
Y=[0.07,-0.1];
k_tot=stiffness(segnum, Y);
%% calculate the area of each partition
b=zeros(1,segnum); area=zeros(1,segnum);
for i=1:segnum
    b(i)=(0.051*(5.425+(3.5*i)/100))/(5.425+3.5);
end

area(1)=(3.5/segnum)*(0.031+b(1))/2;

for i=2:segnum
    area(i)= (3.5/segnum)*(b(i)+b(i-1))/2;
end
%% update the mechanical parameters in accordance to the areas
Mb_tot=m_tot.*area; k_tot=0.33.*k_tot.*area;r_tot=r_tot.*area;% multiply the area by the per unit values to obtain each single partition's parameters along the cochlea inSI scale
Mohc=Mo;
Mr=0.66.*Mb_tot;% formula by Grosh
Mt=0.1.*35e-5.*(18*60*1e-9).*exp(5*35*1e-4.*(1:segnum));% formula by Lu (2009)

m_tot= Mb_tot+Mohc+Mr+Mt; % the OHCs, the RL and the TM are resting on the BM as passive loads, therefore the masses should be added together.

%% Greenwood function for resonance frequecies of partitions

fc = Greenwood( segnum );% celculate the resonance frequency of each segment according to Greenwood position-frequency function (1996)


%% The vertical and longitudinal components
Tr=zeros(1,segnum);Tr(1:segnum)=1.2e-2;Tk(1:segnum-1)=1.2e-2;kk=m_tot(segnum)*((2*pi*16)^2);Tk(segnum)=kk/k_tot(segnum);
Tr(segnum)=1;
r=Tr.*r_tot;k=Tk.*k_tot;
rmm=(1-Tr).*r_tot;kmm=(1-Tk).*k_tot;
m=m_tot;

%% impedances seen from each stage (with loading effect)
Zeq=zeros(length(freq),1);Zin=zeros(length(omega),segnum);
Zin(:,segnum)=m(segnum).*1i.*omega+(r(segnum))-(1i.*(k(segnum))./omega);
for i=segnum-1:-1:1
    Zeq=m(i).*1i.*omega+r(i)-(1i.*k(i)./omega);
    Zin(:,i)=Zeq+paralel(Zin(:,(i+1)),rmm(i)-(1i.*kmm(i)./omega));  
end

%% the current amplification factors
Hi=zeros(length(freq),segnum);

for i=segnum-1:-1:1
    Hi(:,i)=(rmm(i)-(1i.*kmm(i)./omega))./(Zin(:,i+1)+(rmm(i)-(1i.*kmm(i)./omega)));
end

Bil=zeros(1,segnum);
for i=1:segnum
    [a,Bil(i)]=max(abs((Hi(:,i))));
end

%% Equivalent frequency response at any point for a passive cochlea
F=zeros(length(freq),segnum);X=zeros(size(F));
F(:,1)=Hi(:,1);  

for i=2: segnum
    F(:,i)=F(:,i-1).*Hi(:,i);
end


for i=1:segnum
    [a,Bf(i)]=max(abs((F(:,i))));
    hold on,
end

%% Equivalent frequency response of a linearised active cochlea
F_trig=zeros(length(freq),segnum);F_active=zeros(length(freq),segnum); H_RL=zeros(length(freq),segnum);H_BM=zeros(length(freq),segnum);
Imax=5e-10;slope_max=0.001743; % these are based on the MET curve
[ratio]=intensity2slope(LdB,Imax,slope_max); % finds the slope ratio on the MET curve
[ZL,H_RL,H_BM] = Grosh_linear_OHC (segnum,omega,area,ratio,fac);

%% if there is feedforward on BM also
F_trig(:,1)=Hi(:,1);
%figure(1000),
for i=2:segnum
    F_trig(:,i)=F_trig(:,i-1).*H_BM(:,i-1).*Hi(:,i);
end
F_active=F_trig.*H_RL;
%F_active=F.*H_RL; if there is no feedworward on BM

Bf_active=zeros(1,segnum);
for i=1:segnum
    [a,Bf_active(i)]=max(abs((F_active(:,i))));
    %hold on,
end
%figure(1),hold on,plot(centers,Bf_active,'--r'),

%% calculate the error (deviation) from the geenwood function
start=5; stop=segnum-12;
N=stop-start+1;
J=zeros(1,N);J_percent=zeros(1,N);
J=abs(fc(start:stop)-Bf_active(start:stop));
J_percent=abs((fc(start:stop)-Bf_active(start:stop))./fc(start:stop));
error=sum(J);
error_percent=sum(J_percent)/N;
