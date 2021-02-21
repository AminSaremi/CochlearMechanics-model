function [ y ] = Fade( x,t_fade,Fs )
%Fade function takes a sequency and adds a rise and fall to it
%   t_fade: fading time
%   Fs: sampling frequency
%% Creat the 'fade in' and 'fade out'
t_max=(length(x)-1)/Fs;
t_in=0:1/Fs:t_fade;

f_fade=(0.01*25)/t_fade; % the best fading frequency for t_fade=0.01s turns to be 26 Hz. Find the appropriate f_fade for other t_fade values.

%%
fade_in=(sin(2*pi*f_fade.*t_in)).^2;
%t_out=t_max:-1/Fs:(t_max-t_fade);
t_out=t_fade:-1/Fs:0;
fade_out=(sin(2*pi*f_fade.*t_out)).^2;
%% multiply with the original signal
y=zeros(size(x));y=x;
y(1:length(t_in))=fade_in.*x(1:length(t_in));
y(length(y)-length(t_out)+1:length(y))=fade_out.*x(length(x)-length(t_out)+1:length(x));
%% display
% figure(2)
% plot(t_in,fade_in);
% figure(3)
% plot(length(y)-length(t_out)+1:length(y),fade_out);
% figure(4)
% plot(0:1/Fs:(length(y)-1)/Fs, y);hold on, plot(0:1/Fs:(length(y)-1)/Fs,x,'r');

end