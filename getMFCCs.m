function mffcs = getMFCCs(rawSample)
fs=44100;
fftL=256;
wl=30;
noC=13;
sample.data = rawSample;
sample.length = length(rawSample);
sample.fs = fs;
sample.N=fftL;
sample.shift = wl*sample.fs/1000;   %time shift is 10ms
sample.channels = noC;

sample.W = getMelFilterMatrix(sample.fs,sample.N,sample.channels);
sample.MEL = getMelSpectrum(sample.W,sample.shift,sample.data);
sample.nofFrames = size(sample.MEL.M,2);
sample.nofMelChannels = size(sample.MEL.M,1);
epsilon = 10e-5;
for k = 1:sample.nofFrames
    for c = 1:sample.nofMelChannels
        sample.MEL.M(c,k) = loglimit(sample.MEL.M(c,k),epsilon);        
    end
end

mffcs = sample.MEL.M(2:end,:);
end