% Passo 1: Obter a imagem .tiff
image_inputed = imread('lenna.tiff');

% Passo 2: Aplicar a Transformada de Fourier
f_transform = fft2(double(image_inputed));

% Passo 3: Deslocar a Transformada de Fourier
f_shift = fftshift(f_transform);

% Passo 4: Remover as frequências elevadas usando um filtro passa-baixa
% Definindo uma máscara para manter apenas as frequências centrais, através de uma matriz binária.
[m, n] = size(image_inputed);  % Matriz do tamanho da imagem
mask = zeros(m, n);            % Zera todos os índices da matriz
radius = 28;                   % Determina o raio do circulo
center = [m/2, n/2];           % Determina o centro da matriz
for i = 1:m
    for j = 1:n
        if sqrt((i-center(1))^2 + (j-center(2))^2) <= radius  % Se a frequência estiver dentro do circulo, é mantida setando os valores
            mask(i,j) = 1;
        end
    end
end

% Aplicar a máscara às frequências
f_masked = f_shift .* mask;

% Passo 5: Desfazer o deslocamento
f_unshift = ifftshift(f_masked);

% Passo 6: Aplicar a Transformada Inversa de Fourier
image_result = ifft2(f_unshift);
image_result = uint8(abs(image_result));

% Passo 7: Visualizar a imagem processada
imshow(image_result);

