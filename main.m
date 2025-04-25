% 音声ファイルの読み込み
[audio, Fs] = audioread("yeah.wav");

% モノラル化（左チャンネルのみ使用）
if size(audio, 2) == 2
x = audio(:, 1); % ステレオの場合、左チャンネルを抽出
else
x = audio; % モノラルの場合はそのまま使用
end

% 窓関数のパラメータ設定
winLen = 512;
shihtLen = 256;

complexSpec = stft(audio, Fs, winLen, shihtLen);