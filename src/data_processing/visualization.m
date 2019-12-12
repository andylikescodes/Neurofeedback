%% Set parameters for first step preprocessing
list = dir('data\NF*');

temp_pos = zeros(6,197,875);
temp_neg = zeros(6,197,875);

for i = 1:length(list)
dataset = fullfile(list(i).folder, list(i).name, join([list(i).name, '.vhdr']));

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

%% Set parameters for wavelet transformation
cfg         = [];
cfg.output  = 'pow';
cfg.channel = {'FT7' , 'FT8' , 'T7', 'T8', 'TP7', 'TP8'};
cfg.method  = 'tfr';
cfg.taper   = 'hanning';
cfg.keeptrials = 'no';
cfg.toi = 'all';

cfg.foilim     = [3 59];

%% Extract the positive trials
cfg.trials   = find((data.trialinfo(:,1) == 4) | (data.trialinfo(:,1) == 8));

freq_pos  = ft_freqanalysis(cfg, data);

temp_pos = temp_pos + freq_pos.powspctrm;

%% Extract negative trials
cfg.trials   = find((data.trialinfo(:,1) == 5) | (data.trialinfo(:,1) == 9));
freq_neg  = ft_freqanalysis(cfg, data);

temp_neg = temp_neg + freq_neg.powspctrm;

end

% Take the average of the freqs
freq_pos.powspctrm = temp_pos./length(list);
freq_neg.powspctrm = temp_neg./length(list);

cfg          = [];
cfg.colorbar = 'yes';
cfg.zlim     = 'maxabs';
cfg.ylim     = [3 Inf];  % plot alpha band upwards
cfg.layout   = 'easycapM25.lay';
cfg.channel  = {'FT7'};
figure;
subplot(2,6,1);
ft_singleplotTFR(cfg, freq_pos);
yline(12.5, 'r');
yline(30, 'r');
yline(32, 'b');
yline(59, 'b');

cfg.channel  = {'FT8'};
subplot(2,6,2);
ft_singleplotTFR(cfg, freq_pos);
yline(12.5, 'r');
yline(30, 'r');
yline(32, 'b');
yline(59, 'b');

cfg.channel  = {'T7'};
subplot(2,6,3);
ft_singleplotTFR(cfg, freq_pos);
yline(12.5, 'r');
yline(30, 'r');
yline(32, 'b');
yline(59, 'b');

cfg.channel  = {'T8'};
subplot(2,6,4);
ft_singleplotTFR(cfg, freq_pos);
yline(12.5, 'r');
yline(30, 'r');
yline(32, 'b');
yline(59, 'b');

cfg.channel  = {'TP7'};
subplot(2,6,5);
ft_singleplotTFR(cfg, freq_pos);
yline(12.5, 'r');
yline(30, 'r');
yline(32, 'b');
yline(59, 'b');

cfg.channel  = {'TP8'};
subplot(2,6,6);
ft_singleplotTFR(cfg, freq_pos);
yline(12.5, 'r');
yline(30, 'r');
yline(32, 'b');
yline(59, 'b');

cfg          = [];
cfg.colorbar = 'yes';
cfg.zlim     = 'maxabs';
cfg.ylim     = [3 Inf];  % plot alpha band upwards
cfg.layout   = 'easycapM25.lay';
cfg.channel  = {'FT7'};

subplot(2,6,7);
ft_singleplotTFR(cfg, freq_neg);
yline(12.5, 'r');
yline(30, 'r');
yline(32, 'b');
yline(59, 'b');

cfg.channel  = {'FT8'};
subplot(2,6,8);
ft_singleplotTFR(cfg, freq_neg);
yline(12.5, 'r');
yline(30, 'r');
yline(32, 'b');
yline(59, 'b');

cfg.channel  = {'T7'};
subplot(2,6,9);
ft_singleplotTFR(cfg, freq_neg);
yline(12.5, 'r');
yline(30, 'r');
yline(32, 'b');
yline(59, 'b');

cfg.channel  = {'T8'};
subplot(2,6,10);
ft_singleplotTFR(cfg, freq_neg);
yline(12.5, 'r');
yline(30, 'r');
yline(32, 'b');
yline(59, 'b');

cfg.channel  = {'TP7'};
subplot(2,6,11);
ft_singleplotTFR(cfg, freq_neg);
yline(12.5, 'r');
yline(30, 'r');
yline(32, 'b');
yline(59, 'b');

cfg.channel  = {'TP8'};
subplot(2,6,12);
ft_singleplotTFR(cfg, freq_neg);
yline(12.5, 'r');
yline(30, 'r');
yline(32, 'b');
yline(59, 'b');