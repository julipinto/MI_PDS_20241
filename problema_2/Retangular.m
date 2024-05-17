% Define the length of the window and the amount of padding
N = 100;
padding = 20;

% Generate the rectangular window
rectangular_window = rectwin(N);

% Add zero-padding to the window
window_with_padding = [zeros(padding, 1); rectangular_window; zeros(padding, 1)];

% Create the indices to start from -padding to N-1
indices = -padding:(N+padding-1);

% Create the figure and plot the rectangular window with impulses
figure;
stem(indices, window_with_padding, 'filled', 'DisplayName', 'Retangular');
xlabel('Amostra');
ylabel('Amplitude');
title('Janelamento Retangular com Zeros Adicionados');
legend show;
grid on;

% Adjust the y-axis limits to improve visualization
ylim([0 1.2]); % Set the maximum y-axis limit slightly greater than 1

