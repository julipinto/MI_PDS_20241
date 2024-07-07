pkg load image;

% Passo 1: Obter a imagem .tiff
image_inputed = imread('lena.tiff');
gray_img = rgb2gray(image_inputed);
threshold = 115;

Gx = [-1, 0, 1; -2, 0, 2; -1, 0, 1];
Gy = [-1, -2, -1; 0, 0, 0; 1, 2, 1];

imgx = conv2(gray_img, Gx, 'same');
imgy = conv2(gray_img, Gy, 'same');

sobel = sqrt(imgx.^2 + imgy.^2);
sobel = uint8(sobel);

% Exibir a imagem com filtro Sobel aplicado
%figure;
%imshow(sobel);
%title('Imagem com filtro Sobel aplicado');

% Passo 2: Encontrar contornos
[B, L] = bwboundaries(sobel > threshold, 8);

% Passo 3: Supor que o rosto é um dos maiores contornos
stats = regionprops(L, 'Area', 'BoundingBox');

% Filtrar pequenas áreas para descartar ruídos
minArea = 1000; % Ajuste esse valor conforme necessário
stats = stats([stats.Area] > minArea);

% Encontrar o maior contorno (suposição do rosto)
[~, idx] = max([stats.Area]);

% Obter o contorno do rosto
boundary = B{idx};

% Imprimir o valor de bbox
disp('Contorno:');
disp(boundary);

% Desenhar o contorno na imagem original
figure;
imshow(image_inputed);
title('Imagem Original com Contorno do Rosto');
hold on;
fill(boundary(:,2), boundary(:,1), 'r', 'FaceAlpha', 0.3, 'EdgeColor', 'r', 'LineWidth', 2);
hold off;

% Corrigir o erro de criar a máscara
[img_height, img_width] = size(gray_img);
mask = false(img_height, img_width);

% Preencher a máscara com o contorno
for k = 1:length(boundary)
    mask(boundary(k,1), boundary(k,2)) = true;
end

% Dilatar a máscara para cobrir melhor a área do rosto
mask = imdilate(mask, strel('disk', 5));

% Passo 4: Aplicar o efeito de troca de pixels (pixelização) na área do rosto
block_size = 10; % Tamanho do bloco para pixelização

blurredImg = image_inputed;

for i = 1:3
    channel = image_inputed(:,:,i);
    for row = 1:block_size:img_height
        for col = 1:block_size:img_width
            if mask(row, col)  % Verificar se o pixel está dentro da máscara
                % Limites do bloco
                row_end = min(row + block_size - 1, img_height);
                col_end = min(col + block_size - 1, img_width);

                % Valor médio do bloco
                block = channel(row:row_end, col:col_end);
                mean_val = mean(block(:));

                % Substituir o bloco pelo valor médio
                channel(row:row_end, col:col_end) = mean_val;
            end
        end
    end
    blurredImg(:,:,i) = channel;
end

% Exibir a imagem original e a imagem com o rosto pixelizado
figure;
subplot(1, 2, 1); imshow(image_inputed); title('Imagem Original');
subplot(1, 2, 2); imshow(blurredImg); title('Rosto Pixelizado');

