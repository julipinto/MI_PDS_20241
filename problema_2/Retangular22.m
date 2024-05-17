% Define the length of the window and the amount of padding
N = 100;
padding = 20;

% Generate the rectangular window
rectangular_window = rectwin(N);

% Add zero-padding to the window
window_with_padding = [zeros(padding, 1); rectangular_window; zeros(padding, 1)];

% Create the indices to start from -padding to N-1
indices = -padding:(N+padding-1);

% Create the figure and plot the rectangular window with impulses twice
figure;
stem(indices, window_with_padding, 'filled', 'DisplayName', 'Retangular 1');
hold on; % Hold the plot to add the second plot
stem(indices, window_with_padding, 'filled', 'DisplayName', 'Retangular 2');
xlabel('Amostra');
ylabel('Amplitude');
title('Janelamento Retangular com Zeros Adicionados (Duplicado)');
legend show;
grid on;

% Adjust the y-axis limits to improve visualization
ylim([0 1.2]); % Set the maximum y-axis limit slightly greater than 1
hold off; % Release the plot hold

