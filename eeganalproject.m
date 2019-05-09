% Compute power oscillation of EEG data.
cfg = [];
cfg.output = 'pow';
cfg.channel = 'all';
cfg.method = 'mtmconvol';
cfg.taper = 'dpss';
cfg.tapsmofrq = 2;
cfg.foi = 9:0.25:13;
cfg.keeptrials = 'yes';
cfg.t_ftimwin = ones(length(cfg.foi),1).*0.5;
cfg.toi = -1:0.05:1;
TFRiccleanedB = ft_freqanalysis(cfg, data_iccleanedB);

% Normalize data - MAY NOT WORK.
cpydata = TFRiccleanedB;
cfg = [];
cfg.baseline = [-0.5 -0.1];
cfg.baselinetype = 'absolute';
cfg.parameter = 'powspctrm';
[TFRiccleanedB] = ft_freqbaseline(cfg, TFRiccleanedB);

% Look at all channels at the same time.
cfg = [];
cfg.baseline = [];
cfg.baselinetype = 'absolute';
cfg.showlabels = 'yes';
cfg.showoutline = 'yes';
cfg.layout = 'easycapM25.mat';
figure;
ft_multiplotTFR(cfg, TFRiccleanedB);

% Look at only one channel from the data.
cfg = [];
cfg. baseline = [-0.5 -0.1];
cfg.baselinetype = 'absolute';
cfg.channel = 'Fp1_B';
figure;
ft_singleplotTFR(cfg, TFRiccleanedB);
