%% Set parameters for first step preprocessing
dataset = 'data\NF103\NF103.vhdr';
subject_id = split(dataset, '\');

[freq_pos_beta_gamma, freq_neg_beta_gamma] = feature_extraction(dataset);

save(fullfile(subject_id{1}, subject_id{2}, join([subject_id{2}, '_pos_beta_gamma.mat'])), 'freq_pos_beta_gamma');
save(fullfile(subject_id{1}, subject_id{2}, join([subject_id{2}, '_neg_beta_gamma.mat'])), 'freq_neg_beta_gamma');

function [freq_pos_beta_gamma, freq_neg_beta_gamma] = feature_extraction(dataset)

prestim    = 0;
poststim   = 3.5;
eventtype  = 'Stimulus';
eventvalue = {'S  4', 'S  5', 'S  8', 'S  9'}; 
demean              = 'yes';
dftfilter           = 'yes';

[cfg, data] = read_data(dataset, prestim, poststim, eventtype, eventvalue, demean, dftfilter);

%% Reample the data at 250Hz
cfg.resamplefs = 250;
[data] = ft_resampledata(cfg, data);

%% Wavelet transformation to extract frequency features, and save the script for machine learning
channels = {'FT7' , 'FT8' , 'T7', 'T8', 'TP7', 'TP8'};
trialmarker = [4, 8];
foilim = [12.5 59];
[freq_pos] = wavelet_transform(data, channels, trialmarker, foilim);
trialmarker = [5, 9];
[freq_neg] = wavelet_transform(data, channels, trialmarker, foilim);

% Set the NAs to 0
freq_neg.powspctrm(isnan(freq_neg.powspctrm)) = 0;
freq_pos.powspctrm(isnan(freq_pos.powspctrm)) = 0;

% Sum up the powspectrum frequency bands
freq_pos_beta = sum(sum(freq_pos.powspctrm(:, :, find(freq_pos.freq<=30), :), 4), 3); % lower than 30Hz
freq_pos_gamma = sum(sum(freq_pos.powspctrm(:, :, find(freq_pos.freq>=32), :), 4), 3); % greater than 32Hz (32-59Hz)
freq_pos_beta_gamma = [freq_pos_beta freq_pos_gamma];

freq_neg_beta = sum(sum(freq_neg.powspctrm(:, :, find(freq_neg.freq<=30), :), 4), 3); % lower than 30Hz
freq_neg_gamma = sum(sum(freq_neg.powspctrm(:, :, find(freq_neg.freq>=32), :), 4), 3); % greater than 32Hz (32-59Hz)
freq_neg_beta_gamma = [freq_neg_beta freq_neg_gamma];

end


