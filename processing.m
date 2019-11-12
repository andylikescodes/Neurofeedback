% tic
% 
% clc;
% 
% clear;
% 
% close all;
% 
%  
% 
% restoredefaultpath    % restore default folder for matlab
% 
%  
% 
% maindir = pwd;        % keep main path
% 
%  
% 
% cd /Users/elnazlashgari/Applications/toolbox/fieldtrip-20190527 % set up the path of fieldtrip
% 
%  
% 
% addpath(pwd)
% 
% ft_defaults
% 
%  
% 
% cd(maindir)    
% 
%  
% 
% %%

cfg = [];

cfg.dataset = 'data\NF103\NF103.vhdr';

 

% define trials based on responses

cfg.trialdef.prestim    = 0;

cfg.trialdef.poststim   = 3.5;

cfg.trialdef.eventtype  = 'Stimulus';  % name of trigger channel

cfg.trialdef.eventvalue = {'S  4', 'S  5', 'S  8', 'S  9'};  % S 3: imagine left;

                                        % S 4: imagine right

% cfg.trialfun            = 'ft_trialfun_general';

cfg                     = ft_definetrial(cfg);

 

% preprocess EEG data

cfg.demean              = 'yes';

cfg.dftfilter           = 'yes';

cfg.dftfreq             = [50 100];

cfg.channel             = [1:63];  

% cfg.reref               = 'yes';  % re-referencing

% cfg.refchannel          = 'all';

all_data                    = ft_preprocessing(cfg);


% % get positive data
% cfg = [];
% 
% cfg.dataset = 'data\NF103\NF103.vhdr';
% 
% 
% % define trials based on responses
% 
% cfg.trialdef.prestim    = 0;
% 
% cfg.trialdef.poststim   = 3.5;
% 
% cfg.trialdef.eventtype  = 'Stimulus';  % name of trigger channel
% 
% cfg.trialdef.eventvalue = {'S  5', 'S  9'};  % S 3: imagine left;
% 
%                                         % S 4: imagine right
% 
% % cfg.trialfun            = 'ft_trialfun_general';
% 
% cfg                     = ft_definetrial(cfg);
% 
%  

% preprocess EEG data
% 
% cfg.demean              = 'yes';
% 
% cfg.dftfilter           = 'yes';
% 
% cfg.dftfreq             = [50 100];
% 
% cfg.channel             = [1:63];  
% 
% cfg.reref               = 'yes';  % re-referencing
% 
% cfg.refchannel          = 'all';
% 
% pos_data                    = ft_preprocessing(cfg);

