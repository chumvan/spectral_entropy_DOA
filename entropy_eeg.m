function [H,t] = entropy_eeg(eeg,fs)
%	Computes spectral entropy for EEG


% in:	
% eeg -	EEG signal
%	fs	- sampling frequency (Hz)
%	out:	
% H	- spectral entropy over 0.5-32 Hz
%	t	- time axis (seconds)

eeg_length = length(eeg); %number of samples in (filtered) EEG
wlen = 5; %window length to calculate PSD over (seconds)
overlap = 50; % percentage overlap for windows
H_length = round(1 + eeg_length /(wlen*fs*((100-overlap)/100))); %estimate the number of power spectrum estimations

H = zeros(H_length,1)*NaN;   %initialization array containing spectral entropy values
t = zeros(H_length,1)*NaN; %initialization array containing time instances at which spectral entropy values are calculated

%spectrum calculation over first window
t0 = 1;  %first sample of the window
t1 = wlen * fs; %last sample
step = round(fs*wlen*(100-overlap)/100); %number of samples to shift the window each step
cnt = 1; %step counter
%[PSD,f] = psd(eeg(t0:t1),t1-t0+1,fs,hanning(t1-t0+1),0); %first PSD calculation (alternatively, use spectrum.welch)
%PSD now contains PSD values at the frequencies given in array f 
[PSD, f] = pwelch(eeg(t0:t1),hanning(t1-t0+1),0,t1-t0+1,fs);

f_low = 0.8;   %lower limit of frequency range of interest
f_high = 32.0; %upper limit of frequency range of interest
ind_f = find(f>=f_low & f<=f_high);  %find indexes of relevant frequencies in f array
sf = log(length(ind_f)); %scaling factor, needed for normalization of spectral entropy

%now move the window through the eeg data and calculate PSD and Entropy at
%each position and write to H array
while t1<eeg_length  %as long as the last sample of the window is not beyond the EEG signal end
  %PSD = psd(eeg(t0:t1),t1-t0+1,fs,hanning(t1-t0+1),0); %calculate the PSD over a window
  % PSD has been removed
  
  PSD = pwelch(eeg(t0:t1),hanning(t1-t0+1),0,t1-t0+1,fs);
  
  t(cnt) = t1/fs; %time instance of PSD (and entropy calculation), defined as end of window
  H(cnt) = spectral_entropy(PSD(ind_f),sf);  %calculate normalized spectral entropy over ind_f freq band - WRITE FUNCTION CONTENTS YOURSELF
  t0 = t0+step; %update start position of window
  t1 = t1+step; %update end position of window
  cnt = cnt+1; %update step counter
end


