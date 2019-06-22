% Generates boxplots for channels at theta-frequency between experienced
% and beginner monks.

addpath('C:\Users\redth\Documents\University\Bachelor\git\bachelor-project\data_files\');
load('exp_alpha.mat');
load('exp_beta.mat');
load('exp_theta.mat');
load('shrinked_beginners_alpha.mat');
load('shrinked_beginners_beta.mat');
load('shrinked_beginners_theta.mat');

for index = 1:32
    group = [ones(size(shrinked_beginners_theta(index, isfinite(shrinked_beginners_theta(index, :))))); 2 * ones(size(exp_theta(index, isfinite(exp_theta(index, :)))))];
    figure
    boxplot([shrinked_beginners_theta(index, isfinite(shrinked_beginners_theta(index, :))); exp_theta(index, isfinite(exp_theta(index, :)))],group(:));
    tit = sprintf('Beginners vs. Experienced - THETA - channel %d', index);
    title(tit);
    yl = sprintf('Average power at channel %d', index);
    ylabel = yl;
    set(gca,'XTickLabel',{'beginners','experienced'});
    placename = sprintf('beg_exp_theta %d', index);
    fname = 'C:\Users\redth\Documents\University\Bachelor\git\bachelor-project\graphs\channelBoxplots\theta\beg_exp_theta';
    % saveas(gca, fullfile(fname, placename), 'jpeg'); % UNCOMMENT TO SAVE
    % GRAPHS
end