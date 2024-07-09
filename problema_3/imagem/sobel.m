pkg load image

% Carregar a imagem
image_inputed = imread('lena.tiff');
[x, map] = rgb2ind(image_inputed);
gray_img = rgb2gray(image_inputed);
threshold = 115;

% Detecção de bordas com Sobel
Gx = [-1, 0, 1; -2, 0, 2; -1, 0, 1];
Gy = [-1, -2, -1; 0, 0, 0; 1, 2, 1];

imgx = conv2(double(gray_img), Gx, 'same');
imgy = conv2(double(gray_img), Gy, 'same');

sobel = sqrt(imgx.^2 + imgy.^2);
sobel = uint8(sobel);

% Binarizar a imagem
binary_sobel = sobel > threshold;

figure;
imshow(binary_sobel);

% Encontrar contornos
[B, L] = bwboundaries(binary_sobel, 8);

% Calcular áreas dos contornos e ordenar
areas = cellfun(@(x) polyarea(x(:, 2), x(:, 1)), B);
[~, idx] = sort(areas, 'descend');

% Selecionar os 6 maiores contornos
num_contours = min(6, length(B));
largest_contours = B(idx(1:num_contours));

% Exibir cada contorno em subplots diferentes e imprimir coordenadas iniciais e finais
figure;
for k = 1:num_contours
    subplot(2, 3, k); % Ajuste para uma grade de 2x3
    imshow(image_inputed);
    hold on;
    boundary = largest_contours{k};
    plot(boundary(:, 2), boundary(:, 1), 'r', 'LineWidth', 2);
    hold off;
    title(sprintf('Contorno %d', k));

    % Imprimir as coordenadas iniciais e finais do contorno
    printf('Contorno %d: \n', k);
    printf('Coordenadas - X: %d, Y: %d\n', boundary(1, 2), boundary(1, 1));
end


