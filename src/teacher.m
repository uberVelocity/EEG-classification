% Useful reference functions from assignments.
cfg = [];
cfg.method = 'mtmconvol';
cfg.taper = 'dpss';
cfg.tapsmofrq = 2;
cfg.output = 'pow';
cfg.keeptrials = 'yes';
cfg.foi = [4:50];
cfg.t_ftimwin = ones(length(cfg.foi),1).*0.5;
cfg.toi = -0.5:0.05:1;
TFRhigh = ft_freqanalysis(cfg,hpdat);

cfg = [];
cfg.baseline = [];
cfg.baselinetype = 'absolute';
cfg.showlabels = 'yes';
cfg.showoutline = 'yes';
ft_multiplotTFR(cfg, TFRhigh);