# Bachelor project 

## TODO:
1. Recompute F4 - F3 for the challenger since they are currently flipped.
2. Compose graphs grouped via frequency.
3. Compose graphs by averaging frequencies.
4. Finish 5th video analysis.
5. Finish two challenger / two defender.
6. Analyze 2C / 2D.
7. Add 2C / 2D to graphs.
8. Compare experienced vs non-experienced.
9. Array with debate structure in them. Each structure has attributed an offset and
the times of anger. In order to consider all the debates as one, the classifier loops
through the array of structures and uses the local offset and times.
(maybe offset is not even needed since times are calculated before classifier is run).
## Extension app
The app would give you an option to choose what type of debate to run investigations on. Based on the times that we have chosen, the app would run an oscillatory power test on the debate at a frequency given by the user. It is an interface that implements the methodology that we have used. If implementing multiple classifiers, an option to train and test different classifiers could be implemented using different portions of the data.
10. **After** getting beginner results of analysis, then maybe take 1 second interval times of interest, so half a trial.
Recommendation from teacher as occurrence of anger may dissipate quickly. This works under the assumption that the statement is true 
and under the assumption that we have accurate times. 
11. Apply a Linear Mixed effects model in R on the data (need to investigate what this entails).
## INSTRUCTIONS

Intersected times of anger / non-anger are in debate_X_times.m / debate_X_times_peace.m. The electrodes and frequency specifications are in elec_freq.m.

1. Activate Fieldtrip by adding its path to your current working directory and running ft_defaults:
```Matlab
addpath('fieldtrip\directory');
ft_defaults;
```
2. Computing the oscillatory power of all sites for a frequency can be done with the function `fieldanalfn(freq, data`).
3. Computing the average power of anger / non-anger conditions can be done with the function `comp('debate_X_times', elec1, elec2, pows)`
The averages are displayed in console. Currently, the `comp()` function gives you the difference between elec1 and elec2 in terms of average power.
4. After computing every average of every debate, the results of the two conditions are put in seperate vectors. Boxplots of the two vectors are created and the p-value is computed.

## Detect average loudness of voice and detect voice above threshold
An automated way in which anger might be detected is by using loudness as an indication of anger. By extracting just the voice of the monk from the audio file and computing how many standard deviations the voice is from the average (z-score) one can have an intuition whether a monk is feeling angry. How many deviations it needs to be is still a matter of discussion.

This is done in a few steps:
### Audio - removal of claps
During the debates monks clap. Claps are a nuiscance since they mess with the average amplitude value of the sound file. They need to be removed in order to get a representative number of the average loudness the monks' voice.
#### Original idea
Claps are very high in amplitude. So much so that they create hardware clippings, meaning that their value is infinite on the db scale (sometimes represented as 0 in the data). The claps can be easily detected by taking the peaks of the data, which are these clippings (marked in red on the spectogram).
![](clippings.png)
A clap, however, although generating a peak, it also generates infinitessimally smaller values compared to the peak near the peak that will not be caught by taking the maximum. A sample interval to the left and to the right of the peak should be taken instead. How large this sample interval needs to be is still up for discussion.

Create vector of values of claps named `claps`.
Create a new vector of original values - the values from `claps`.
The following bit of code is in `n^2` so it is not favorable (takes more than 20 minutes).
```matlab
ismember(index, claps);
```
Better solution is to:
1. Use a pointer that loops through the original array.
2. Check value of pointer == value of pointer in claps array.
3. Increment claps array pointer only when values are true.
4. If the values are false, add in a new vector at a pointer whose value increments only in this if statement the value at the index position.
![](clap_intervals.png)
When computing the average in order to normalize the data and compute its z-score, the clapping values should not be removed since that would shift the EEG data. Better is to give it a value which does not influence the loudness (0 probably but if clippings are also 0 values then we have a problem) and count how many there are. Subtract the number over which you divide by this counter to not count the claps in the average.

#### Comparison between anger and non-anger moments of Channel FP1 for Alpha waves.
![](fp1anger.png)
![](fp1nonanger.png)