% % downsample the dataset
% 
%  
% 
% cfg = [];
% 
% cfg.resamplefs = 500;
% 
% cfg.detrend    = 'no';
% 
% data = ft_resampledata(cfg, data);
% 
%  
% 
% %%
% 
% cfg         = [];
% 
% cfg.output  = 'pow';
% 
% cfg.channel = 'C3';
% 
% cfg.method  = 'mtmfft';
% 
% cfg.taper   = 'hanning';
% 
% cfg.foi     = 1:40;
% 
%  
% 
% cfg.trials   = find(data.trialinfo(:,1) == 3);
% 
% spectr_left  = ft_freqanalysis(cfg, data);
% 
%  
% 
% cfg.trials   = find(data.trialinfo(:,1) == 4);
% 
% spectr_right = ft_freqanalysis(cfg, data);
% 
% %%
% 
% figure;
% 
% hold on;
% 
% plot(spectr_left.freq, (spectr_left.powspctrm), 'linewidth', 4)
% 
% plot(spectr_left.freq, (spectr_right.powspctrm), 'linewidth', 4)
% 
% legend('left', 'right')
% 
% xlabel('Frequency (Hz)')
% 
% ylabel('Power (\mu V^2)')
% 
% title('Subject2- channel: C3')
% 
%  
% 
% %%
% 
% cfg         = [];
% 
% cfg.output  = 'pow';
% 
% cfg.channel = 'C4';
% 
% cfg.method  = 'mtmfft';
% 
% cfg.taper   = 'hanning';
% 
% cfg.foi     = 1:40;
% 
%  
% 
% cfg.trials   = find(data.trialinfo(:,1) == 3);
% 
% spectr_left  = ft_freqanalysis(cfg, data);
% 
%  
% 
% cfg.trials   = find(data.trialinfo(:,1) == 4);
% 
% spectr_right = ft_freqanalysis(cfg, data);
% 
%  
% 
% figure;
% 
% hold on;
% 
% plot(spectr_left.freq, (spectr_left.powspctrm), 'linewidth', 4)
% 
% plot(spectr_left.freq, (spectr_right.powspctrm), 'linewidth', 4)
% 
% legend('left', 'right')
% 
% xlabel('Frequency (Hz)')
% 
% ylabel('Power (\mu V^2)')
% 
% title('Subject2- channel: C4')
% 
%  
% 
% %% Time-frequency analysis with a Hanning taper and fixed window length
% 
%  
% 
% cfg            = [];
% 
% cfg.output     = 'pow';
% 
% cfg.channel    = 'all';
% 
% cfg.method     = 'mtmconvol';
% 
% cfg.taper      = 'hanning';
% 
% cfg.toi        = -1 : 0.10 : 4;
% 
% cfg.foi        = 2:2:40;
% 
% cfg.t_ftimwin  = ones(size(cfg.foi)) * 0.5;
% 
%  
% 
% cfg.trials     = find(data.trialinfo(:,1) == 3);
% 
% tfr_left       = ft_freqanalysis(cfg, data);
% 
%  
% 
% cfg.trials     = find(data.trialinfo(:,1) == 4);
% 
% tfr_right      = ft_freqanalysis(cfg, data);
% 
%  
% 
% %%
% 
%  
% 
% cfg              = [];
% 
% cfg.baseline     = [-1 0];
% 
% cfg.baselinetype = 'absolute';
% 
% cfg.xlim         = [2 2.5];  % specified in seconds
% 
% cfg.ylim         = [8 14];    % we only plot the beta band
% 
% cfg.zlim         = 'maxabs';
% 
% cfg.marker       = 'on';
% 
% cfg.colorbar     = 'yes';
% 
% cfg.layout       = 'easycapM25.lay';
% 
%  
% 
% figure;
% 
% ft_topoplotTFR(cfg, tfr_left);
% 
% title('Left');
% 
%  
% 
% figure;
% 
% ft_topoplotTFR(cfg, tfr_right);
% 
% title('Right');
% 
%  
% 
% %%
% 
%  
% 
% cfg              = [];
% 
% cfg.baseline     = [-0.8 -0.2];
% 
% cfg.baselinetype = 'relative';  % we use a relative baseline
% 
% cfg.xlim         = [0.4 0.8];
% 
% cfg.ylim         = [16 24];
% 
% cfg.zlim         = 'maxabs';
% 
% cfg.marker       = 'on';
% 
% cfg.colorbar     = 'yes';
% 
% cfg.layout       = 'easycapM11.lay';
% 
%  
% 
% figure;
% 
% ft_topoplotTFR(cfg, tfr_left);
% 
% title('Left hand reaction');
% 
%  
% 
% figure;
% 
% ft_topoplotTFR(cfg, tfr_right);
% 
% title('Right hand reaction');
% 
% %%
% 
% cfg          = [];
% 
% cfg.colorbar = 'yes';
% 
% % cfg.xlim     = [-1 6];
% 
% cfg.zlim     = 'maxabs';
% 
% cfg.ylim     = [10 Inf];  % plot alpha band upwards
% 
% cfg.layout   = 'easycapM25.lay';
% 
% cfg.channel  = 'C3';
% 
%  
% 
% figure;
% 
% ft_singleplotTFR(cfg, tfr_left);
% 
% title('Left hand reaction');
% 
%  
% 
% cfg          = [];
% 
% cfg.colorbar = 'yes';
% 
% cfg.zlim     = 'maxabs';
% 
% cfg.ylim     = [10 Inf];  % plot alpha band upwards
% 
% cfg.layout   = 'easycapM25.lay';
% 
% cfg.channel  = 'C4';
% 
%  
% 
% figure;
% 
% ft_singleplotTFR(cfg, tfr_right);
% 
% title('Right hand reaction');
% 
%  
% 
% %% Difference
% 
%  
% 
% cfg = [];
% 
% cfg.parameter    = 'powspctrm';
% 
% cfg.operation    = '(x1-x2)/(x1+x2)';
% 
%  
% 
% tfr_difference = ft_math(cfg, tfr_right, tfr_left);
% 
%  
% 
% cfg = [];
% 
% cfg.xlim         = [0.4 0.8];
% 
% cfg.ylim         = [16 24];
% 
% cfg.zlim         = 'maxabs';
% 
% cfg.marker       = 'on';
% 
% cfg.colorbar     = 'yes';
% 
% cfg.layout       = 'easycapM1.lay';
% 
%  
% 
% figure;
% 
% ft_topoplotTFR(cfg, tfr_difference);
% 
% title('Left vs right hand reaction');
% 
% % 
% 
% % 
% 
% %% Morlet
% 
%  
% 
% cfg            = [];
% 
% cfg.output     = 'pow';
% 
% cfg.channel    = 'all';
% 
% cfg.method     = 'wavelet';
% 
% cfg.width      = 7;
% 
% cfg.toi        = -1 : 0.05 : 4;
% 
% cfg.foi        = 1:40;
% 
%  
% 
% cfg.trials     = find(data.trialinfo(:,1) == 3);
% 
% wave_left      = ft_freqanalysis(cfg, data);
% 
%  
% 
% cfg.trials     = find(data.trialinfo(:,1) == 4);
% 
% wave_right     = ft_freqanalysis(cfg, data);
% 
%  
% 
% %%
% 
%  
% 
% cfg            = [];
% 
% cfg.parameter  = 'powspctrm';
% 
% cfg.operation  = '(x1-x2)/(x1+x2)';
% 
%  
% 
% wave_difference = ft_math(cfg, wave_right, wave_left);
% 
%  
% 
% cfg          = [];
% 
% cfg.colorbar = 'yes';
% 
% cfg.zlim     = 'maxabs';
% 
% cfg.layout   = 'easycapM25.lay';
% 
% cfg.channel  = 'EEG126';
% 
%  
% 
% figure;
% 
% ft_singleplotTFR(cfg, wave_difference);
% 
% title('Left vs right hand reaction');
% 
%  
% 
%  
% 
% %%
% 
%  
% 
%  
% 
%  
% 
toc