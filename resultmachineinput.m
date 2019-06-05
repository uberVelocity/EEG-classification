function [angerout, peaceout] = resultmachineinput(anger, peace, graph_id, debate_name, frequency)
group = [ones(size(anger)); 2 * ones(size(peace))];

[h,p] = ttest2(anger, peace);
sprintf("h = %d", h)
if p <= 0.05
    sprintf("p = %.3f * ", p)
else
    sprintf("p = %.3f", p)
end

tit = sprintf('Anger vs non-anger FP1 %s p = %.3f', frequency, p);
figure
boxplot([anger; peace],group);
title(tit);
ylabel('Average Electrode Power');
set(gca,'XTickLabel',{'anger','non-anger'});
placename = strcat(debate_name, graph_id);
placename = strcat(placename, frequency);
disp(placename);
fname = 'C:\Users\redth\Documents\University\Bachelor\git\bachelor-project\graphs\INNEXPERIENCED';
saveas(gca, fullfile(fname, placename), 'jpeg');
end