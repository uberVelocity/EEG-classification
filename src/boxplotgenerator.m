
for index = 1:32
    group = [ones(size(shrinked_beginners_alpha(index, isfinite(shrinked_beginners_alpha(index, :))))); 2 * ones(size(exp_alpha(index, isfinite(exp_alpha(index, :)))))];
    figure
    boxplot([shrinked_beginners_alpha(index, isfinite(shrinked_beginners_alpha(index, :))); exp_alpha(index, isfinite(exp_alpha(index, :)))],group(:));
    tit = sprintf('Beginners vs. Experienced - ALPHA - channel %d', index);
    title(tit);
    yl = sprintf('Average power at channel %d', index);
    ylabel = yl;
    set(gca,'XTickLabel',{'beginners','experienced'});
end