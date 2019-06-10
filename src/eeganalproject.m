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
load('debate_5_times_defender');
load('debate_5_times_peace_defender');
load('debate_2c1_times');
load('debate_2c1_times_peace');
load('debate_2c2_times');   
load('debate_2c2_times_peace');

% Load inexperienced times
load('debate_8666_times'); % 1
load('debate_8356_times'); % 2
load('debate_8360_times'); % 3
load('debate_8362_times'); % 4
load('debate_8666_times_defender');
load('debate_8362_times_defender');
load('debate_8666_times_peace');
load('debate_8666_times_peace_defender');
load('debate_8360_times_peace');
load('debate_8356_times_peace');
load('debate_8362_times_peace');
load('debate_8362_times_peace_defender');
load('debate_d108c109_times.mat');
load('debate_d108c109_times_defender.mat');
load('debate_d109c108_times.mat');
load('debate_d93c94_times_defender.mat');
load('debate_d93c94l_times.mat');
load('debate_d93c94l_times_peace');
load('debate_d93c94l_times_peace_defender');
% Compute power oscillation of EEG data.
frequency = 'alpha';
name = 2;
[TFRiccleanedB, cfg] = fieldanalfn(alpha, data_iccleanedB);

% Compute freq descriptives of result.
[freqdesc] = ft_freqdescriptives(cfg, TFRiccleanedB);
freqdesc
noTrials = size(data_iccleanedB.trial, 2);
generated_samples = size(freqdesc.powspctrm, 4);
% Initialize placeholder_data
placeholder_data = [];
placeholder_data.anger = zeros(1, noTrials * generated_samples);
placeholder_data.isExp = zeros(1, noTrials * generated_samples);
placeholder_data.id = zeros(1, noTrials * generated_samples);

% Insert values to placeholder_data
if (strcmp(frequency, 'alpha') == 1)
    placeholder_data.isExp(:) = 1;
    placeholder_data.id(:) = name;
    placeholder_data.anger(debate_2_times) = 1;
    placeholder_data.anger(labelAnger(debate_2_times)) = 1;
end


% Store the powscptrm for easy access.
pows = freqdesc.powspctrm;

% Generate generated_samples of all channels and store in 32D vector.
gen_values_array = zeros(32, generated_samples * noTrials);
for index = 1:32
    gen_values_array(index, :) = comp(pows, noTrials, generated_samples, index);
end
% final_data.alphinal = gen_values_array;
if (strcmp(frequency, 'alpha') == 1)
    final_data.isExp = horzcat(final_data.isExp, placeholder_data.isExp);
    final_data.id = horzcat(final_data.id, placeholder_data.isExp);
    final_data.anger = horzcat(final_data.anger, placeholder_data.anger);
end

final_data.alphinal = horzcat(final_data.alphinal, gen_values_array);

% Compute average difference between conditions.
% avg_diff_anger = comp(debate_1_times, FP1, FP1, pows);
% avg_diff_peace = comp(debate_1_times_peace, FP1, FP1, pows);

%avg_vec_power_anger = compsingle(debate_8362_times, FP2, pows);
%avg_vec_power_peace = compsingle(debate_8362_times_peace, FP2, pows);
debate_name = 'debate_2_times_defender';
electro = 'FP1';

% avg_vec_anger = compsingle(debate_8666_times, FP1, pows);
% avg_vec_peace = compsingle(debate_8666_times_peace, FP1, pows);

for index = 1:length(debate_2_times_defender)
    squeezedValuesCh2 = squeeze(pows(debate_2_times_defender(index), FP2,:,:));
    % squeezedValuesCh21 = squeeze(pows(debate_2_times_defender(index), F4, :, :));
    squeezedValuesDe2 = squeeze(pows(debate_2_times_peace_defender(index), FP2,:,:));
    % squeezedValuesDe21 = squeeze(pows(debate_2_times_peace_defender(index), F4,:,:));
    % diffCh = squeezedValuesCh2 - squeezedValuesCh21;
    % diffDe = squeezedValuesDe2 - squeezedValuesDe21;
    squeezedValuesCh = squeezedValuesCh2(:);
    squeezedValuesDe = squeezedValuesDe2(:);
    %resultmachineinput(squeezedValuesCh, squeezedValuesDe, num2str(index), debate_name, frequency, electro);
end

% Mean anger vs mean non-anger
mean_anger = mean(avg_vec_power_anger);
mean_peace = mean(avg_vec_power_peace);

mean_anger 
mean_peace
mean_anger - mean_peace

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
title('FP1: Anger vs Non-Anger');
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
cfg.layout = 'elec1010B.lay';
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
