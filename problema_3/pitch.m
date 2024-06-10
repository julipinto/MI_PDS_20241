pkg load signal;
pkg load audio;

% Carregar arquivo de áudio
[y, fs] = audioread('voz_original.wav');

% Definir parâmetros
frame_size = 1024; % Tamanho da janela
hop_size = frame_size / 4; % Tamanho do salto entre janelas
pitch_factor = 1.5; % Fator de mudança de pitch

% Normalizar o sinal de áudio
y = y / max(abs(y));

% Número de frames
num_frames = floor((length(y) - frame_size) / hop_size) + 1;

% Inicializar o sinal de saída
output_length = num_frames * hop_size + frame_size;
output = zeros(output_length, 1);

% Janelas de Hanning
window = hanning(frame_size);

for i = 0:num_frames-1
    % Definir o início e fim da janela
    start_idx = i * hop_size + 1;
    end_idx = start_idx + frame_size - 1;

    % Extrair a janela
    frame = y(start_idx:end_idx) .* window;

    % Aplicar a FFT
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

% Salvar o arquivo modificado
audiowrite('voz_modificada_manual.wav', output, fs);

