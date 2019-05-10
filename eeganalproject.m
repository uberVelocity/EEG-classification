% Compute power oscillation of EEG data.
cfg = [];
cfg.output = 'pow';
cfg.channel = 'all';
cfg.method = 'mtmconvol';
cfg.taper = 'dpss';
cfg.tapsmofrq = 2;
cfg.foi = 9:13;
cfg.keeptrials = 'yes';
cfg.t_ftimwin = ones(length(cfg.foi),1).*0.5;
cfg.toi = 0:0.05:2;
TFRiccleanedB = ft_freqanalysis(cfg, data_iccleanedB);

% Compute freq descriptives of result.
[freqdesc] = ft_freqdescriptives(cfg, TFRiccleanedB);

% Multiplot freqdesc.
cfg = [];
cfg.baseline = [];
cfg.baselinetype = 'absolute';
cfg.showlabels = 'yes';
cfg.showoutline = 'yes';
cfg.layout = 'elec1010B.lay';
ft_multiplotTFR(cfg, freqdesc);

% Store the powscptrm for easy access.
pows = freqdesc.powspctrm;
fp1 = pows(:,1,:,:);

% Produces a vector filled with the frequencies (,,X,) and times (,,,X).
% This is what you are interested in observing.
peaceTime = 91;
angerTime = 158;
squeezedAnger = squeeze(pows(angerTime,1,:,:));
averageSqueezedAnger = mean(squeezedAnger);
squeezedPeace = squeeze(pows(peaceTime,1,:,:));
averageSqueezedPeace = mean(squeezedPeace);
figure(10);
plot(squeezedAnger);
figure(11);
plot(squeezedPeace);

% Normalize data - FILLS WITH NaN!
cpydata = TFRiccleanedB;
cfg = [];
cfg.baseline = [-0.5 -0.1];
cfg.baselinetype = 'absolute';
cfg.parameter = 'powspctrm';
[TFRiccleanedB] = ft_freqbaseline(cfg, TFRiccleanedB);

% Look at all channels at the same time.
cfg = [];
cfg.baseline = [-0.5 -0.1];
cfg.baselinetype = 'absolute';
cfg.zlim = [-3e-27 3e-27];
cfg.showlabels = 'yes';
cfg.showoutline = 'yes';
cfg.layout = 'easycapM25.mat';
figure;
ft_multiplotTFR(cfg, TFRiccleanedB);

% Look at only one channel from the data.
cfg = [];
cfg. baseline = [-0.5 -0.1];
cfg.baselinetype = 'absolute';
csg.maskstyle = 'saturation';
cfg.channel = 'Fp1_B';
figure;
ft_singleplotTFR(cfg, TFRiccleanedB);
