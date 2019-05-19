function [tfr, cfg] = fieldanalfn(freq, data)
%FIELDANALFN Computes oscillatory power of data given a wavelength.
cfg = [];
cfg.output = 'pow';
cfg.channel = 'all';
cfg.method = 'mtmconvol';
cfg.taper = 'dpss';
cfg.tapsmofrq = 2;
cfg.foi = freq;
cfg.keeptrials = 'yes';
cfg.t_ftimwin = ones(length(cfg.foi),1).*0.5;
cfg.toi = 0:0.05:2;
tfr = ft_freqanalysis(cfg, data);
end

