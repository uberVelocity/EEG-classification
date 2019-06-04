function [angerout, peaceout] = resultmachineinput(anger,peace)
group = [ones(size(anger)); 2 * ones(size(peace))];

[h,p] = ttest2(anger, peace);
sprintf("h = %d", h)
if p <= 0.05
    sprintf("p = %.3f * ", p)
else
    sprintf("p = %.3f", p)
end
tit = sprintf('Anger vs non-anger FP1 alpha p = %.3f', p);
figure
boxplot([anger; peace],group);
title(tit);
ylabel('Average Electrode Power');
set(gca,'XTickLabel',{'anger','non-anger'});
end