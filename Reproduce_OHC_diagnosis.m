%% %%% Last updated on 7/2/2021 by Amin Saremi %%%%%%%
% This script reproduces figure 11 of Saremi and Stenfelt (2021)
%%
clear all,
close all,
%% load a measured audiogram

%below are the hearing thresholds (audiograms) measured from 7 NIHL participants
% at 0.125,0.25,0.5,0.75,1,1.5,2,3,4,6,and 8 kHz.

fre=[125,250,500,750,1000,1500,2000,3000,4000,6000,8000]; % Frequencies at which audiometries were performed.
audiogram_Magnus_Backstrom_R=[0,0,0,-6,-10,-10,-10,-10,-40,-65,-45]; % participant#1
audiogram_Stefan_P=[-10 -10, -25,-25,-30,-30,-40,-50,-65,-60,-55]; % participant#2
audiogram_Niklas_t=[-10,-10,-12,-15,-15,-25,-25,-35,-45,-50,-45]; % participant#3
audiogram_Tommy_K=[-5,-5,-5,-5,-5,-15,-10,-35,-45,-60,-50]; % participant#4
audiogram_Lars_D=[-12,-12,-12,-20,-25,-40,-50,-65,-70,-45,-40]; % participant#5
audiogram_Jonas_O=[-10,-10,-10,-10,-10,-12,-32,-45,-60,-40,-10]; % participant#6
audiogram_Anders_S=[-2,-5,-5,-5,-15,-15,-15,-40,-45,-40,-30]; % participant#7
audiograms_bank=[audiogram_Magnus_Backstrom_R; audiogram_Stefan_P; audiogram_Niklas_t; audiogram_Tommy_K;audiogram_Lars_D; audiogram_Jonas_O; audiogram_Anders_S];

inp_audiogram=mean(audiograms_bank); %This is the average of the data. Use this audiogram as the input to the diagnosis algorithm


%% Run the diagnosis algorithm (15-point optimization task)
[diagnosed_OHC] = diagnose_HL (inp_audiogram) % Run the diagnosis algorithm on this clinically-measured audiogram. The output is a 15-point data covering the first 70% of the cochlea.


%% Expand the results into 100 partitions
[ OHC_71 ] = test_interp( diagnosed_OHC, 'OHC' ); % expand (interpolate) 15 point of the data into 71 points.
OHC_integrity= ones(1,100); OHC_integrity(1:71)=OHC_71; % copy the first 71 points from above. The most 30% apical region of the cochlea (partition 71 to 100) is intact. integrity=1;

%% calculate the cochlear amplification loss due to the configuration in OHC_integrity.
[amp_loss,Bf_healthy] = cal_audiogram(OHC_integrity); 

%% plot the figures

% Figure 11(A): plot the average audiogram
close all,
figure,
M=mean(audiograms_bank);
SD=std(audiograms_bank);
errorbar(fre,M,SD/2,'k')
set(gca,'xscale','log')
hold on, semilogx(fre,M,'ok')
xlabel('Frequency [Hz]');
ylabel('Hearing thresholds [dB]');
legend('Measured audiogram');

% Figure 11(B): plot the diagnosed OHC configuration
figure,
initial_guess=zeros(1,100);
initial_guess(71:100)=1;
initial_guess(1:15)=0;
initial_guess(16:70)=0.5;
plot([1:100]./100,OHC_integrity,'ok')
hold on, plot([1:100]./100,initial_guess,'color',[0.7,0.7,0.7])
hold on, plot([1:100]./100,OHC_integrity,'k')
xlabel('coclear location [0=base, 1=apex]');
ylabel ('OHC integrity');
ylabel ('OHC integrity [0=dead, 1=healthy]');
legend ('Model prediction','initial guess'); 

% Figure 11(C): The cochlear amplification loss associated with the
% diagnosed OHC configuration 

figure,
semilogx(fre,inp_audiogram,'ok','LineWidth',1.5);
hold on, semilogx(Bf_healthy,amp_loss+inp_audiogram(1),'k')
hold on, semilogx(fre,inp_audiogram,'--k')
axis([125 8000 -55 0])
xlabel('Frequency [Hz]');
ylabel('Hearing thresholds [dB]');
legend('Measured audiogram','Model output');


