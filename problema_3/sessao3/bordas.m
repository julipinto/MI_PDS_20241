% Leitura da imagem
imagem = imread('image.jpg');
imagem_gray = rgb2gray(imagem);

% Aplicação do detector de bordas Canny
bordas = edge(imagem_gray, 'Sobel');

% Plotando a imagem original e a imagem com bordas detectadas
subplot(1,2,1);
imshow(imagem_gray);
title('Imagem Original');

subplot(1,2,2);
imshow(bordas);
title('Detecção de Bordas com Sobel');

