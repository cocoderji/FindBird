function MEL = getMelSpectrum (W,winShift,s)
[nofChannels,maxFFTIdx] = size(W);
fftLength = maxFFTIdx * 2;
SPEC = getSpectrum(fftLength,winShift,s);
MEL.M = W * SPEC.X;
MEL.e = SPEC.e ;
end