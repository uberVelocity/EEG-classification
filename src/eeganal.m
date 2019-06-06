% Compute oscillatory power of all channels.
% ft_freqanalysis.mat

cfg = [];
cfg.output = 'pow';
cfg.channel = 'all';
cfg.method = 'mtmconvol';
cfg.taper = 'hanning';
cfg.foi = 2:2:30;
cfg.t_ftimwin = ones(length(cfg.foi),1).*0.5;
cfg.toi = -1:0.05:1;
TFRhann_visc = ft_freqanalysis(cfg, data_visc);

% Plot data using time-frequecy plots of all channels.
cfg = [];
cfg.baseline = [-0.5 -0.3];
cfg.baselinetype = 'absolute';
cfg.showlabels = 'yes';
cfg.layout = 'easycapM10.mat';
figure;
ft_multiplotTFR(cfg, TFRhann_visc);

