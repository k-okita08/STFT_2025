%ステップ1: 音声ファイルの読み込みと窓処理
clear; close all;

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

% 信号の先頭にゼロパディングを追加
x = [zeros(shiftLength, 1); x];

% ハン窓の実装
hannWindow = 0.5 * (1 - cos(2 * pi * (0:windowLength - 1)' / (windowLength - 1)));

% 信号の長さとフレーム数の計算
signalLength = length(x);
numFrames = floor((signalLength - windowLength) / shiftLength) + 1;

% 短時間信号を格納する配列を初期化
framedSignal = zeros(windowLength, numFrames);

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
    framedSignal(:, i) = frame .* hannWindow;
end
