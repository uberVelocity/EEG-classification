avg_anger = [4.6706 25.0660 6.8289 -11.0169]';
avg_non_anger = [6.1363 -1.6169 15.8162 -11.3773]';

group = [ones(size(avg_anger)); 2 * ones(size(avg_non_anger))];

figure
boxplot([avg_anger; avg_non_anger],group);
title('Challenger T8 - T7 across debates');
ylabel('Average Power T8 - T7');
set(gca,'XTickLabel',{'anger','non-anger'});

[h,p] = ttest2(avg_anger, avg_non_anger);
sprintf("h = %d", h)
if p <= 0.05
    sprintf("p = %.3f * ", p)
else
    sprintf("p = %.3f", p)
end

% Which should be higher? F3 or F4?