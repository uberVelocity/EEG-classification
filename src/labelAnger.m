function [angerLocations] = labelAnger(originalAngerTimes)
% Labels a time interval as anger.
angerLocations = [];
for index = 1:length(originalAngerTimes)
    angerLocations = horzcat(angerLocations, originalAngerTimes(index)*41:originalAngerTimes(index)*41+82);
end
end

