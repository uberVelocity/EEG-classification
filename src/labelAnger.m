function [angerLocations] = labelAnger(originalAngerTimes)
%LABELANGER Summary of this function goes here
%   Detailed explanation goes here
angerLocations = [];
for index = 1:length(originalAngerTimes)
    angerLocations = horzcat(angerLocations, originalAngerTimes(index)*41:originalAngerTimes(index)*41+82);
end
end

