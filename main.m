[audio, Fs] = audioread("yeah.wav");

complexSpec = createSpec(audio, Fs, 512, 256);