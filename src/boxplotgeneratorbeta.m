% Generates boxplots for channels at beta-frequency between experienced
% and beginner monks.

addpath('C:\Users\redth\Documents\University\Bachelor\git\bachelor-project\data_files\');
load('exp_alpha.mat');
load('exp_beta.mat');
load('exp_theta.mat');
load('shrinked_beginners_alpha.mat');
load('shrinked_beginners_beta.mat');
load('shrinked_beginners_theta.mat');

for index = 1:32
    group = [ones(size(shrinked_beginners_beta(index, isfinite(shrinked_beginners_beta(index, :))))); 2 * ones(size(exp_beta(index, isfinite(exp_beta(index, :)))))];
    figure
    boxplot([shrinked_beginners_beta(index, isfinite(shrinked_beginners_beta(index, :))); exp_beta(index, isfinite(exp_beta(index, :)))],group(:));
    tit = sprintf('Beginners vs. Experienced - BETA - channel %d', index);
    title(tit);
    yl = sprintf('Average power at channel %d', index);
    ylabel = yl;
    set(gca,'XTickLabel',{'beginners','experienced'});
    placename = sprintf('beg_exp_beta %d', index);
    fname = 'C:\Users\redth\Documents\University\Bachelor\git\bachelor-project\graphs\channelBoxplots\beta\beg_exp_beta';
    % saveas(gca, fullfile(fname, placename), 'jpeg'); % UNCOMMENT TO SAVE
    % GRAPHS
end