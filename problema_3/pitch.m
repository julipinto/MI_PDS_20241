% Carregar pacotes
pkg load signal;
pkg load audio;

% Ler arquivo de áudio de entrada
[y, fs] = audioread('voz_original.wav');

% Calcular o vetor de tempo para o áudio original
t = (0:length(y)-1) / fs;

% ------------- Visualização do sinal original -------------
% Plotar o sinal do audio original no tempo
figure;
subplot(2,1,1);
plot(t, y);
title('Sinal Original no Domínio do Tempo');
xlabel('Tempo (s)');
ylabel('Amplitude');

% Calcular e plotar o espectro de frequência do audio original
Y = fft(y);
f = (0:length(Y)/2-1) * fs / length(Y);
subplot(2,1,2);
plot(f, abs(Y(1:length(Y)/2)));
title('Sinal Original no Domínio da Frequência');
xlabel('Frequência (Hz)');
ylabel('Magnitude');

figure;
plot(f, abs(Y(1:length(Y)/2)));
title('Sinal Original no Domínio da Frequência');
xlabel('Frequência (Hz)');
ylabel('Magnitude');


% --------------- Definição de parâmetros ----------------
frame_size = 1024; % Tamanho da janela
hop_size = frame_size / 4; % Tamanho do salto entre janelas
pitch_factor = 1.5; % Fator de mudança de pitch

% Normalizar o sinal de áudio
y = y / max(abs(y));

% Calcula o número de frames (janelas) que serão processados.
num_frames = floor((length(y) - frame_size) / hop_size) + 1;

% Inicializar o sinal de saída
output_length = num_frames * hop_size + frame_size;
output = zeros(output_length, 1);

% Cria uma janela de Hanning para suavizar as bordas de cada frame
window = hanning(frame_size);

for i = 0:num_frames-1
    % Definir o início e fim da janela
    start_idx = i * hop_size + 1;
    end_idx = start_idx + frame_size - 1;

    % Fazer o janelamento de cada frame
    frame = y(start_idx:end_idx) .* window;

    % Aplicar a FFT para obter o espectro
    spectrum = fft(frame);

    % Manipular as frequências (mudança de pitch)
    new_spectrum = zeros(size(spectrum));
    len = length(spectrum);

    for k = 1:len
        new_k = round(k * pitch_factor);
        if new_k <= len
            new_spectrum(new_k) = spectrum(k);
        end
    end

    % Aplicar a IFFT
    new_frame = real(ifft(new_spectrum)) .* window;

    % Adicionar a janela modificada ao sinal de saída
    output(start_idx:end_idx) += new_frame;
end

% Normalizar o sinal de saída
output = output / max(abs(output));

% Calcular o vetor de tempo para o áudio modificado
t_mod = (0:length(output)-1) / fs;

% ------------- Visualização do sinal modificado -------------
% Plotar o sinal do audio de saida no tempo
figure;
subplot(2,1,1);
plot(t_mod, output);
title('Sinal Modificado no Domínio do Tempo');
xlabel('Tempo (s)');
ylabel('Amplitude');

% Calcular e plotar o espectro de frequência do audio de saida
Y_mod = fft(output);
f_mod = (0:length(Y_mod)/2-1) * fs / length(Y_mod);
subplot(2,1,2);
plot(f_mod, abs(Y_mod(1:length(Y_mod)/2)));
title('Sinal Modificado no Domínio da Frequência');
xlabel('Frequência (Hz)');
ylabel('Magnitude');

figure;
plot(f_mod, abs(Y_mod(1:length(Y_mod)/2)));
title('Sinal Modificado no Domínio da Frequência');
xlabel('Frequência (Hz)');
ylabel('Magnitude');

% Salvar o arquivo modificado
audiowrite('voz_modificada_manual.wav', output, fs);

