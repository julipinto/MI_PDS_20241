% Carregar o sinal de áudio
[sinal, fs] = audioread('SinalFiltrado-blackman.wav');

% Transformada de Fourier do sinal original
S = fft(sinal);
f = (0:length(S)-1)*fs/length(S);

% Modulação de pitch
factor = 1.2; % Fator de modulação de pitch
modulated_signal = resample(sinal, round(fs*factor), fs);

% Transformada de Fourier do sinal modulado
S_mod = fft(modulated_signal);
f_mod = (0:length(S_mod)-1)*(fs*factor)/length(S_mod);

% Plotando os espectros
subplot(2,1,1);
plot(f, abs(S));
title('Espectro de Frequência Original');
xlabel('Frequência (Hz)');
ylabel('Magnitude');

subplot(2,1,2);
plot(f_mod, abs(S_mod));
title('Espectro de Frequência Após Modulação de Pitch');
xlabel('Frequência (Hz)');
ylabel('Magnitude');

