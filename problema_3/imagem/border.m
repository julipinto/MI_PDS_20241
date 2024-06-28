% Passo 1: Obter a imagem .tiff
image_inputed = imread('lena.tiff');
[x, map] = rgb2ind(image_inputed);
gray_img = rgb2gray(image_inputed);
threshold = 115;

Gx = [-1, 0,1 ; -2, 0, 2; -1, 0, 1];
Gy = [-1, -2, -1; 0, 0, 0; 1, 2, 1];

imgx = conv2(gray_img, Gx, 'same');
imgy = conv2(gray_img, Gy, 'same');

sobel = sqrt(imgx.^2 + imgy.^2);
sobel = uint8(sobel);
#sobel = sobel > threshold;

croped_image = double(sobel).*gray_img;

imshow(sobel);

