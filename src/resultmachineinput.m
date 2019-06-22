% Generates boxplots of anger and non-anger moments.
function [angerout, peaceout] = resultmachineinput(anger, peace, graph_id, debate_name, frequency, electro)
group = [ones(size(anger)); 2 * ones(size(peace))];

[h,p] = ttest2(anger, peace);
sprintf("h = %d", h)
if p <= 0.05
    sprintf("p = %.3f * ", p)
else
    sprintf("p = %.3f", p)
end

tit = sprintf('Anger vs non-anger %s %s p = %.3f',electro, frequency, p);
figure;
boxplot([anger; peace],group);
title(tit);
ylabel('Average Electrode Power');
set(gca,'XTickLabel',{'anger','non-anger'});
placename = strcat(debate_name, graph_id);
placename = strcat(placename, electro);
placename = strcat(placename, frequency);
disp(placename);
fname = 'C:\Users\redth\Documents\University\Bachelor\git\bachelor-project\graphs\EXPERIENCED';
saveas(gca, fullfile(fname, placename), 'jpeg');
end