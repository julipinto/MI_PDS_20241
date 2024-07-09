# detect_faces.py
import cv2
import numpy as np

# Carregar a imagem
image = cv2.imread('lena.tiff')
gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

# Carregar o classificador Haar para detecção de rostos
face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml')

# Detectar rostos na imagem
faces = face_cascade.detectMultiScale(gray, scaleFactor=1.1, minNeighbors=5, minSize=(30, 30))

# Salvar resultados em um arquivo de texto
np.savetxt('faces.txt', faces, fmt='%d')
