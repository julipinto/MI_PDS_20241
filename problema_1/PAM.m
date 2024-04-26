# input: pkg load signal

Fs = 100 * 100;   #taxa de amostragem para pontos dos sinais
f0 = 10;      #frequencia dos pulos "10 pulsos por segundo"
w = 0.5/10;   #largura do pulsos
t = 0:1/Fs:3; #tempo da simulação
t0 = 0:1/f0:3; #taxa de amostragem dos pulsos
t1= 0:1/1.5:3; #taxa de pulsos sem nyquist


x = sin(2*pi*t);   #gerando sinal senoidal com frequencia igual a frequencia igual 2 * pi
train = pulstran(t, t0, "rectpuls", w); #gerando um trem de pulsos
ntrain = pulstran(t, t1, "rectpuls", w);#geração do trem de pulsos 

pam = x.*train; # modulando o sinal senoidal pelo trem de pulsos
npam = x.*ntrain;#modulação com aliasing

# Calculando a FFT do sinal PAM
N = length(pam); # Número de pontos do sinal
f = (-N/2:N/2-1)/Fs*f0; # Eixo de frequências
pam_fft = fftshift(fft(pam)); # FFT do sinal PAM
npam_fft = fftshift(fft(npam)); #FFT do sinal PAM com aliasing

# FILTRANDO O SINAL
# Projeta um filtro passa-baixas com frequência de corte em 30 Hz
mask = abs(f) < 0.01; # Passa apenas frequências menores que 30 Hz
pam_fft_filtered = pam_fft .* mask;

npam_fft_filtered = npam_fft .* mask; #Filtragem do sinal com aliasing

# Transformando de volta para o domínio do tempo
pam_filtered = ifft(ifftshift(pam_fft_filtered));

#Transformada inversa do sinal com aliasing
npam_filtered = ifft(ifftshift(npam_fft_filtered));

# PLOTS
plt_rows = 3;
plt_cols = 2;


# PLOT SINAL ORIGINAL
subplot(plt_rows, plt_cols, 1),plot(t,x);
xlabel("Tempo (t)");
ylabel("Magnitude");
title("Sinal senoidal");

# PLOT TREM DE PULSOS
subplot(plt_rows, plt_cols, 2),plot(t,train);
xlabel("Tempo (t)");
ylabel("Magnitude");
title("Trem de pulsos");

# PLOT PAM
ylim([min(train) max(train)*1.5]); # Melhora a exibição do eixo y no trem de pulsos
subplot(plt_rows, plt_cols, 3),plot(t, pam);
xlabel("Tempo (t)");
ylabel("Magnitude");
title("PAM");

# PLOT FFT
subplot(plt_rows, plt_cols, 4),plot(f, abs(pam_fft)); # Plotando o módulo da FFT do sinal PAM
axis([-2,2,0,8000]);
xlabel('Frequência (Hz)');
ylabel('Magnitude');
title('FFT do sinal PAM');

subplot(plt_rows, plt_cols, 5),plot(f, abs(pam_fft_filtered));
axis([-2,2,0,8000]);
xlabel('Frequência (Hz)');
ylabel('Magnitude');
title('Frequencias filtradas');

subplot(plt_rows, plt_cols, 6),plot(t, real(pam_filtered));
xlabel('Tempo (t)');
ylabel('Magnitude');
title('Sinal reconstruido');

figure

subplot(plt_rows, plt_cols, 1),plot(t,x);
xlabel("Tempo (t)");
ylabel("Magnitude");
title("Sinal senoidal");

# PLOT TREM DE PULSOS
subplot(plt_rows, plt_cols, 2),plot(t,ntrain);
xlabel("Tempo (t)");
ylabel("Magnitude");
title("Trem de pulsos");

# PLOT PAM
ylim([min(train) max(train)*1.5]); # Melhora a exibição do eixo y no trem de pulsos
subplot(plt_rows, plt_cols, 3),plot(t, npam);
xlabel("Tempo (t)");
ylabel("Magnitude");
title("PAM");

# PLOT FFT
subplot(plt_rows, plt_cols, 4),plot(f, abs(npam_fft)); # Plotando o módulo da FFT do sinal PAM
axis([-2,2,0,8000]);
xlabel('Frequência (Hz)');
ylabel('Magnitude');
title('FFT do sinal PAM');

subplot(plt_rows, plt_cols, 5),plot(f, abs(npam_fft_filtered));
axis([-2,2,0,8000]);
xlabel('Frequência (Hz)');
ylabel('Magnitude');
title('Frequencias filtradas');

subplot(plt_rows, plt_cols, 6),plot(t, real(npam_filtered));
xlabel('Tempo (t)');
ylabel('Magnitude');
title('Sinal reconstruido');
