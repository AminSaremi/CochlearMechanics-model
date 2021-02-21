function [ sig, SIG, freq ] = stimuli( f,B,L,Fs,t_length,t_fade,type )
% STIMULI can create three types of stimuli:tone,narrow-band and broad band
%%%%%%%%% By: Amin Saremi, PhD. (amin.saremi@uni-oldenburg.de) %%%%%%%%%%%%
%%%%%%%%% Last update: July 2014 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   INPUT:
%           f = center frequency (Hz)
%           B = band width (Hz)
%           L = intensity level (dB SPL)
%           Fs= sampling frequency (Hz)
%           t_length = length of the stimuli (sec)
%           t_fade= fading time (to minimize the spectral splatter),
%                   if no fading is desired then t_fade=0
%           type:
%                'tone': pure tone
%                'narrow_band': narrow-banded noise
%                'broad_band': broad-band noise

%   Output:
%           sig: the resultant signal
%           SIG: the spectrum (FFT) of the resultant signal 
%           freq: the frequencies at which the spectrum has been calculated

%%
t=0:1/Fs:t_length;
sig=zeros(size(t));
if strcmp (type, 'tone')
    sig=2e-5*10^(L/20).*sin(2*pi*f.*t);
    if t_fade ~= 0
        sig=Fade( sig,t_fade,Fs );
    end
    b=0;% no filtering is required
elseif strcmp(type, 'broad_band')|| strcmp(type, 'narrow_band')    
    n=rand(1,length(t));
    w1=(f-(B/2))/(Fs/2);w2=(f+(B/2))/(Fs/2);
    N=floor(4/(w2-w1));% calculate the optimal fir order (N=4/normalised band width)    
    b=fir1(N,[w1 w2]);
    y = filter(b,1,n);
    rms=sqrt(sum(y.^2)/length(y));
    Ln=2e-5.*(10^(L/20));% SPL to magnitude
    sig=(Ln/rms).*y;% normalise the signal to the desired SPL level(non-calibrated)
else
    display('Error, please read the instruction carefluuy'),
end

% verify_level_DB_SPL=20*log10(sqrt(sum(sig.^2)/length(sig))/2e-5) % verify that the normalization has been correctly done.

%% Caluclate the spectrum using the Fast-Fourier Tranformation
SIG=fft(sig);
le=length(sig);
freq = ((1:le/2)-1)*Fs/(le);

%% Visualize
% [h,freqs]=freqz(b,1,round(Fs/10),'half',Fs);
% figure(1),
% plot(freqs,db(abs(h))),title('the magnitude of the filter frequency response'), xlabel('Frequency [Hz]'), ylabel('Level [dB]');
% 
% figure(2),
% plot(freq,20.*log10(abs(SIG(1:le/2))/2e-5),'r');title('the spectrum of the stimuli'); xlabel('Frequency [Hz]'); ylabel('Level [dB SPL]');
% 
% figure(3),
% plot(t,sig),
end

