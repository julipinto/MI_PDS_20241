pkg load image

% Carregar a imagem original
image_inputed = imread('lena.tiff');
gray_img = rgb2gray(image_inputed);

% Carregar resultados da detecção do rosto
faces = load('faces.txt');

% Exibir a imagem com o rosto detectado
figure;
imshow(image_inputed);
hold on;

% Expandir tamanho da região pixelizada
expancao = 0;

% Cordenadas da identificação do rosto
x = faces(1, 1) - expancao;
y = faces(1, 2) - expancao;
width = faces(1, 3) + expancao;
height = faces(1, 4) + expancao;

% Desenhar retângulos ao redor dos rostos detectados
rectangle('Position', [x, y, width, height], 'EdgeColor', 'r','LineWidth', 2);
hold off;
title('Rosto detectado');

% ============================================================================

% Passo 2: Aplicar o efeito de troca de pixels (pixelização) na área do rosto
block_size = 10; % Tamanho do bloco para pixelização


blurredImg = image_inputed;

x_end = min(x + width - 1, size(gray_img, 2));
y_end = min(y + height - 1, size(gray_img, 1));

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
subplot(1, 2, 1); imshow(image_inputed);
title('Imagem original');
subplot(1, 2, 2); imshow(blurredImg);
title('Rosto pixelado');

figure;
imshow(blurredImg);
title('Rosto pixelado');



