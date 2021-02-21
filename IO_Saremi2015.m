%%
% This script simulates the Input-Output transfer function (I/O function) of the cochlea
% at intensities ranging from 10 to 100 dB SPL.
% The I/O functions are also simulated for healthy vs. pathological
% cochleae. 

% This script produces Figure 7 of Saremi and Stenfelt (2021).
%%

close all,
clear all,

%%
fsig=500; % The CF at which the I/O function is assessed.
segnum=100;Flow=37; Fhigh=15900; % Run for 100 cochlear partitions and for frequencies between 37 and 15900 Hz. 
[ Pos,CF_exp ] = Pos_Fre( Flow,Fhigh,segnum ); % Find the cochlear partions that correspond to the given frequency raneg (37 to 15900 Hz).

%%
OHC_integrity=ones(1,segnum); % All OHCs are healthy
[F_active,Bf_active]=Saremi2015(segnum,30,OHC_integrity); % Run the model at 30 dB SPL.

%% Calculate the Q factor of the equivalent rectangular band (Q of ERB) at 3000 Hz
Area_3000=sum(abs(F_active(2:end,35)./abs(F_active(2,35))));
BW_3000=Area_3000./(max(abs(F_active(:,35))));
QERB_3000=3000./BW_3000;

%% at CF
L=10:10:100;Area=zeros(1,length(L));QERB=zeros(1,length(L));BW=zeros(1,length(L));
out=zeros(size(L));CF=zeros(segnum,length(L));phas=zeros(length(F_active(:,1)),length(L));group_delay=zeros(length(F_active(:,1)),length(L));

if fsig==500
    ch_CF=61;
elseif fsig==4000
    ch_CF=26;
end

for i=1:length(L)
    [F_active,Bf_active,freq]=Saremi2015(segnum,L(i),OHC_integrity);
    close all,
    out(i)=20*log10(max(abs(F_active(fsig,:))))+L(i)-20*log10(abs(F_active(fsig,2)));
    CF(:,i)=Bf_active;
    
    Ex_pp=20*log10(abs(F_active(fsig,:)))-20*log10(abs(F_active(fsig,1)));
    [maxi,ch_max]=max(Ex_pp);
    if ch_max==1; ch_max=ch_CF; end; 
end


figure,plot(L,out);
IO_normalized=out-out(1)+10;

%% Physiological data
if fsig==4000
    L_animal=10:10:80;
    IO_raw=[0.25,1,3,4.25,7,9,10.5,11];IO_animal=db(IO_raw);% displacement in nm
elseif fsig==500
    L_animal=[25,31,37,42,48,54,60,66,72,78,84];
    IO_raw=[1.5,3,5,10,20,30,40,60,90,170,300];IO_animal=db(IO_raw);
end

IO_animal_norm=IO_animal-IO_animal(1)+L_animal(1);
%%
figure,
plot(L,IO_normalized,'k', 'LineWidth',2); hold on, plot(L_animal,IO_animal_norm,'xk', 'LineWidth',2);
xlabel('Input Intensity [dB SPL]','FontSize',13);
ylabel('Normalized Output [dB]','FontSize',13);
legend(' Moodel' , 'Physiological Data: Russel and Nilsen (1997)' );


OHC_integrity=zeros(1,segnum);

for i=1:length(L)
    [F_active,Bf_active,freq]=Saremi2015(segnum,L(i),OHC_integrity);
    close all,
    out_mortem(i)=20*log10(max(abs(F_active(fsig,:))))+L(i)-20*log10(abs(F_active(fsig,2)));
    CF(:,i)=Bf_active;
    
    Ex_pp=20*log10(abs(F_active(fsig,:)))-20*log10(abs(F_active(fsig,1)));
    [maxi,ch_max]=max(Ex_pp);
    if ch_max==1; ch_max=ch_CF; end; 
end

figure,
plot(L,IO_normalized,'k', 'LineWidth',2); hold on, plot(L_animal,IO_animal_norm,'xk', 'LineWidth',2);
hold on,plot(L,out_mortem-out(1),'k--','LineWidth',2);
if fsig==4000
    hold on, gray=[0.5,0.5,0.5];plot(L+10,out_mortem-out(1),'color',gray,'LineWidth',2);
end

axis([10 100 10 80])
title_st=['at CF = ', num2str(fsig), 'Hz'];title(title_st, 'FontSize',13);
xlabel('Input Intensity [dB SPL]','FontSize',13);
ylabel('Normalized Output [dB]','FontSize',13);
if fsig==4000
    legend(' Moodel Prediction (active cochlea)' , 'Physiological Data: Russel and Nilsen (1997)' , 'Model Prediction (passive cochlea)','Physiological Data: Ruggero et al. (1997)');
elseif fsig==500
    legend(' Moodel Prediction (active cochlea)' , 'Physiological Data: Rode and Cooper (1996)' , 'Model Prediction (passive cochlea)');
end

