% The script computes the average oscillatory power of a channel and stores
% it. A t-test between channels + boxplots are created using the
% resultmachineinput.m function at the end of this file.

%#ok<*NOPTS>
% Import and activate fieldtrip library.
addpath('C:\Users\redth\Documents\University\Bachelor\fieldtrip-20181231');
ft_defaults;
T7 = 12;
T8 = 16;
% Load electrodes, frequency intervals, and debate times.
addpath('C:\Users\redth\Documents\University\Bachelor\git\bachelor-project\data_files\debate_times\');
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
% Set up init variables
frequency = 'alpha';

% Compute power oscillation of EEG data.
[TFRiccleanedB_alpha, cfg] = fieldanalfn(alpha, data_iccleanedB); 
[freqdesc_alpha_exp] = ft_freqdescriptives(cfg, TFRiccleanedB_alpha);

[TFRiccleanedB_beta, cfg] = fieldanalfn(beta, data_iccleanedB); 
[freqdesc_beta_exp] = ft_freqdescriptives(cfg, TFRiccleanedB_beta);

[TFRiccleanedB_theta, cfg] = fieldanalfn(theta, data_iccleanedB);
[freqdesc_theta_exp] = ft_freqdescriptives(cfg, TFRiccleanedB_theta);

% Compute freq descriptives of result.
noTrials = size(data_iccleanedB.trial, 2);
generated_samples = size(freqdesc_alpha.powspctrm, 4);

% Initialize placeholder_data
placeholder_data = [];
placeholder_data.anger = zeros(1, noTrials * generated_samples);
placeholder_data.isExp = zeros(1, noTrials * generated_samples);
placeholder_data.id = zeros(1, noTrials * generated_samples);

% Insert values to placeholder_data
name = 3; %%%%%%
placeholder_data.isExp(:) = 0; %%%%%%
placeholder_data.id(:) = name;
placeholder_data.anger(labelAnger(debate_3_times)) = 1; %%%%%%%

% Store the powscptrm for easy access.
pows_alpha = freqdesc_alpha.powspctrm;
pows_beta = freqdesc_beta.powspctrm;
pows_theta = freqdesc_theta.powspctrm;

% Generate generated_samples of all channels and store in 32D vector.
gen_values_array_alpha = zeros(32, generated_samples * noTrials);
gen_values_array_beta = zeros(32, generated_samples * noTrials);
gen_values_array_theta = zeros(32, generated_samples * noTrials);
for index = 1:32
    gen_values_array_alpha(index, :) = comp(pows_alpha, noTrials, generated_samples, index);
    gen_values_array_beta(index, :) = comp(pows_beta, noTrials, generated_samples, index);
    gen_values_array_theta(index, :) = comp(pows_theta, noTrials, generated_samples, index);
end

% Concatenate to final_data id, isExp, and anger levels.
%final_data.isExp = horzcat(final_data.isExp, placeholder_data.isExp);
%final_data.id = horzcat(final_data.id, placeholder_data.id);
%final_data.anger = horzcat(final_data.anger, placeholder_data.anger);

% Concatenate to final_data alpha, beta, and theta results.
%final_data.alpha_results = horzcat(final_data.alpha_results, gen_values_array_alpha);
%final_data.beta_results = horzcat(final_data.beta_results, gen_values_array_beta);
%final_data.theta_results = horzcat(final_data.theta_results, gen_values_array_theta);

% Compute average difference between conditions.
% avg_diff_anger = comp(debate_1_times, FP1, FP1, pows);
% avg_diff_peace = comp(debate_1_times_peace, FP1, FP1, pows);

%avg_vec_power_anger = compsingle(debate_8362_times, FP2, pows);
%avg_vec_power_peace = compsingle(debate_8362_times_peace, FP2, pows);
debate_name = 'debate_2_times_defender';
electro = 'FP1';

% avg_vec_anger = compsingle(debate_8666_times, FP1, pows);
% avg_vec_peace = compsingle(debate_8666_times_peace, FP1, pows);

% Extract oscillatory powers of two channels of interest and construct boxplot
% comparison. Uncomment squeezedValuesCh21, SqueezedValuesDe21, diffCh, and
% diffDe to compute the difference between two channels.
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

nonangry_beginner_alpha_arr = table2array(nonangryBeginnersAlpha);
nonangry_beginner_alpha_arr = nonangry_beginner_alpha_arr';
nonangry_beginner_beta_arr = table2array(nonangryBeginnersBeta);
nonangry_beginner_beta_arr = nonangry_beginner_beta_arr';
nonangry_beginner_theta_arr = table2array(nonangryBeginnersTheta);
nonangry_beginner_theta_arr = nonangry_beginner_theta_arr';

freqdesc_alpha_exp.arealp = [];
freqdesc_alpha_exp.arealp = nonangry_beginner_alpha_arr;
freqdesc_alpha_exp.brealp = [];
freqdesc_alpha_exp.brealp = nonangry_beginner_beta_arr;
freqdesc_alpha_exp.trealp = [];
freqdesc_alpha_exp.trealp = nonangry_beginner_theta_arr;

angry_beginner_alpha_arr = table2array(angryBeginnersAlpha);
angry_beginner_alpha_arr = angry_beginner_alpha_arr';
angry_beginner_beta_arr = table2array(angryBeginnersBeta);
angry_beginner_beta_arr = angry_beginner_beta_arr';
angry_beginner_theta_arr = table2array(angryBeginnersTheta);
angry_beginner_theta_arr = angry_beginner_theta_arr';

freqdesc_alpha_exp.areal = [];
freqdesc_alpha_exp.areal = angry_beginner_alpha_arr;
freqdesc_alpha_exp.breal = [];
freqdesc_alpha_exp.breal = angry_beginner_beta_arr;
freqdesc_alpha_exp.treal = [];
freqdesc_alpha_exp.treal = angry_beginner_theta_arr;

angry_experienced_alpha_arr = table2array(angryExperiencedAlpha);
angry_experienced_alpha_arr = angry_experienced_alpha_arr';
angry_experienced_beta_arr = table2array(angryExperiencedBeta);
angry_experienced_beta_arr = angry_experienced_beta_arr';
angry_experienced_theta_arr = table2array(angryExperiencedTheta);
angry_experienced_theta_arr = angry_experienced_theta_arr';

freqdesc_alpha_exp.aexp = [];
freqdesc_alpha_exp.aexp = angry_experienced_alpha_arr;
freqdesc_alpha_exp.bexp = [];
freqdesc_alpha_exp.bexp = angry_experienced_beta_arr;
freqdesc_alpha_exp.texp = [];
freqdesc_alpha_exp.texp = angry_experienced_theta_arr;

nonangry_experienced_alpha_arr = table2array(nonangryExperiencedAlpha);
nonangry_experienced_alpha_arr = nonangry_experienced_alpha_arr';
nonangry_experienced_beta_arr = table2array(nonangryExperiencedBeta);
nonangry_experienced_beta_arr = nonangry_experienced_beta_arr';
nonangry_experienced_theta_arr = table2array(nonangryExperiencedTheta);
nonangry_experienced_theta_arr = nonangry_experienced_theta_arr';

freqdesc_alpha_exp.aexpp = [];
freqdesc_alpha_exp.aexpp = nonangry_experienced_alpha_arr;
freqdesc_alpha_exp.bexpp = [];
freqdesc_alpha_exp.bexpp = nonangry_experienced_beta_arr;
freqdesc_alpha_exp.texpp = [];
freqdesc_alpha_exp.texpp = nonangry_experienced_theta_arr;

cfg = [];
cfg.zparam = 'aexpp';
cfg.layout = 'elec1010B.lay';
ft_topoplotER(cfg, freqdesc_alpha_exp);

save('nonangry_beginner_alpha_arr');
save('nonangry_beginner_beta_arr');
save('nonangry_beginner_theta_arr');
save('nonangry_experienced_alpha_arr');
save('nonangry_experienced_beta_arr');
save('nonangry_experienced_theta_arr');

save('angry_beginner_alpha_arr');
save('angry_beginner_beta_arr');
save('angry_beginner_theta_arr');
save('angry_experienced_alpha_arr');
save('angry_experienced_beta_arr');
save('angry_experienced_theta_arr');




