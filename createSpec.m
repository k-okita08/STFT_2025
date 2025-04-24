function complexSpec =  createSpec(audio, Fs, winLen, shiftLen)
    
    % モノラル化（左チャンネルのみ使用）
    if size(audio, 2) == 2
        x = audio(:, 1);  % ステレオの場合、左チャンネルを抽出
    else
        x = audio;        % モノラルの場合はそのまま使用
    end
    
    % FFTのパラメータ設定
    nfft = winLen;
    
    % 信号の先頭にゼロパディングを追加
    x = [zeros(winLen / 2, 1); x];
    
    % ハン窓の実装
    hannWindow = 0.5 * (1 - cos(2 * pi * (0:winLen - 1)' / (winLen - 1)));
    
    % 信号の長さとフレーム数の計算
    sigLen = length(x);
    numFrames = floor(sigLen / shiftLen);
    
    % 複素スペクトログラム格納用配列
    complexSpec = zeros(nfft, numFrames);
    
    powerSpec_dB = zeros(nfft, numFrames);
    
    % 信号を短時間フレームに分割
    for i = 1:numFrames
        startIdx = (i-1) * shiftLen + 1;
        endIdx = startIdx + winLen - 1;
    
        % 窓長を超えないように確認
        if endIdx <= sigLen
            frame = x(startIdx:endIdx);
        else
            % 信号の終わりに達した場合
            frame = [x(startIdx:sigLen); zeros(endIdx - sigLen, 1)];
        end
    
        % 窓関数を適用
        framedsig = frame .* hannWindow;
    
        % 窓かけ済み信号をFFT
        spec = fft(framedsig, nfft, 1);
    
        % 複素スペクトログラムに格納
        complexSpec(:, i) = spec;
    
        % パワースペクトログラム
        powerSpec = abs(spec).^2;
    
        % dBスケールに変換
        powerSpec_dB(:, i) = 10 * log10(powerSpec);
    end
    
    % 時間軸と周波数軸の生成
    time = (0:numFrames-1) * shiftLen / Fs; % 秒
    freq = (0:nfft-1) * Fs / nfft;             % Hz
    
    % --- パワースペクトログラムの描画 ---
    imagesc(time, freq, powerSpec_dB);
    axis xy;
    colormap(jet);
    ylim([0 Fs/2]);
    
    % --- グラフの装飾（ラベル・タイトルなど） ---
    xlabel('Time [s]');
    ylabel('Frequency [Hz]');
    title('Power Spectrogram');
    set(gca, 'FontSize', 14);
    
    % ---カラーバーの追加 ---
    c = colorbar;
    ylabel(c, 'Power [dB]');  % または c.Label.String = 'Power (dB)'
end
