# input: pkg load signal

Fs = 100 * 100;   #taxa de amostragem para pontos dos sinais
f0 = 10;      #frequencia dos pulos "10 pulsos por segundo"
w = 0.5/10;   #largura do pulsos
t = 0:1/Fs:3; #tempo da simulação
t0 = 0:1/f0:3; #taxa de amostragem dos pulsos

x = sin(2*pi*t);   #gerando sinal senoidal com frequencia igual a frequencia igual 2 * pi
train = pulstran(t, t0, "rectpuls", w); #gerando um trem de pulsos

pam = x.*train; # modulando o sinal senoidal pelo trem de pulsos

# Calculando a FFT do sinal PAM
N = length(pam); # Número de pontos do sinal
f = (-N/2:N/2-1)/Fs*f0; # Eixo de frequências
pam_fft = fftshift(fft(pam)); # FFT do sinal PAM

# FILTRANDO O SINAL
# Projeta um filtro passa-baixas com frequência de corte em 30 Hz
mask = abs(f) < 0.01; # Passa apenas frequências menores que 30 Hz
pam_fft_filtered = pam_fft .* mask;

# Transformando de volta para o domínio do tempo
pam_filtered = ifft(ifftshift(pam_fft_filtered));


# PLOTS
plt_rows = 6
plt_cols = 1

# PLOT SINAL ORIGINAL
subplot(plt_rows, plt_cols, 1),plot(t,x);

# PLOT TREM DE PULSOS
subplot(plt_rows, plt_cols, 2),plot(t,train);

# PLOT PAM
ylim([min(train) max(train)*1.5]); # Melhora a exibição do eixo y no trem de pulsos
subplot(plt_rows, plt_cols, 3),plot(t, pam);

# PLOT FFT
subplot(plt_rows, plt_cols, 4),plot(f, abs(pam_fft)); # Plotando o módulo da FFT do sinal PAM
xlabel('Frequência (Hz)');
ylabel('Magnitude');
title('FFT do sinal PAM');

subplot(plt_rows, plt_cols, 5),plot(f, abs(pam_fft_filtered));

subplot(plt_rows, plt_cols, 6),plot(t, real(pam_filtered));

