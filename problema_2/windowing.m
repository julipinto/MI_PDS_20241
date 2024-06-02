close all;
clc;

[Y, Fs] = audioread('SinalRuidoso.wav');
% Removendo parte inicial do áudio

% Tempo final do audio
tfinal = (numel(Y)-1)/Fs;
tinicial = 0;
periodo = 1/Fs;

t = tinicial:periodo:tfinal;

% Plotando o sinal no domi­nio do tempo
figure(1);
plot(t,Y);
title('Sinal Ruidoso');
xlabel('Tempo (s)');
ylabel('Amplitude do sinal');
grid on

% FFT;
N=length(Y);
k=0:N-1;
T=N/Fs; %qtd de periodos
freq=k/T;
X=fftn(Y)/N;
cutOff=ceil(N/2);
X=X(1:cutOff);

figure(2);
plot(freq(1:cutOff),abs(X));
title('Sinal Ruidoso (FFT)');
xlabel('Frequência (Hz)');
ylabel('Amplitude do sinal');
grid on

% ==============================================
% Contrução do filtro:
Fc = 3750;     % Frequencia de corte
Af = 200;     % Janela de transição
%  Fs = Frequencia de amostragem
Os = -50;      % Erro na banda de rejeição

% ----------------------------------------------

% Frequencia de amostragem
Wc = 2 * pi * Fc * (1/Fs);

Wa = 2 * pi * Af * (1/Fs);

% ----------------------------------------------
% Calcular o tamanho da janela

M = round((8 * pi) / Wa); % Cálculo correto do tamanho da janela
if mod(M,2) == 0
  M = M + 1; % Garantir que M seja ímpar
end

nh = (-(M-1)/2:(M-1)/2)';
hamming = 0.54 - 0.46 * cos(2 * pi * nh / (M-1));

passaB = sin(Wc * nh) ./ (pi * nh);
passaB((M-1)/2 + 1) = Wc / pi; % Corrigir divisão por zero

% Cria a figura e plota a função sinc
figure(3);
plot(nh, passaB);
xlabel('Amostra');
ylabel('Amplitude');
title('Função Sinc');
grid on;

Hn = passaB .* hamming;

% Normalizar o filtro
Hn = Hn / sum(Hn);

% Aplicar o filtro ao sinal ruidoso
Y_filt = conv(Y, Hn, 'same');

% Plotar o sinal filtrado no domínio do tempo
figure(4);
plot(t, Y_filt);
title('Sinal Filtrado');
xlabel('Tempo (s)');
ylabel('Amplitude do sinal');
grid on

% FFT do sinal filtrado
X_filt = fftn(Y_filt) / N;
X_filt = X_filt(1:cutOff);

figure(5);
plot(freq(1:cutOff), abs(X_filt));
title('Sinal Filtrado (FFT)');
xlabel('Frequência (Hz)');
ylabel('Amplitude do sinal');
grid on

% Salvar o sinal filtrado
audiowrite('SinalFiltrado.wav', Y_filt, Fs);

