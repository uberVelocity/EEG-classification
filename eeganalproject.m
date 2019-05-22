%#ok<*NOPTS>
% Import and activate fieldtrip library.
addpath('C:\Users\redth\Documents\University\Bachelor\fieldtrip-20181231');
ft_defaults;
T7 = 12;
T8 = 16;
% Load electrodes, frequency intervals, and debate times.
addpath('C:\Users\redth\Documents\University\Bachelor\git\bachelor-project\data_files');
load('elec_freq');
load('debate_1_times');
load('debate_1_times_defender');
load('debate_1_times_peace');
load('debate_1_times_peace_defender');
load('debate_1b_times_defender');
load('debate_1b_times_peace_defender');
load('debate_2_times');
load('debate_2_times_defender');
load('debate_2_times_peace');
load('debate_2_times_peace_defender');
load('debate_3_times');
load('debate_3_times_defender');
load('debate_3_times_peace');
load('debate_3_times_peace_defender');
load('debate_5_times');
load('debate_5_times_peace');
% Compute power oscillation of EEG data.
[TFRiccleanedA, cfg] = fieldanalfn(alpha, data_iccleanedA);

% Compute freq descriptives of result.
[freqdesc] = ft_freqdescriptives(cfg, TFRiccleanedA);



% Store the powscptrm for easy access.
pows = freqdesc.powspctrm;

% Compute average difference between conditions.
avg_diff_anger = comp(debate_3_times_defender, FP1, FP2, pows);
avg_diff_peace = comp(debate_3_times_peace_defender, FP1, FP2, pows);

% Mean anger vs mean non-anger
mean_anger = mean(avg_diff_anger);
mean_peace = mean(avg_diff_peace);

mean_anger 
mean_peace

% Flips anger and non-anger vectors to plot boxplots.
flippedSqAng = averageSqueezedAnger';
flippedSqPeac = averageSqueezedPeace';

% Compute mean of intersected times of the conditions excluding NaN values
% for statistics.
ang = nanmean(flippedSqAng);
peac = nanmean(flippedSqPeac);
% Group the variables for comparison using boxplots.
group = [ones(size(flippedSqAng)); 2 * ones(size(flippedSqPeac))];

% Plot boxplot for comparison.
figure
boxplot([flippedSqAng; flippedSqPeac],group);
title('F4: Anger vs Non-Anger');
ylabel('Power');
set(gca,'XTickLabel',{'anger','non-anger'});


% Plot the channel, displaying the two conditions.
figure(10);
plot(squeezedAnger);
figure(11);
plot(squeezedPeace);

% Perform t-test for the two conditions.
% h = [1, 0] = [rejects h, ~rejects h].
% p = p-value (significance :=  p <= 0.05).
[h,p] = ttest2(averageSqueezedAnger, averageSqueezedPeace);
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
