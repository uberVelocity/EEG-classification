function [] = multiplt(freqdesc)
%MULTIPLT Summary of this function goes here
%   Detailed explanation goes here
cfg = [];
cfg.baseline = [];
cfg.baselinetype = 'absolute';
cfg.showlabels = 'yes';
cfg.showoutline = 'yes';
cfg.layout = 'elec1010B.lay';
ft_multiplotTFR(cfg, freqdesc);
end

