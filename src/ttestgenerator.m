% Computes a t-test between two data sets. Since a linear-mixed-effects
% model is more robust as it does not require equal sample sizes and also
% takes into account random effects present between observations of
% debates, this script is no longer used.

% Compare every channel by applying a t-test between exp and non-exp monks.
load('final_peace_beginner_alpha');
load('final_anger_beginner_alpha');


% Beginner data - Shrinked to plot
shrinked_beginner_alpha = final_data_beginner.alpha_results(:, 1:72406); 
shrinked_beginner_beta = final_data_beginner.beta_results(:, 1:72406);
shrinked_beginner_theta = final_data_beginner.theta_results(:, 1:72406);

% Experienced data
exp_alpha = final_data_exp.alpha_results(:, :);
exp_beta = final_data_exp.beta_results(:, :);
exp_theta = final_data_exp.theta_results(:, :);

storage_beginner_alpha = zeros(32, length(shrinked_beginner_alpha(:, isfinite(shrinked_beginner_alpha(1, :)))));
storage_beginner_beta = zeros(32, length(shrinked_beginner_beta(:, isfinite(shrinked_beginner_beta(1, :)))));
storage_beginner_theta = zeros(32, length(shrinked_beginner_theta(:, isfinite(shrinked_beginner_theta(1, :)))));

storage_exp_alpha = zeros(32, length(exp_alpha(:, isfinite(exp_alpha(1, :)))));
storage_exp_beta = zeros(32, length(exp_beta(:, isfinite(exp_beta(1, :)))));
storage_exp_theta = zeros(32, length(exp_theta(:, isfinite(exp_theta(1, :)))));


storage_peace_alpha = zeros(32, length(final_peace_beginner_alpha(:, isfinite(final_peace_beginner_alpha(1,:)))));
storage_peace_beta = zeros(32, length(final_peace_beginner_beta(:, isfinite(final_peace_beginner_beta(1, :)))));
storage_peace_theta = zeros(32, length(final_peace_beginner_theta(:, isfinite(final_peace_beginner_theta(1, :)))));

storage_anger_alpha = zeros(32, length(final_anger_beginner_alpha(:, isfinite(final_anger_beginner_alpha(1,:)))));
storage_anger_beta = zeros(32, length(final_anger_beginner_beta(:, isfinite(final_anger_beginner_beta(1,:)))));
storage_anger_theta= zeros(32, length(final_anger_beginner_theta(:, isfinite(final_anger_beginner_theta(1,:)))));

for index = 1:32
    storage_peace_alpha(index, :) = final_peace_beginner_alpha(index, isfinite(final_peace_beginner_alpha(index,:)));
    storage_anger_alpha(index, :) = final_anger_beginner_alpha(index, isfinite(final_anger_beginner_alpha(index,:)));
    storage_peace_beta(index, :) = final_peace_beginner_beta(index, isfinite(final_peace_beginner_beta(index, :)));
    storage_anger_beta(index, :) = final_anger_beginner_beta(index, isfinite(final_anger_beginner_beta(index, :)));
    storage_peace_theta(index, :) = final_peace_beginner_theta(index, isfinite(final_peace_beginner_theta(index,:)));
    storage_anger_theta(index, :) = final_anger_beginner_theta(index, isfinite(final_anger_beginner_theta(index,:)));

    storage_exp_alpha(index, :) = exp_alpha(index, isfinite(exp_alpha(index, :)));
    storage_exp_beta(index, :) = exp_beta(index, isfinite(exp_beta(index, :)));
    storage_exp_theta(index, :) = exp_theta(index, isfinite(exp_theta(index, :)));
    storage_beginner_alpha(index, :) = shrinked_beginner_alpha(index, isfinite(shrinked_beginner_alpha(index, :)));
    storage_beginner_beta(index, :) = shrinked_beginner_beta(index, isfinite(shrinked_beginner_beta(index, :)));
    storage_beginner_theta(index, :) = shrinked_beginner_theta(index, isfinite(shrinked_beginner_theta(index, :)));
end

hypotheses = zeros(3, 32);
pvalues = zeros(3, 32);

for index = 1:32 % Loop through all channels.
    [hypotheses(1, index), pvalues(1, index)] = ttest2(storage_peace_alpha(index, :), storage_anger_alpha(index, :));
    [hypotheses(2, index), pvalues(2, index)] = ttest2(storage_peace_beta(index, :), storage_anger_beta(index, :));
    [hypotheses(3, index), pvalues(3, index)] = ttest2(storage_peace_theta(index, :), storage_anger_theta(index, :));

end

 % T-test between anger and non-anger moments at every channel.


%  T-test between beginners and experienced monks at every channel.
%    [hypotheses(1, index), pvalues(1, index)] = ttest2(storage_beginner_alpha(index, :), storage_exp_alpha(index, :));
%    [hypotheses(2, index), pvalues(2, index)] = ttest2(storage_beginner_beta(index, :), storage_exp_beta(index, :));
%    [hypotheses(3, index), pvalues(3, index)] = ttest2(storage_beginner_theta(index, :), storage_exp_theta(index, :));
    