function [elec_values] = comp(pows, noTrials, generated_samples, elec)
% Transforms a 2D representation of elec values into 1D for all channels.
elec_values = zeros(1, generated_samples);
elec_values(:) = nanmean(squeeze(pows(1,elec,:,:)));
for index = 2:noTrials
    elec_values = horzcat(elec_values, nanmean(squeeze(pows(index,elec,:,:))));
end
end