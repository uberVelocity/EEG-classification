% Helper script for converting all debates into one continuous debate using
% cell arrays. Each debate is concatenated together.

data2 = data_iccleanedB;
% Transfer trials and times from data2 to data3.
k = 1;
for index = (length(data3.trial) + 1):(length(data3.trial) + length(data2.trial))
    if (k ~= length(data2.trial))
        k = k + 1;
    end
    data3.time{index} = data2.time{k};
    data3.trial{index} = data2.trial{k};
end

% Generate sample info.
new_sample_info = zeros(length(data2.sampleinfo), 2);
new_sample_info(1, 1) = data3.sampleinfo(end,1) + 1000;
new_sample_info(1,2) = new_sample_info(1,1) + 999;
for index = 2:length(data2.sampleinfo)
    new_sample_info(index, 1) = new_sample_info(index - 1, 1) + 1000;
    new_sample_info(index, 2) = new_sample_info(index, 1) + 999;
end

% Concat new sample info to data3.
data3.sampleinfo = vertcat(data3.sampleinfo, new_sample_info);