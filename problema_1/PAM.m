Fs = 10000;   #taxa de amostragem para pontos dos sinais
f0 = 10;      #frequencia dos pulos "10 pulsos por segundo"
w = 0.5/10;   #largura do pulsos
t = 0:1/Fs:3; #tempo da simulação
t0 = 0:1/f0:3; #taxa de amostragem dos pulsos

x = sin(2*pi*t);   #gerando sinal senoidal com frequencia igual a frequencia igual 2 * pi
train = pulstran(t, t0, "rectpuls", w); #gerando um trem de pulsos

pam = x.*train; # modulando o sinal senoidal pelo trem de pulsos

subplot(2,2,1),plot(t,x);
subplot(2,2,2),plot(t,train);
ylim([min(train) max(train)*1.5]);
subplot(2,2,3),plot(t, pam);
