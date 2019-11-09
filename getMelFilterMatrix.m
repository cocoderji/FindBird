function W = getMelFilterMatrix(fs, N, nofChannels)
    df = fs/N; 
    Nmax = N/2; %Nyquist frequency index
    fmax = fs/2; %Nyquist frequency
    melmax = freq2mel(fmax); 

    melinc = melmax / (nofChannels + 1); 

    melcenters = (1:nofChannels) .* melinc;

    fcenters = mel2freq(melcenters);

    indexcenter = round(fcenters ./df);      %FFT indices

    %startfrequency, stopfrequency and bandwidth in indices
    indexstart = [1 , indexcenter(1:nofChannels-1)];
    indexstop = [indexcenter(2:nofChannels),Nmax];


    W = zeros(nofChannels,Nmax);         %compute matrix of triangle-shaped filter coefficients
    for c = 1:nofChannels
        increment = 1.0/(indexcenter(c) - indexstart(c));
        for i = indexstart(c):indexcenter(c)
            W(c,i) = (i - indexstart(c))*increment;
        end
        decrement = 1.0/(indexstop(c) - indexcenter(c));
        for i = indexcenter(c):indexstop(c)
           W(c,i) = 1.0 - ((i - indexcenter(c))*decrement);
        end
    end
    for j = 1:nofChannels
        W(j,:) = W(j,:)/ sum(W(j,:)) ;
    end
end