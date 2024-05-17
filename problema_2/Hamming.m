
% Plot da janela de Hamming
w = 0.54 - 0.46 * cos(2 * pi * (0:100-1)' / (100 - 1));
plot(w);
title('Janela de Hamming');
xlabel('Amostras');
ylabel('Magnitude');
grid on;
