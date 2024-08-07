close all;
clc;

source("windows.m");

% Fazendo a importação do audio
% Y: Amplitudes de cada amostra de audio
% Fs: Frequencia de amostragem do audio
[Y, Fs] = audioread('SinalRuidoso.wav');

tInicial = 0;
% Obtendo o segundo final do audio importado
tFinal = (numel(Y)-1)/Fs;

% Periodo de amostragem
periodo = 1/Fs;

% Coordenada x correspondente ao tempo do audio
t = tInicial:periodo:tFinal;

% Plotando o sinal do audio no domi­nio do tempo
figure(1);
plot(t,Y);
title('Sinal Ruidoso');
xlabel('Tempo (s)');
ylabel('Amplitude do sinal');
grid on

% FFT do sinal de audio;
N = length(Y);
k = 0:N-1;
% Quantidade de periodos
T = N/Fs;
freq = k/T;
Y_fft = fft(Y)/N;
cutOff = ceil(N/2);
Y_fft = Y_fft(1:cutOff);

% Plotando o sinal do audio no domi­nio da frequencia
figure(2);
plot(freq(1:cutOff),abs(Y_fft));
title('Sinal Ruidoso (FFT)');
xlabel('Frequência (Hz)');
ylabel('Amplitude do sinal');
grid on

% ==============================================
% Parametros do filtro:

% Faixa de passagem do filtro 0 -> X (Hz)
Fp = 2700;
% Frequencia de rejeição do filtro (Hz)
Fr = 3100;
% Largura de transição do filtro
Lt = Fr - Fp;

% ==============================================
% Construção do filtro

% Transformando frequencias para discretas
Wp = 2 * pi * Fp / Fs;
Wr = 2 * pi * Fr / Fs;
Wt = 2 * pi * Lt / Fs;

Wc = (Wp + Wr) / 2;

% ==========================================
% Escolher o tipo da janela:
% Pode ser
window_tipo = 'blackman';

switch window_tipo
    case 'rectwin'
        windowConstant = 0.9;
    case 'hamming'
        windowConstant = 3.3;
    case 'hanning'
        windowConstant = 3.1;
    case 'blackman'
        windowConstant = 5.5;
    case 'kaiser'
        windowConstant = 5.71;
    otherwise
        error('Tipo de janela não reconhecida.');
end

% Calcular o tamanho da janela
% M: Tamanho da janela
M = round(windowConstant / (Wt / (2 * pi)));

% Garantir que M seja ímpar
if mod(M,2) == 0
  M = M + 1;
end

% Definindo a janela a ser utilizada
switch window_tipo
    case 'rectwin'
        window = rectwin(M);
    case 'hamming'
        window = hamming(M);
    case 'hanning'
        window = hanning(M);
    case 'blackman'
        window = blackman(M);
    case 'kaiser'
        window = kaiser(M, 8.96);
    otherwise
        error('Tipo de janela não reconhecida.');
end

% Escolher o tipo de filtro:
% Pode ser 'passa-baixa', 'passa-alta' ou 'passa-faixa'
filtro_tipo = 'passa-baixa';

n = (-(M-1)/2:(M-1)/2)';
switch filtro_tipo
    case 'passa-baixa'
        h = sin(Wc * n) ./ (pi * n);
        % Corrigir divisão por zero
        h((M-1)/2 + 1) = Wc / pi;
    case 'passa-alta'
        h = -sin(Wc * n) ./ (pi * n);
        % Corrigir divisão por zero e adicionar impulso unitário
        h((M-1)/2 + 1) = 1 - Wc / pi;
    case 'passa-faixa'
        h = (sin(Wr * n) - sin(Wp * n)) ./ (pi * n);
        % Corrigir divisão por zero
        h((M-1)/2 + 1) = (Wr - Wp) / pi;
    otherwise
        error('Tipo de filtro não reconhecido.');
end

figure(3);
plot(window);
title('Janela');
xlabel('Amostras');
ylabel('Magnitude');
grid on;

% Calculando e plotando o espectro da janela
N_window = 1024; % Número de pontos para FFT
window_fft = fft(window, N_window);
window_fft = window_fft(1:N_window/2+1);
freq_window = linspace(0, pi, N_window/2+1);
window_fft_db = 20*log10(abs(window_fft) / max(abs(window_fft)));

figure(4);
plot(freq_window/pi, window_fft_db);
title('Espectro da Janela');
xlabel('\omega / \pi');
ylabel('Magnitude (dB)');
grid on;

% Aplicar o janelamento
h = h .* window;

% Plota a função de transferência do filtro escolhido
figure(5);
plot(n, h);
xlabel('Amostra');
ylabel('Amplitude');
tittle3 = strcat('Filtro: ',filtro_tipo);
title(tittle3);
grid on;

% Normalizar a função de transferência do filtro
h = h / sum(h);

% Aplicar a convolução da função de transferência com o sinal de audio
Y_filt = conv(Y, h, 'same');

% Plotar o sinal filtrado no domínio do tempo
figure(6);
plot(t, Y_filt);
title('Sinal Filtrado');
xlabel('Tempo (s)');
ylabel('Amplitude do sinal');
grid on

% FFT do sinal filtrado
X_filt = fftn(Y_filt) / N;
X_filt = X_filt(1:cutOff);

figure(7);
plot(freq(1:cutOff), abs(X_filt));
title('Sinal Filtrado (FFT)');
xlabel('Frequência (Hz)');
ylabel('Amplitude do sinal');
grid on

sinalName = strcat('SinalFiltrado-', window_tipo, '.wav');
% Salvar o sinal filtrado
audiowrite(sinalName, Y_filt, Fs);

% ==============================================
% Plotagem do diagrama de tolerâncias
% ==============================================

% Resposta em frequência do filtro (Hz)
[Hf, f] = freqz(h, 1, 1024, Fs);

% Plota a função de transferência do filtro em frequência (Rad/s)
[Ho, omega] = freqz(h, 1, 1024);

figure(8);
plot(omega, abs(Ho));
xlabel('Frequência (Rad/s)');
ylabel('Magnitude');
title(['Resposta em Frequência do Filtro: ', filtro_tipo]);
grid on;

% Plotar a resposta em frequência do filtro
figure(9);
plot(f, 20*log10(abs(Hf)));
title('Resposta em Frequência do Filtro');
xlabel('Frequência (Hz)');
ylabel('Magnitude (dB)');
grid on;
hold on;

% Plotar o diagrama de tolerâncias
plot([0, Fp], [-3, -3], 'r--'); % Passband edge
plot([Fr, Fr], [-100, 0], 'g--'); % Stopband edge
plot([Fp, Fp], [-100, 0], 'g--'); % Passband edge
plot([Fp Fr], [-40, -40], 'r--'); % Stopband level
legend('Resposta em Frequência', 'Faixa de Passagem', 'Faixa de Rejeição', 'Location', 'Best');
hold off;
