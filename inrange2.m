function [vectorvalues] = inrange2(input)
%Generates the range of +- 2 seconds from a second of interest.
%   For every significant second reported, an interval of 5 seconds will be
%   taken under investigation for EEG analysis and classification training.
%   Thus, a point given by the automatic loudness detection algorithm is
%   considered a true positive if it is found in the vector generated by
%   this function when the given input represents the manual times found by
%   the raters.
vectorvalues = zeros(1,length(input) * 5);
k  = 1;
for index = 1:length(input)
    vectorvalues(k) = input(index);
    k = k + 1;
    vectorvalues(k) = input(index) - 2;
    k = k + 1;
    vectorvalues(k) = input(index) - 1;
    k = k + 1;
    vectorvalues(k) = input(index) + 1;
    k = k + 1;
    vectorvalues(k) = input(index) + 2;
    k = k + 1;
end
end

