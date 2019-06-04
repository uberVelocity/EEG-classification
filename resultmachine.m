
avg_anger = [58.7113 152.0794 103.1098 8.4868 139.4885 816.8377 137.8254 24.7570 33.9020 158.5626 77.4063 13.8801]';
avg_non_anger = [50.4586 15.1393 30.8146 10.8477 231.5598 36.7476 46.7196 38.6475 12.0438 21.3455 13.8915 14.9907]';

group = [ones(size(avg_anger)); 2 * ones(size(avg_non_anger))];

figure
boxplot([avg_anger; avg_non_anger],group);
title('Challenger FP1 Alpha across debates');
ylabel('Average Power T8-T7');
set(gca,'XTickLabel',{'anger','non-anger'});

[h,p] = ttest2(avg_anger, avg_non_anger);
sprintf("h = %d", h)
if p <= 0.05
    sprintf("p = %.3f * ", p)
else
    sprintf("p = %.3f", p)
end

% Which should be higher? F3 or F4?