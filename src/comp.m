function [vec_avg_diff] = comp(times, higher_elec, lower_elec, pows)
% Computes average difference of electrodes for every time.
vec_avg_diff = zeros(1, length(times));
for index = 1:length(times)
    % Reduces 1-sized dimension to convert matrix from 4D to 2D.
    squeezedHigher = squeeze(pows(times(index),higher_elec,:,:));
    squeezedLower = squeeze(pows(times(index),lower_elec,:,:));
    % Compute difference between higher and lower electrodes power.
    difference = squeezedHigher - squeezedLower;
    vec_avg_diff(index) = nanmean(nanmean(difference));
end
end