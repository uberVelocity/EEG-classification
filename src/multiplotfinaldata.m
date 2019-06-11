cfg = [];
cfg.baseline = [-0.5 -0.1];
cfg.baselinetype = 'absolute';
cfg.zlim = [-3e-27 3e-27];
cfg.showlabels = 'yes';
cfg.showoutline = 'yes';
cfg.layout = 'elec1010B.lay';
figure;
ft_multiplotTFR(cfg, final_data_beginner.alpha_results);