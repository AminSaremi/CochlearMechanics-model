function error = CostFunc(OHC_input_15,target_cochlear_loss)
% target_cochlear_loss includes the first 80 values (corresponding to CFs
% from 100Hz and above) of the target cochlear amp loss. 
% OHC integrity consists of 15 variables that will cover the main 70 values
% of the OHC_integrity (from index 1 to 70). The rest (index 70 to 100) are
% assumed "1" (intact OHC). 
segnum=100;
L=30; % Run the model for low-intensity sound levels (i.e. 30 dB SPL). For L=50 dB SPL, run the respective lines.
% 
%%
[ OHC_71 ] = test_interp( OHC_input_15, 'OHC'); % interpolate 15 points to 71 points.
OHC_integrity(1:71)=OHC_71; OHC_integrity(72:100)=1; % Create 100 points of OHC. The last 30 OHCs (most apical) are assumed intact ('1') through whole analysis. 
%% Cochlear responses

[F_active,Bf_active]=Saremi2015(segnum,L,OHC_integrity); % Run the cochlear model.
Fr_cochlea=zeros(size(F_active));
for i=1:segnum
    Fr_cochlea(:,i)=F_active(:,i)./F_active(2,i);% the cochlear model response
end
cochlear_amp=zeros(1,segnum);
for i=1:segnum
    cochlear_amp(i)=max(abs(Fr_cochlea(:,i))); % The amplitude of the cochlear model response. 
end

% The amplitude of the healthy cochlea
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




%amp_loss=(60/47).*(db(cochlear_amp)-db(healthy_cochlear_amp)); if L=50;
amp_loss=db(cochlear_amp)-db(healthy_cochlear_amp); % The cochlear amplification loss due to the given OHC lesions.
%error=(1/65).*sum((target_cochlear_loss-amp_loss(14:78)).^2); % Mean squared error....if L=50
error=(1/64).*sum((target_cochlear_loss-amp_loss(16:79)).^2); % Mean squared error.... if L=30 
    