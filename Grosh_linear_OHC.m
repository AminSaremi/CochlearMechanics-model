function [ZL,H_RL,H_BM] = linear_OHC (segnum,omega,area, ratio, fac)

[err,Mbu,Cbu,Rbu,Mo,Ko,Ro] = Lu_mech_par_exp(segnum);%mechanical parameters of BM and OHC
Mb=Mbu.*area;Kb=(1./Cbu).*0.33.*area; Rb=Rbu.*area;
Y=[0.07,-0.1];
k_tot=stiffness(segnum, Y);k_tot=k_tot.*0.33;Ko=0.33.*Ko;
% Y=[0.045,-0.1];
% Kb=stiffness(segnum, Y);Kb=area.*0.24.*Kb;
%Mo=Mou.*area;Ko=Kou.*area;Ro=Rou.*area;
%% the equivalent load impedance according to Li-Neely piezoelectric model
% check point 3 of JASA 2010 paper to calculate effective mass, stiffness and
% resistance
Mt=0.1.*35e-5.*(18*60*1e-9).*exp(5*35*1e-4.*(1:segnum));
Kt=0.1.*35e-5.*6e3.*exp(-220*35*1e-5.*(1:segnum));
Rt=sqrt(Mt.*Kt)./4;

Mr=Mt+(0.66.*Mb);
Kr=Kt+(0.2.*Kb);
Rr=Rt+(sqrt(Mr.*Kr)./4);
% Mr=0.66.*Mb;
% Kr=0.2.*Kb;
% Rr=sqrt(Mr.*Kr)./4;
% function [ZL,H_RL,H_BM] = Lu_linear_OHC (segnum,omega)
% 
% [ Mb,Kb,Rb,Mr,Kr,Rr,Mo,Ko,Ro ] = Lu_mech_par_exp( segnum );%mechanical parameters of BM and OHC
% 
% 
% %%
%% impedances seen from each stage (with loading effect)
% Zeq=zeros(length(omega),1);Zin_BM=zeros(length(omega),segnum);Zin_RL=zeros(length(omega),segnum);ZL=zeros(length(omega),segnum);
% 
% 
% Tr=zeros(1,segnum);Tr=zeros(1,segnum);Tr(1:segnum)=1e-2;Tk(1:segnum-1)=0.0123;kk=Mb(segnum)*((2*pi*16)^2);Tk(segnum)=kk/Kb(segnum);Tr(segnum)=1;
% r=Tr.*Rb;k=Tk.*Kb;
% rmm=(1-Tr).*Rb;kmm=(1-Tk).*Kb;
% Zin_BM(:,segnum)=(Mb(segnum)+(Mo(segnum)/2)).*j.*omega+(r(segnum))-(j.*(k(segnum))./omega);
% for i=segnum-1:-1:1
%     Zeq=(Mb(i)+(Mo(i)./2)).*j.*omega+r(i)-(j.*k(i)./omega);
%     Zin_BM(:,i)=Zeq+paralel(Zin_BM(:,(i+1)),rmm(i)-(j.*kmm(i)./omega));  
% end
% 
% r=Tr.*Rr;k=Tk.*Kr;
% rmm=(1-Tr).*Rr;kmm=(1-Tk).*Kr;
% Zin_RL(:,segnum)=(Mb(segnum)+(Mo(segnum)/2)).*j.*omega+(r(segnum))-(j.*(k(segnum))./omega);
% for i=segnum-1:-1:1
%     Zeq=(Mr(i)+(Mo(i)./2)).*j.*omega+r(i)-(j.*k(i)./omega);
%     Zin_RL(:,i)=Zeq+paralel(Zin_RL(:,(i+1)),rmm(i)-(j.*kmm(i)./omega));  
% end
% 
% ZL=paralel(Zin_BM,Zin_RL);
% 
%%
Z1=zeros(length(omega),segnum);Z2=zeros(length(omega),segnum);ZL=zeros(length(omega),segnum);
for i=1:segnum
    Z1(:,i)=(Mb(i)+(Mo(i)/2)).*j.*omega+Rb(i)-(j.*Kb(i)./omega);
    Z2(:,i)=(Mr(i)+(Mo(i)/2)).*j.*omega+Rr(i)-(j.*(Ko(i)+Kr(i))./omega);
    ZL(:,i)= paralel(Z1(:,i),Z2(:,2));
