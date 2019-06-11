addpath('C:\Users\redth\Documents\University\Bachelor\git\bachelor-project\data_files\');
load('exp_alpha.mat');
load('exp_beta.mat');
load('exp_theta.mat');
load('shrinked_beginners_alpha.mat');
load('shrinked_beginners_beta.mat');
load('shrinked_beginners_theta.mat');

for index = 1:32
    group = [ones(size(shrinked_beginners_alpha(index, isfinite(shrinked_beginners_alpha(index, :))))); 2 * ones(size(exp_alpha(index, isfinite(exp_alpha(index, :)))))];
    figure
    boxplot([shrinked_beginners_alpha(index, isfinite(shrinked_beginners_alpha(index, :))); exp_alpha(index, isfinite(exp_alpha(index, :)))],group(:));
    tit = sprintf('Beginners vs. Experienced - ALPHA - channel %d', index);
    title(tit);
    yl = sprintf('Average power at channel %d', index);
    ylabel = yl;
    set(gca,'XTickLabel',{'beginners','experienced'});
    placename = sprintf('beg_exp_alpha %d', index);
    fname = 'C:\Users\redth\Documents\University\Bachelor\git\bachelor-project\graphs\channelBoxplots\alpha\beg_exp_alpha';
    % saveas(gca, fullfile(fname, placename), 'jpeg'); % UNCOMMENT TO SAVE
    % GRAPHS
end