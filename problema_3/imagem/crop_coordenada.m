% Passo 1: Obter a imagem
image_inputed = imread('lena.tiff');
gray_img = rgb2gray(image_inputed);

% Definir manualmente a região do rosto com base na observação
% Estes valores são ajustados manualmente para esta imagem específica
x_center = 315;  % Coordenada x central
y_center = 272;  % Coordenada y central
half_width = 100; % Metade da largura do retângulo delimitador
half_height = 100; % Metade da altura do retângulo delimitador

% Calcular os limites do bounding box
x = x_center - half_width;
y = y_center - half_height;
w = 2 * half_width;
h = 2 * half_height;

bbox = [x, y, w, h];

% Desenhar o retângulo delimitador na imagem original
figure;
imshow(image_inputed);
title('Imagem original com área identificada');
hold on;
rectangle('Position', bbox, 'EdgeColor', 'r', 'LineWidth', 2);
hold off;

% Passo 2: Aplicar o efeito de troca de pixels (pixelização) na área do rosto
block_size = 10; % Tamanho do bloco para pixelização

blurredImg = image_inputed;

x_end = min(x + w - 1, size(gray_img, 2));
y_end = min(y + h - 1, size(gray_img, 1));

% Ajustar índices para garantir que não excedam os limites
x = max(1, x);
y = max(1, y);

for channel = 1:3
    for row = y:block_size:y_end
        for col = x:block_size:x_end
            % Limites do bloco
            row_end = min(row + block_size - 1, size(gray_img, 1));
            col_end = min(col + block_size - 1, size(gray_img, 2));

            % Valor médio do bloco
            block = blurredImg(row:row_end, col:col_end, channel);
            mean_val = mean(block(:));

            % Substituir o bloco pelo valor médio
            blurredImg(row:row_end, col:col_end, channel) = mean_val;
        end
    end
end

% Exibir a imagem original e a imagem com o rosto pixelizado
figure;
subplot(1, 2, 1); imshow(image_inputed); title('Imagem original');
subplot(1, 2, 2); imshow(blurredImg); title('Rosto pixelado');

figure;
imshow(blurredImg);
title('Rosto pixelado');