end

% for i=1:segnum
%     %ZL(:,i)= paralel(Mb(i).*j.*omega+Rb(i)-(j.*Kb(i)./omega),Mo(i).*j.*omega+Ro(i)-(j.*Ko(i)./omega)); %case 1: OHC and BM are in parallel
%     ZL(:,i)= paralel((Mb(i)+(Mo(i)/2)).*j.*omega+Rb(i)-(j.*Kb(i)./omega),(Mr(i)+(Mo(i)/2)).*j.*omega+Rr(i)-(j.*(Ko(i)+Kr(i))./omega)); %case 2: BM and RL in parallel with OHC in between
% end

%% Open loop gain of OHC which is (Ho=epsilon_o/epsilon_r) according to Li-Neely JASA 2009

[ err,T, K, alfa_d,alfa_v,Imax,G,C,Cg ] = Grosh_electro_par_exp(segnum); % retrieve the electrical parameters
eta=zeros(length(omega),1);Ho=zeros(length(omega),segnum);H_RL=zeros(length(omega),segnum);H_BM=zeros(length(omega),segnum);

alfa_d=ratio*alfa_d;
alfa_v=ratio*alfa_v;
for i=1:segnum
    eta=(alfa_v(i).*j.*omega)+alfa_d(i);
    Ho(:,i)=(T.*eta./Cg(i))./((j.*omega.*Cg(i))+((G(i)+(j.*omega.*C(i))).*(1+((T^2).*Cg(i).*(Ko(i)+(j.*omega.*ZL(:,i)))))));
end
%% loading impedance
% Z_bm=zeros(length(omega),segnum);Z_rl=zeros(length(omega),segnum);
% for i=1:segnum
%     Z_bm(:,i)=(Mb(i).*j.*omega)+Rb(i)-(j.*Kb(i)./omega);
%     Z_rl(:,i)=(Mr(i).*j.*omega)+Rr(i)-(j.*(Ko(i)+Kr(i))./omega);
% end
% H_RL=((Z_bm./(Z_rl+Z_bm)).*Ho)+1;% feedforward!
% H_BM=((Z_rl./(Z_rl+Z_bm)).*Ho)+1;
%% mechanical gain of OC
g_base=0.39; g_apex=0.92;
a=(g_apex-g_base)/segnum;
OC_gain=a.*(1:segnum)+g_base;

for i=1: segnum
  H_RL(:,i)=fac(i).*(OC_gain(i).*((Z1(:,i)./(Z1(:,i)+Z2(:,i))).*Ho(:,i)))+1;% feedforward!
  H_BM(:,i)=fac(i).*(OC_gain(i).*1e-3.*(Z2(:,i)./(Z1(:,i)+Z2(:,i))).*Ho(:,i))+1;
end
%% Simulation of noise induced-hearing loss
% for i=1: 23
%   H_RL(:,i)=0.5.*(OC_gain(i).*((Z1(:,i)./(Z1(:,i)+Z2(:,i))).*Ho(:,i)))+1;% feedforward!
%   H_BM(:,i)=0.5.*(OC_gain(i).*1e-3.*(Z2(:,i)./(Z1(:,i)+Z2(:,i))).*Ho(:,i))+1;
% end
% 
% for i=24: 41
%   H_RL(:,i)=1;% feedforward!
%   H_BM(:,i)=1;
% end
% 
% for i=42: 55
%   H_RL(:,i)=0.5.*(OC_gain(i).*((Z1(:,i)./(Z1(:,i)+Z2(:,i))).*Ho(:,i)))+1;% feedforward!
%   H_BM(:,i)=0.5.*(OC_gain(i).*1e-3.*(Z2(:,i)./(Z1(:,i)+Z2(:,i))).*Ho(:,i))+1;
% end
% H_RL(:,48:52)=1;
% H_BM(:,48:52)=1;
