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
window_length = 512;
shift_length = 256;

% ハン窓の実装
hann_window = 0.5 * (1 - cos(2*pi*(0:window_length-1)'/(window_length-1)));

% 信号の長さとフレーム数の計算
signal_length = length(x);
num_frames = floor((signal_length - window_length) / shift_length) + 1;

% 短時間信号を格納する配列を初期化
framed_signal = zeros(window_length, num_frames);

% 信号を短時間フレームに分割
for i = 1:num_frames
    start_idx = (i-1) * shift_length + 1;
    end_idx = start_idx + window_length - 1;

    % 窓長を超えないように確認
    if end_idx <= signal_length
        frame = x(start_idx:end_idx);
    else
        % 信号の終わりに達した場合
        frame = [x(start_idx:signal_length); zeros(end_idx - signal_length, 1)];
    end

    % 窓関数を適用
    framed_signal(:, i) = frame(:) .* hann_window;
end
