% Computes false/true positive/negative rates for anger audio classification
% technique based on amplitude.

[y,Fs] = audioread("challengerdefender1.MOV");  % Read audio file.
y = y(:, 1);  % Reduce data to half since we do not have two channels.
cpy = y;  % Copy data for safe-keeping.
[peaks, locs] = findpeaks(y, Fs, "MinPeakHeight", 0.9, "MinPeakDistance", 0.5);  % Determine claps.
% Convert from samples to time in order to extract correct index of peak.
samples = 0:length(y)-1;
t = samples/Fs;
thresholdzscore = 5.5;
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
% Compute standard deviation of every non-clap sample in the data.
standarddev = std(clapless);
% Compute Z-score and store it into copy.
cpy = cpy / standarddev;

% Plot the z-score of every sample.
figure(3);
plot(t, cpy);

% Count how many significant locations exist.
cnt = 0;
for index = 1:length(cpy)
    if cpy(index) >= thresholdzscore 
        cnt = cnt + 1;
    end
end
% Store the index of the significant locations in signloc.
signloc = zeros(1, cnt);
k = 1;
for index = 1:length(cpy)
    if cpy(index) >= thresholdzscore 
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
    if cpy(index) >= thresholdzscore 
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
    if cpy(index) >= thresholdzscore 
        sigtimes(k) = t(index);
        k = k + 1;
    end
    index = index + 1;
end

% Store in times that Mihai found to be anger.
manual_times_4a = [123, 129, 138, 232, 253, 261, 283, 478, 512];
manual_times_1a = [254, 266, 358, 365, 396, 464, 475, 497, 499, 504, 534, 537, 538, 550, 552, 554, 583, 593, 594, 625, 665, 692, 699];

% Store in intersected times found by raters.
manual_times_1a_int = [254, 363, 396, 528, 551, 593, 690];
manual_times_2_int = [280, 292, 340, 442, 588, 605];
manual_times_3_int = [398, 523, 588];

% Check whether the values that the program found correspond to the values
% that we found.
matching_times_1a_int = ismember(manual_times_1a_int, fix(sigtimes));
matching_times_2_int = ismember(manual_times_2_int, fix(sigtimes));
matching_times_3_int = ismember(manual_times_3_int, fix(sigtimes));

% Store the values in a different variable.
final_matching_times_1a = matching_times_1a_int;
final_matching_times_2 = matching_times_2_int;
final_matching_times_3 = matching_times_3_int;

% Compute true positive rate of intersected times:
accuracy = sum(final_matching_times_1a) / length(final_matching_times_1a);
disp("accuracy_intersected_1a");
disp(accuracy);
disp(final_matching_times_1a);

accuracy = sum(final_matching_times_2) / length(final_matching_times_2);
disp("accuracy_intersected_2");
disp(accuracy);
disp(final_matching_times_2);

accuracy = sum(final_matching_times_3) / length(final_matching_times_3);
disp("accuracy_intersected_3");
disp(accuracy);
disp(final_matching_times_3);

% Compute significance at every second.
total_results = ismember(1:fix(max(t)), fix(sigtimes));

% Compute how many points are significant.
totalcnt = sum(total_results);
disp("total significant points:");
disp(sigcnt);

% Compute true positives.
tp = 0;
for index = 1:length(total_results)
    if (total_results(index) == 1 && ismember(index, manual_times_1a_int))
        disp(index);
        tp = tp + 1;
    end
end
disp("true positives");
disp(tp);

% Compute false positives.
fp = 0;
for index = 1:length(total_results)
    if (total_results(index) == 1 && ~ismember(index, manual_times_1a_int))
        fp = fp + 1;
    end
end
disp("false positives");
disp(fp);

% Compute false negatives.
fn = 0;
for index = 1:length(total_results)
    if (total_results(index) == 0 && ismember(index, manual_times_1a_int))
        fn = fn + 1;
    end
end
disp("false negatives");
disp(fn);

% Compute true negatives.
tn = 0;
for index = 1:length(total_results)
    if (total_results(index) == 0 && ~ismember(index, manual_times_1a_int))
        tn = tn + 1;
    end
end
disp("true negatives");
disp(tn);

k = 0;
figure(10);
c = 0.0;
plot(c);
hold on;
for i = 1:620
   c = data_iccleanedA.trial{1,i};
   plot(c(1,:));
end