function [ out ] = test_interp( inp, flag )
% This function interpolates the data points given in the input. 


if strcmp(flag,'OHC') % If the input data points are type OHC.     
    out=zeros(1,71);
    Xq=1:71;X=1:5:71;
    out=interp1(X,inp,Xq); % Interpolaate the given 15 points into 71 ppoints.
    close all,
    plot(X,inp,'ob',Xq,out,'r');
else % If the input data is not type OHC (then it is audiogram),
    fe=[125,250,500,750,1000,1500,2000,3000,4000,6000,8000]; %The input frequency axis

% if simulation is done at L=30 then these are the output frequency axis
% (64 points covering frequencies between 100 and 8000 Hz)
fe_model= [7851,7583,7323,7070,6825,6586,6355,6130,5912,5700,5494,5294,5100,4912,4730,4553,4381,... 
               4215,4053,3896,3744,3597,3454,3315,3180,3049,2922,2798,2678,2561,2447,2336,2227,...
               2121,2018,1916,1817,1719,1623,1529,1436,1344,1254,1164,1075,988,902,817,735,...
               655,580,510,447,391,342,300,264,234,209,187,168,152,138,125];
               
    out=zeros(1,64); % If done at L=30;
    Xq=fe_model;X=fe;
    out=interp1(X,inp,Xq); 
    figure,
    plot(X,inp,'ob',Xq,out,'r');
end
    
    
    

