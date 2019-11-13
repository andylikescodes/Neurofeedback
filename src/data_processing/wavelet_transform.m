%% channels to specify the channels

function [freq_pos] = wavelet_transform(data, channels, trialmarker, foilim)
if ~exist('foilim', 'var')
    foilim = [3, 59];
end
cfg         = [];
cfg.output  = 'pow';
cfg.channel = channels;
cfg.method  = 'tfr';
cfg.taper   = 'hanning';
cfg.keeptrials = 'yes';
cfg.toi = 'all';
cfg.foilim     = foilim;
if length(trialmarker) < 2
    cfg.trials   = find((data.trialinfo(:,1) == trialmarker(1)));
else
    cfg.trials   = find((data.trialinfo(:,1) == trialmarker(1)) | (data.trialinfo(:,1) == trialmarker(2)));
end
freq_pos  = ft_freqanalysis(cfg, data);
end