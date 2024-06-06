function w = rectwin(M)
    w = ones(M, 1);
end

function w = hamming(M)
    if M == 1
        w = 1;
    else
        n = (0:M-1)';
        w = 0.54 - 0.46 * cos(2 * pi * n / (M - 1));
    end
end

function w = hanning(M)
    if M == 1
        w = 1;
    else
        n = (0:M-1)';
        w = 0.5 * (1 - cos(2 * pi * n / (M - 1)));
    end
end

function w = vonhann(M)
    w = hanning(M);
end

function w = blackman(M)
    if M == 1
        w = 1;
    else
        n = (0:M-1)';
        w = 0.42 - 0.5 * cos(2 * pi * n / (M - 1)) + 0.08 * cos(4 * pi * n / (M - 1));
    end
end

function w = kaiser(M, beta)
    if M == 1
        w = 1;
    else
        n = (0:M-1)' - (M-1)/2;
        w = besseli(0, beta * sqrt(1 - (2*n/(M-1)).^2)) / besseli(0, beta);
    end
end


