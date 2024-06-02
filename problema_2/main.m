source('janelas.m');

% Define the length of the window and the amount of padding
N = 100;
padding = 20;

% Create the indices to start from -padding to N-1
indices = -padding:(N+padding-1);


% Create the figure and plot the rectangular window with impulses in six subplots
figure;

% First subplot

% Generate the rectangular window
rect = rectangular_window(N);
% Add zero-padding to the window
window_with_padding = [zeros(padding, 1); rect; zeros(padding, 1)];

subplot(3, 2, 1); % 3 rows, 2 columns, first subplot
stem(indices, window_with_padding, 'filled', 'DisplayName', 'Retangular');
xlabel('Amostra');
ylabel('Amplitude');
title('Janelamento Retangular');
grid on;
ylim([0 1.2]); % Set the maximum y-axis limit slightly greater than 1

% Second subplot

% Generate the rectangular window
hamming_window = hamming(N);
% Add zero-padding to the window
window_with_padding = [zeros(padding, 1); hamming_window; zeros(padding, 1)];

subplot(3, 2, 2); % 3 rows, 2 columns, second subplot
stem(indices, window_with_padding, 'filled', 'DisplayName', 'Retangular 2');
xlabel('Amostra');
ylabel('Amplitude');
title('Janelamento de Hamming');
grid on;
ylim([0 1.2]); % Set the maximum y-axis limit slightly greater than 1

% Third subplot

% Generate the rectangular window
hanning_window = hanning(N);
% Add zero-padding to the window
window_with_padding = [zeros(padding, 1); hanning_window; zeros(padding, 1)];

subplot(3, 2, 3); % 3 rows, 2 columns, third subplot
stem(indices, window_with_padding, 'filled', 'DisplayName', 'Retangular 3');
xlabel('Amostra');
ylabel('Amplitude');
title('Janelamento de Hanning');
grid on;
ylim([0 1.2]); % Set the maximum y-axis limit slightly greater than 1

% Fourth subplot

% Generate the rectangular window
vonhann_window = vonhann(N);
% Add zero-padding to the window
window_with_padding = [zeros(padding, 1); vonhann_window; zeros(padding, 1)];

subplot(3, 2, 4); % 3 rows, 2 columns, fourth subplot
stem(indices, window_with_padding, 'filled', 'DisplayName', 'Retangular 4');
xlabel('Amostra');
ylabel('Amplitude');
title('Janelamento de Vonhann');
grid on;
ylim([0 1.2]); % Set the maximum y-axis limit slightly greater than 1

% Fifth subplot

% Generate the rectangular window
blackman_window = blackman(N);
% Add zero-padding to the window
window_with_padding = [zeros(padding, 1); blackman_window; zeros(padding, 1)];

subplot(3, 2, 5); % 3 rows, 2 columns, fifth subplot
stem(indices, window_with_padding, 'filled', 'DisplayName', 'Retangular 5');
xlabel('Amostra');
ylabel('Amplitude');
title('Janelamento de Blackman');
grid on;
ylim([0 1.2]); % Set the maximum y-axis limit slightly greater than 1

% Sixth subplot

% Generate the rectangular window
kaiser_window = kaiser(N, 3);
% Add zero-padding to the window
window_with_padding = [zeros(padding, 1); kaiser_window; zeros(padding, 1)];

subplot(3, 2, 6); % 3 rows, 2 columns, sixth subplot
stem(indices, window_with_padding, 'filled', 'DisplayName', 'Retangular 6');
xlabel('Amostra');
ylabel('Amplitude');
title('Janelamento de Kaiser');
grid on;
ylim([0 1.2]); % Set the maximum y-axis limit slightly greater than 1

