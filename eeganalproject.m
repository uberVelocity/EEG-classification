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

% Stores every value of FP1 electrode.
fp1 = pows(:,1,:,:);


% Produces a vector filled with the frequencies (,,X,) and times (,,,X).
% This is what you are interested in observing.
peaceTime = 91;
angerTime = 158;

% Reduces 1-sized dimension to convert matrix from 4D to 2D.
squeezedAnger = squeeze(pows(angerTime,1,:,:));
squeezedPeace = squeeze(pows(peaceTime,1,:,:));

% Compute average of the 
averageSqueezedAnger = mean(squeezedAnger);
averageSqueezedPeace = mean(squeezedPeace);

cnt = sum(averageSqueezedAnger > averageSqueezedPeace);

% Compute mean of intersected times of the conditions excluding NaN values
% for statistics.
ang = nanmean(averageSqueezedAnger);
peac = nanmean(averageSqueezedPeace);

% Plot the channel, displaying the two conditions.
figure(10);
plot(squeezedAnger);
figure(11);
plot(squeezedPeace);

% Use other variables to store the same information in squeezeAnger and
% squeezePeace.
angfp1 = squeeze(pows(angerTime, 1, :, :));
peacfp1 = squeeze(pows(peaceTime, 1, :, :));

% Take only the first frequency of the conditions. (9Hz in our case).
angfp1_1 = squeeze(angfp1(1,:))';
peacfp1_1 = squeeze(peacfp1(1,:))';

% Group the variables for comparison using boxplots.
group = [ones(size(angfp1_1)); 2 * ones(size(peacfp1_1))];

% Plot boxplot for comparison.
figure
boxplot([angfp1_1; peacfp1_1],group);
set(gca,'XTickLabel',{'angfp1','peacfp1'});

% Perform t-test for the two conditions.
% h = [1, 0] = [rejects h, ~rejects h].
% p = p-value (significance :=  p <= 0.05).
[h,p] = ttest2(angfp1_1, peacfp1_1);
sprintf("h = %d", h)
if p <= 0.05
    sprintf("p = %.3f * ", p)
else
    sprintf("p = %.3f", p)
end

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
