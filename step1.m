% 信号の読み込み
[y, Fs] = audioread("yeah.wav");

% 窓関数のパラメータ設定
window_length = 512;
shift_length = 128;

% ハン窓の実装
hann_window = 0.5 * (1 - cos(2*pi*(0:window_length-1)'/(window_length-1)));

% 信号の長さとフレーム数の計算
signal_length = length(x);
num_frames = floor((signal_length - window_length) / shift_length) + 1;
