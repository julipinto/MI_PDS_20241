% Passo 1: Obter a imagem .tiff
image_inputed = imread('lena.tiff');
%image_inputed = imread('juli.jpg');
gray_img = rgb2gray(image_inputed);
threshold = 50;

Gx = [-1, 0, 1; -2, 0, 2; -1, 0, 1];
Gy = [-1, -2, -1; 0, 0, 0; 1, 2, 1];

imgx = conv2(gray_img, Gx, 'same');
imgy = conv2(gray_img, Gy, 'same');

sobel = sqrt(imgx.^2 + imgy.^2);
sobel = uint8(sobel);

% Exibir a imagem com filtro Sobel aplicado
%imshow(sobel);

% Passo 2: Encontrar contornos
[B, L] = bwboundaries(sobel > threshold, 8);

% Passo 3: Supor que o rosto é um dos maiores contornos
stats = regionprops(L, 'Area', 'BoundingBox');

% Filtrar pequenas áreas para descartar ruídos
minArea = 1000; % Ajuste esse valor conforme necessário
stats = stats([stats.Area] > minArea);

% Encontrar o maior contorno (suposição do rosto)
[~, idx] = max([stats.Area]);

% Obter o retângulo delimitador do rosto
bbox = stats(idx).BoundingBox;

% Desenhar o retângulo delimitador na imagem original
figure;
imshow(image_inputed);
title('Imagem Original com Bounding Box');
hold on;
rectangle('Position', bbox, 'EdgeColor', 'r', 'LineWidth', 2);
hold off;

% Corrigir o erro de criar a máscara
size(gray_img)
l = length(gray_img);
img_width = l;
img_height = l;

mask = false(img_height, img_width);

x = round(bbox(1));
y = round(bbox(2));
w = round(bbox(3));
h = round(bbox(4));

% Assegurar que os índices estão dentro dos limites da imagem
x_end = min(x + w, img_width);
y_end = min(y + h, img_height);

% Ajustar índices para garantir que não excedam os limites
x = max(1, x);
y = max(1, y);
x_end = max(1, x_end);
y_end = max(1, y_end);

mask(y:y_end, x:x_end) = true;

% Passo 4: Aplicar o efeito de troca de pixels (pixelização) na área do rosto
block_size = 5; % Tamanho do bloco para pixelização

blurredImg = image_inputed;

for i = 1:3
    channel = image_inputed(:,:,i);
    for row = y:block_size:y_end
        for col = x:block_size:x_end
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
    blurredImg(:,:,i) = channel;
end

% Exibir a imagem original e a imagem com o rosto pixelizado
figure;
subplot(1, 2, 1); imshow(image_inputed); title('Imagem Original');
subplot(1, 2, 2); imshow(blurredImg); title('Rosto Pixelizado');

