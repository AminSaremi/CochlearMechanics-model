function [amp_loss,Bf_healthy] = cal_audiogram(OHC_integrity)
%This function estimates the hearing threshold elevations due to the OHC
%lesions (specified in OHC_integrity). 
%%
segnum=100; %number of cochlear partitions in the model
L=30; % Run the model for low-intensity sound levels. 

%% Cochlear responses

[F_active,Bf_active]=Saremi2015(segnum,L,OHC_integrity); % Run Saremi-Stenfelt cochlear mechanics model.
Fr_cochlea=zeros(size(F_active));
for i=1:segnum
    Fr_cochlea(:,i)=F_active(:,i)./F_active(2,i);
end
cochlear_amp=zeros(1,segnum);
for i=1:segnum
    cochlear_amp(i)=max(abs(Fr_cochlea(:,i))); % the amplitude of the cochlear model response.
end

% below is the cochlear amp for the case L=30 dB
OHC_healthy=ones(1,segnum); % All OHCs are intact.
[F_active_healthy,Bf_healthy]=Saremi2015(segnum,L,OHC_healthy); % Run the model.


% Below are the amplitude of the cochlear responses in case all OHCs are
% intact.

healthy_cochlear_amp=[    7.9452   10.5011   13.8010   18.0186   23.3643   30.0843   38.4628   48.8216   61.5196   76.9492 ...
       95.5298  117.6984  143.8958  174.5488  210.0480  250.7205  296.8000  348.3925  405.4416  467.6940 ...
       534.7    605.6    679.6    755.2    831.0    905.3    975.9    1041.1    1098.6    1146.5 ...
       1183.0    1206.7    1216.5    1211.8    1192.7    1159.5    1113.5    1056.0    989.1    915.0 ...
       836.0046  754.4939  672.7259  592.7276  516.2185  444.5587  378.7286  319.3361  266.6484  220.6406 ...
       181.0536  147.4557  119.3011   95.9829   76.8761   61.3713   48.8984   38.9412   31.0455   24.8200 ...
       19.9352   16.1174   13.1434   10.8325    9.0404    7.6523    6.5772    5.7434    5.0942    4.5855 ...
       4.1831    3.8611    3.5999    3.3850    3.2058    3.0545    2.9251    2.8134    2.7160    2.6305 ...
       2.5557    2.4915    2.4369    2.3877    2.3384    2.2867    2.2361    2.3047    2.4288    2.5586 ...
       2.6909    2.8215    2.9448    3.0540    3.1413    3.1977    3.2119    3.1644    2.9884    1];



amp_loss=db(cochlear_amp)-db(healthy_cochlear_amp); % The amplification loss due to OHC lesions.
 

end

