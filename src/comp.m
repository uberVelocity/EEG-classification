function [elec_values] = comp(pows, noTrials, generated_samples, elec)
% Transforms a 2D representation of elec values into 1D for all electrodes
elec_values = zeros(1, generated_samples);
disp(size(elec_values));
elec_values(:) = nanmean(squeeze(pows(1,elec,:,:)));
disp(elec_values);
for index = 2:noTrials
    % Reduces 1-sized dimension to convert matrix from 4D to 2D.
    elec_values = horzcat(elec_values, nanmean(squeeze(pows(index,elec,:,:))));
    % Compute difference between higher and lower electrodes power.
    
end
end