%% A function to read in the EEG data and do some basic preprocessing
%   Preprocessing are done using the fieldtrip ft_preprocessing fuction.
%   see documentation here: http://www.fieldtriptoolbox.org/reference/ft_preprocessing/
%   
%   Description of params:
%   dataset - filename.vhdr
%   prestim - grabbing data before the stim marker
%   poststim - grabbing data after the stim marker
%   eventtype - name of trigger channel. Default 'Stimulus'
%   eventvalue - a cell list of stim marker names, e.g. 'S  4'. Can be
%       found in the .vmrk files.
%   demean - substract the mean. Default 'yes'
%   dftfilter - line noise removal using discrete fourier transformation,
%       Default 'yes'

function [cfg, data] = read_data(dataset, prestim, poststim, eventtype, eventvalue, demean, dftfilter)
% Set default paramters
if ~exist('demean', 'var')
    demean = 'yes';
end
if ~exist('eventtype', 'var')
    eventtype = 'Stimulus';
end
if ~exist('dftfilter', 'var')
    dftfilter = 'yes';
end

% Define trial information
cfg = [];
cfg.dataset = dataset;
cfg.trialdef.prestim    = prestim;
cfg.trialdef.poststim   = poststim;
cfg.trialdef.eventtype  = eventtype;  % name of trigger channel
cfg.trialdef.eventvalue = eventvalue;
cfg.trialfun            = 'ft_trialfun_general'; % default trian generation function
cfg                     = ft_definetrial(cfg); % define the trial information

cfg.dftfreq             = [50 100];
cfg.channel             = [1:63]; 
% cfg.bpfreq              = [0.1 59];
% cfg.reref               = 'yes';  % re-referencing
% cfg.refchannel          = 'all';

cfg.baselinewindow      = [0 0.2];
% preprocess EEG data
cfg.demean              = demean;
cfg.dftfilter           = dftfilter;
data                    = ft_preprocessing(cfg);

end