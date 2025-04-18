% Step1: 音声ファイルの読み込みと窓処理
clear; close all; clc;

% 音声ファイルの読み込み
[audio, Fs] = audioread("yeah.wav");

% モノラル化（左チャンネルのみ使用）
if size(audio, 2) == 2
    x = audio(:, 1);  % ステレオの場合、左チャンネルを抽出
else
    x = audio;        % モノラルの場合はそのまま使用
end

% 窓関数のパラメータ設定
windowLength = 512;
shiftLength = 256;

% FFTのパラメータ設定
nfft = windowLength;

% 信号の先頭にゼロパディングを追加
x = [zeros(windowLength / 2, 1); x];

% ハン窓の実装
hannWindow = 0.5 * (1 - cos(2 * pi * (0:windowLength - 1)' / (windowLength - 1)));

% 信号の長さとフレーム数の計算
signalLength = length(x);
numFrames = floor(signalLength / shiftLength);

% 複素スペクトログラム格納用配列
complexSpectrogram = zeros(nfft, numFrames);

% 信号を短時間フレームに分割
for i = 1:numFrames
    startIdx = (i-1) * shiftLength + 1;
    endIdx = startIdx + windowLength - 1;

    % 窓長を超えないように確認
    if endIdx <= signalLength
        frame = x(startIdx:endIdx);
    else
        % 信号の終わりに達した場合
        frame = [x(startIdx:signalLength); zeros(endIdx - signalLength, 1)];
    end

    % 窓関数を適用
    framedSignal = frame .* hannWindow;

    % 窓かけ済み信号をFFT
    spectrum = fft(framedSignal, nfft, 1);

    % 複素スペクトログラムに格納
    complexSpectrogram(:, i) = spectrum;
end

% パワースペクトログラムの表示
powerSpectrogram = abs(complexSpectrogram).^2;

% dBスケールに変換
powerSpectrogram_dB = 10 * log10(powerSpectrogram + eps); % log(0)回避

% 時間軸と周波数軸の生成
time = (0:numFrames-1) * shiftLength / Fs; % 秒
freq = (0:nfft-1) * Fs / nfft;             % Hz

% プロット
figure;
imagesc(time, freq, powerSpectrogram_dB);
axis xy;
colormap(jet);
colorbar('Label', 'Power (dB)');
xlabel('Time (seconds)');
ylabel('Frequency (Hz)');
title('Power Spectrogram (dB)');
set(gca, 'FontSize', 14);
ylim([0 Fs/2]);