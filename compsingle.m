function [vec_avg_power] = compsingle(times, electrode, pows)
%COMPSINGLE Summary of this function goes here
%   Detailed explanation goes here
vec_avg_power = zeros(1, length(times));
for index = 1:length(times)
    squeezedValues = squeeze(pows(times(index), electrode,:,:));
    vec_avg_power(index) = nanmean(nanmean(squeezedValues));
end
end

