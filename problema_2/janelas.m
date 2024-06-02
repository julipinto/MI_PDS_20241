function w = rectangular_window(N)
         w = ones(N, 1);
end

function w = hamming(N)
         if N == 1
                  w = 1;
         else
                  n = (-floor(N/2):ceil(N/2)-1)';
                  w = 0.54 - 0.46 * cos(2 * pi * n / (N - 1));
         end
end

function w = hanning(N)
         if N == 1
                  w = 1;
         else
                  n = (-floor(N/2):ceil(N/2)-1)';
                  w = 0.5 * (1 - cos(2 * pi * n / (N - 1)));
         end
end

function w = vonhann(N)
         w = hanning(N);
end

function w = blackman(N)
         if N == 1
                  w = 1;
         else
                  n = (-floor(N/2):ceil(N/2)-1)';
                  w = 0.42 - 0.5 * cos(2 * pi * n / (N - 1)) + 0.08 * cos(4 * pi * n / (N - 1));
         end
end

function w = kaiser(N, beta)
         if N == 1
                  w = 1;
         else
                  n = (-floor(N/2):ceil(N/2)-1)';
                  w = besseli(0, beta * sqrt(1 - (2*n/(N-1)).^2)) / besseli(0, beta);
         end
end
