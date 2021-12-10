function res = make_freq_plot(x, Fs)

% make a frequency domain plot with frequency labels
%
%   x = input signal
%   Fs = sampling frequency in Hz

if(mod(length(x),2) ~=0)
    x = x(1:end-1);
end

x_vals = linspace(-Fs/2, Fs/2-Fs/length(x),length(x));
y_vals = 1/length(x)*fftshift(abs(fft(x)));

[max_y, maxidy] = max(y_vals);
max_x = abs(x_vals(maxidy));

% [pks,locs] = findpeaks(y_vals((length(y_vals)/2):end));

plot(x_vals, y_vals);

ylabel('Magnitude of FFT');
xlabel('Frequency (Hz)');

res = max_x;
