[y,Fs] = audioread("challengerdefender4.MOV");  % Read audio file.
y = y(:, 1);  % Reduce data to half since we do not have two channels.
cpy = y;  % Copy data for safe-keeping.
[peaks, locs] = findpeaks(y, Fs, "MinPeakHeight", 0.9, "MinPeakDistance", 0.5);  % Determine claps.
% Convert from samples to time in order to extract correct index of peak.
samples = 0:length(y)-1;
t = samples/Fs;
% Extract correct indices in vector loc.
[tf, loc] = ismember(locs, t);
skip = 5000;  % Amount of samples to skip (peaks) determined by the duration of a clap.
% Plot figure of claps intervals (they start with green - end with red).
figure(1);
hold on;
plot(t,y);
plot(t(loc), y(loc), 'og');
for index = 1:length(loc)
    plot(t(loc(index) + skip), y(loc(index) + skip), 'or');
end

% Compute average while skipping claps and without reducing the original
% vector. This is important since we do not want our data shifted in time
% with respect to our EEG data. This is done simply by going through the
% vector of samples and adding each point to the variable `sum`. A pointer
% is kept in the `loc` vector which is filled with the indicies of the
% beginning of claps. Once arrived at this point, we want to skip `skip`
% samples (roughly the duration of a clap). Hence, we move our `index`
% `skip` steps and point to the next beginning of a clap by incrementing
% `k`. The number of elements skipped is given by `(k - 1) * skips` since
% for every clap we skip 5000 elements. It's `k - 1` since `k` gets
% incremented one last time for the last clap, which moves it to 70, but
% there are in total 69 claps, not 70, since indexing starts at 1.
sum = 0;
k = 1;
for index = 1:length(y)
    if k < 70 && index == loc(k)
        % Debug to make sure that we're actually skipping claps. Should
        % give values above 0.9.
        disp(y(index));  
        index = index + skip;  % Skip 5000 samples.
        k = k + 1;  % Point to the next start of a clap.
    end
    sum = sum + y(index);
end
noelsk = (k - 1) * 5000;  % Number of elements skipped.
noel = length(y) - noelsk;  % Number of elements added.
average = sum / noel;  % Average loudness of voice.

% Normalize data by subtracting the mean at each data point.
cpy = cpy - average;

while fix(locs(index)) == wpart
    index = index + 1;
end

endvalue = locs(index - 1);
beginninginterval = startvalue * Fs;
endinterval = endvalue * Fs;
sprintf("beg = %.4lf", beginninginterval);
sprintf("end = %.4lf", endinterval);