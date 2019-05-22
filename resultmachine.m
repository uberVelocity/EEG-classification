avg_anger = [-1.6401 -6.9984 10.8001]';
avg_non_anger = [0.2643 -4.9702 6.9422]';

group = [ones(size(avg_anger)); 2 * ones(size(avg_non_anger))];

figure
boxplot([avg_anger; avg_non_anger],group);
title('Defender FP1 - FP2 ALPHA across debates');
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