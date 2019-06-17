% Remove outliers from initial data. An outlier is a value that is three
% standard deviations from the mean.
% Row 1 = alpha, Row 2 = beta, Row 3 = theta.
noOutliersExperienced = cell(32, 3);
noOutliersBeginner = cell(32, 3);
for index = 1:32
    noOutliersBeginner(index, 1) = {rmoutliers(storage_beginner_alpha(index, :), 'mean')};
    noOutliersBeginner(index, 2) = {rmoutliers(storage_beginner_beta(index, :), 'mean')};
    noOutliersBeginner(index, 3) = {rmoutliers(storage_beginner_theta(index, :), 'mean')};
    noOutliersExperienced(index, 1) = {rmoutliers(storage_exp_alpha(index, :), 'mean')};
    noOutliersExperienced(index, 2) = {rmoutliers(storage_exp_beta(index, :), 'mean')};
    noOutliersExperienced(index, 3) = {rmoutliers(storage_exp_theta(index, :), 'mean')};
end

% Compute t-test of channels between conditions and save the results.
hypotheses = zeros(3, 32);
pvalues = zeros(3, 32);
for index = 1:32
    [hypotheses(1, index), pvalues(1, index)] = ttest2(noOutliersBeginner{index, 1}, noOutliersExperienced{index, 1}, 'Alpha', 0.05/32);
    [hypotheses(2, index), pvalues(2, index)] = ttest2(noOutliersBeginner{index, 2}, noOutliersExperienced{index, 2}, 'Alpha', 0.05/32);
    [hypotheses(3, index), pvalues(3, index)] = ttest2(noOutliersBeginner{index, 3}, noOutliersExperienced{index, 3}, 'Alpha', 0.05/32);
    disp(mean(noOutliersBeginner{index, 1}));
    disp('vs');
    disp(mean(noOutliersExperienced{index, 1}));
end