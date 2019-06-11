% Compare every channel by applying a t-test between exp and non-exp monks.

% Beginner data - Shrinked to plot
shrinked_beginners_alpha = final_data_beginner.alpha_results(:, 1:72406); 
shrinked_beginners_beta = final_data_beginner.beta_results(:, 1:72406);
shrinked_beginners_theta = final_data_beginner.theta_results(:, 1:72406);

% Experienced data
exp_alpha = final_data_exp.alpha_results(:, :); 
exp_beta = final_data_exp.beta_results(:, :);
exp_theta = final_data_exp.theta_results(:, :);

hypotheses = zeros(3, 32);
pvalues = zeros(3, 32);
for index = 1:32 % Loop through all channels.
    [hypotheses(1, index), pvalues(1, index)] = ttest2(shrinked_beginners_alpha(isfinite(shrinked_beginners_alpha)), exp_alpha(isfinite(exp_alpha)));
    [hypotheses(2, index), pvalues(2, index)] = ttest2(shrinked_beginners_beta(isfinite(shrinked_beginners_beta)), exp_beta(isfinite(exp_beta)));
    [hypotheses(3, index), pvalues(3, index)] = ttest2(shrinked_beginners_theta(isfinite(shrinked_beginners_theta)), exp_theta(isfinite(exp_theta)));
end
