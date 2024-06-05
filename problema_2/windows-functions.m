function w = rectwin(M)
    w = ones(M, 1);
end

function w = hamming(n, M)
    if M == 1
        w = 1;
    else
        w = 0.54 - 0.46 * cos(2 * pi * n / (M - 1));
    end
end

function w = hanning(n, M)
    if M == 1
        w = 1;
    else
        w = 0.5 * (1 - cos(2 * pi * n / (M - 1)));
    end
end

function w = vonhann(n, M)
    w = hanning(n, M);
end

function w = blackman(n, M)
    if M == 1
        w = 1;
    else
        w = 0.42 - 0.5 * cos(2 * pi * n / (M - 1)) + 0.08 * cos(4 * pi * n / (M - 1));
    end
end

function w = kaiser(n, M, beta)
    if M == 1
        w = 1;
    else
        n = n - (M-1)/2;
        w = besseli(0, beta * sqrt(1 - (2*n/(M-1)).^2)) / besseli(0, beta);
    end
end



