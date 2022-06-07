%% REMEMBER PATH CHANGES%%

close all
clear all
clc

% Load data
folder = 'KF_210417'; % Naming conventions
run = '21417007'; % Clampex ABF naming conventions
basepath = 'Z:\home\kayla\Electrophysiology\';
mousepath = [folder '\' run '.abf'];
[d,si,h] = abfload([basepath mousepath]); % Sampling at 50 kHz. d: columns number of samples in a single sweep by the number of sweeps in file; s: sampling interval in us; h: file information

clc

% Define original signal corresponding to 9s of spont IPSC activity 
single_sweep = d(50000:end, 20);
% Sampling frequency
Fs = 50000; 
% Filter order
order = 2;
% Cutoff frequency
Fc = 5;
% Sampling period
T = 1/Fs;
% Length of signal 
L = 450000; 
% Time vector
t = (0:L-1)*T; 

% Plot the original signal
figure;
plot(single_sweep); title('Original signal X(t)')
xlabel('t (seconds)')
ylabel('X(t)')

% To construct the filter we call `butter` with the order and 
% the NORMALIZED cut-off frequency. The cut-off frequency is normalized
% to the Nyquist.
[b, a] = butter(order, Fc / (Fs / 2), 'high');
% Filter the signal in the forward and reverse directions (doubles the
% order). 
filtered_signal = filtfilt(b, a, single_sweep);

% Fourier transform the filtered signal
Y = fft(filtered_signal);

% Compute the two-sided spectrum P2, then compute the single-sided spectrum
% P1 bsed on P2 and the even-valued signal length L
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

% Define the frequency domain f and plot the single-sided spectrum P1. On
% average, longer signals produce better frequency approximations
f = Fs*(0:(L/2))/L;
figure;
plot(f, P1); title('Single-sided amplitude spectrum of X(t)')
xlabel('f (Hz)');
ylabel('|P1(f)|');