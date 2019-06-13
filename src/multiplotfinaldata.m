addpath('C:\Users\redth\Documents\University\Bachelor\git\bachelor-project');
cfg = [];
cfg.baseline = [];
cfg.baselinetype = 'absolute';
cfg.showlabels = 'yes';
cfg.showoutline = 'yes';
cfg.layout = 'elec1010B.lay';
ft_multiplotTFR(cfg, freqdesc_beta);
