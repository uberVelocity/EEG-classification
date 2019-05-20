avg_anger = [13.3079 20.1576 -6.1160 5.3612];
avg_non_anger = [7.1506 -2.8539 -3.2184 2.6482];

group = [ones(size(avg_anger))'; 2 * ones(size(avg_non_anger))'];

figure
boxplot([avg_anger; avg_non_anger],group);
title('Challenger FP1 - FP2 across debates');
ylabel('Average Power FP1 - FP2');
set(gca,'XTickLabel',{'anger','non-anger'});

[h,p] = ttest2(avg_anger, avg_non_anger);
sprintf("h = %d", h)
if p <= 0.05
    sprintf("p = %.3f * ", p)
else
    sprintf("p = %.3f", p)
end

% Which should be higher? F3 or F4?