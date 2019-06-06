[y,Fs] = audioread("challengerdefender1.MOV");  % Read audio file.
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
figure(2);
hold on;
plot(t,y);
plot(t(loc), y(loc), 'og');
for index = 1:length(loc)
    plot(t(loc(index) + skip), y(loc(index) + skip), 'or');
end

% Compute average while skipping claps and without reducing the original
% vector. This is important since we do not want our data shifted in time
% with respect to our EEG data. This is done simply by going through the
% vector of samples and adding each point to the variable `addi`. A pointer
% is kept in the `loc` vector which is filled with the indicies of the
% beginning of claps. Once arrived at this point, we want to skip `skip`
% samples (roughly the duration of a clap). Hence, we move our `index`
% `skip` steps and point to the next beginning of a clap by incrementing
% `k`. The number of elements skipped is given by `(k - 1) * skips` since
% for every clap we skip 5000 elements. It's `k - 1` since `k` gets
% incremented one last time for the last clap, which moves it to 70, but
% there are in total 69 claps, not 70, since indexing starts at 1.
k = 1;
addi = 0;
index = 1;
while index < length(y)
    if k < 70 && index == loc(k)
        % Debug to make sure that we're actually skipping claps. Should
        % give values above 0.9.
        index = index + skip;  % Skip 5000 samples.
        k = k + 1;  % Point to the next start of a clap.
    end
    if y(index) > 0
        addi = addi + y(index);
    end
    index = index + 1;
end
disp("k should be 70");
disp(k);
noelsk = (k - 1) * 5000;  % Number of elements skipped.
noel = length(y) - noelsk;  % Number of elements added.
average = addi / noel;  % Average loudness of voice.
% Normalize data by subtracting the mean at each data point.
cpy = cpy - average;

% Compute standard deviation.
k = 1;
j = 1;
% Initialize vecetor containing values of clapless times.
clapless = zeros(1,noel);
index = 1;
while index < length(y)
    if k < 70 && index == loc(k)
        disp(cpy(index));
        index = index + skip;
        k = k + 1;
    end
    clapless(j) = cpy(index);
    j = j + 1;
    index = index + 1;
end
% Compute standard deviation of every non-clap sample.
standarddev = std(clapless);
% Compute Z-score and store it into copy.
cpy = cpy / standarddev;
cnt = 0;
% Count how many significant locations exist.
for index = 1:length(cpy)
    if cpy(index) >= 1.96 && cpy(index) <= 5.4
        cnt = cnt + 1;
    end
end
% Store the index of the significant locations in signloc.
signloc = zeros(1, cnt);
k = 1;
for index = 1:length(cpy)
    if cpy(index) >= 1.96 && cpy(index) <= 5.4
        signloc(k) = index;
        k = k + 1;
    end
end
% Convert from samples to time.
sigtimesclaps = signloc/Fs;

% Count how many significant non-clap locations there are.
index = 1;
sigcnt = 0;
jindex = 1;
while index < length(cpy)
    if jindex < 70 && index == loc(jindex)
        index = index + skip;
        jindex = jindex + 1;
    end
    if cpy(index) >= 1.96 && cpy(index) <= 5.4
        sigcnt = sigcnt + 1;
    end
    index = index  + 1;
end

% Store just the non-clap significant locations.
sigtimes = zeros(1, sigcnt);
jindex = 1;
k = 1;
index = 1;
while index < length(cpy)
    if jindex < 70 && index == loc(jindex)
        index = index + skip;
        jindex = jindex + 1;
    end
    if cpy(index) >= 1.96 && cpy(index) <= 5.4
        sigtimes(k) = t(index);
        k = k + 1;
    end
    index = index + 1;
end

% Store in times that you have found to be arousal in common with Michelle.
manual_times_4a = [123, 129, 138, 232, 253, 261, 283, 478, 512];
manual_times_1a = [254, 266, 358, 365, 396, 464, 475, 497, 499, 504, 534, 537, 538, 550, 552, 554, 583, 593, 594, 625, 665, 692, 699];
% Store logical vector checking whether those values are in the significant
% values found by the program.
matching_4a = ismember(manual_times_4a, fix(sigtimes));
matching_1a = ismember(manual_times_1a, fix(sigtimes));
% Display whether numbers in manually inputted vector matched the ones
% found by the program.
disp(matching_4a);
disp(matching_1a);
% IMPORTANT: We are comparing whether the values that we have found to be
% ANGER are found by the program to be AROUSAL. Since anger is a subset of
% arousal, a value found by the program to be arousal that is not found in
% our manual_times vector does not constitute as a false positive of the
% solution, since it still may be anger. It constitutes as a false positive
% only when we can determine by means of EEG that the brian activity does
% not correspond to an angry emotion within that specified time.


% Display the output false positives - To be done after EEG analysis.

% If we want to still compare the manual_times to the significant times
% found by the program and compute the confusion matrix we need to see how
% many true negatives, true positives, false positives and false negatives we have.

% Compute significance at every second.
total_results = ismember(1:fix(max(sigtimes)), fix(sigtimes));

% Compute how many points are significant.
totalcnt = sum(total_results);

figure(10);
plot(t, y);
hold on;
for index = 1:length(sigtimes)
    plot(sigtimes(index), 0, 'oy');
end

disp("this many significance");
disp(sigcnt);

while fix(locs(index)) == wpart
    index = index + 1;
end

endvalue = locs(index - 1);
beginninginterval = startvalue * Fs;
endinterval = endvalue * Fs;
sprintf("beg = %.4lf", beginninginterval);
sprintf("end = %.4lf", endinterval);