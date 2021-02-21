function [diagnosed_OHC] = diagnose_HL (inp_audiogram)
% This function finds an OHC confguration that can produce the input
% audiogram, using Nelder-Maud optimization method. 

audiogram=inp_audiogram-inp_audiogram(1); % removes the offset.
[ target_cochlear_loss ] = test_interp( audiogram, 'audiogram' );
%% OPTIONAL: Parallel computing (in case you are running on a multi-CPU computer) for speeding up the execuation of the code.

% cluster = parcluster('local');
% job = batch(cluster,'myParallelAlgorithmFcn',4,'Pool',totalNumberOfWorkers-1,'CurrentFolder','.');

%%
initial_guess_OHC=0.5.*ones(1,15);initial_guess_OHC(1:3)=0; %The initial guess is that the most basal OHC are totally damaged ("0") while other OHCs are half-damaged ("0.5").

funct=@(OHC) CostFunc(OHC, target_cochlear_loss); % Define the cost function to be optimized. 

options=optimset('display','iter','MaxIter',1000,'MaxFunEvals',2250); % Options for fminsearch optimization. 

tic, %start timer (for assessng the execuation time of the code. 

[diagnosed_OHC,fval,exitflag,output] = fminsearchbnd(funct,initial_guess_OHC,zeros(1,15),ones(1,15),options); %Run a bound fminsearch.
figure,plot(diagnosed_OHC);

toc, %stop timer.
