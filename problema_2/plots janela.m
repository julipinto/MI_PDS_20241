function w = rectwin(N)
    w = ones(N, 1);
end

function w = hamming(N)
    if N == 1
        w = 1;
    else
        n = (0:N-1)';
        w = 0.54 - 0.46 * cos(2 * pi * n / (N - 1));
    end
end

function w = hanning(N)
    if N == 1
        w = 1;
    else
        n = (0:N-1)';
        w = 0.5 * (1 - cos(2 * pi * n / (N - 1)));
    end
end

function w = vonhann(N)
    w = hanning(N);
end

function w = blackman(N)
    if N == 1
        w = 1;
    else
        n = (0:N-1)';
        w = 0.42 - 0.5 * cos(2 * pi * n / (N - 1)) + 0.08 * cos(4 * pi * n / (N - 1));
    end
end

function w = kaiser(N, beta)
    if N == 1
        w = 1;
    else
        n = (0:N-1)' - (N-1)/2;
        w = besseli(0, beta * sqrt(1 - (2*n/(N-1)).^2)) / besseli(0, beta);
    end
end


% Comprimento da janela
N = 100;

% Gerando as janelas
rectangular_window = rectwin(N);
hamming_window = hamming(N);
hanning_window = hanning(N);
vonhann_window = vonhann(N);
blackman_window = blackman(N);
% beta = 3 é um valor usado normalmente
kaiser_window = kaiser(N, 3);

% Criando a figura e traçando todas as janelas no grafico
figure;
plot(rectangular_window, 'DisplayName', 'Retangular');
hold on;
plot(hamming_window, 'DisplayName', 'Hamming');
plot(hanning_window, 'DisplayName', 'Hanning');
plot(vonhann_window, 'DisplayName', 'Von Hann');
plot(blackman_window, 'DisplayName', 'Blackman');
plot(kaiser_window, 'DisplayName', 'Kaiser (beta=3)');

% Add labels and legend
xlabel('Amostra');
ylabel('Amplitude');
title('Funções de Janelamento');
legend show;
grid on;
hold off;

