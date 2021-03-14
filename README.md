EEG Brain Age with Comprehensive Feature Extraction 
============================================
Please note that the code presented here are modification and extension of NEURAL: A Neonatal EEG Feature Set in Matlab.
For more details please see:

Al Zoubi, Obada, Chung Ki Wong, Rayus T. Kuplicki, Hung-wen Yeh, Ahmad Mayeli, Hazem Refai, Martin Paulus, and Jerzy Bodurka. "Predicting age from brain EEG signals—A machine learning approach." Frontiers in aging neuroscience 10 (2018): 184.
and 
NEURAL: https://arxiv.org/abs/1704.05694. 
# requirements:
Matlab 2013 or later. Please note, the toolbox requires also the signal
processing toolbox and statistics toolbox
```matlab
	% run the main script 
	runMe_Demo.m;

```
Support features:

The feature set contains amplitude, spectral, connectivity, and burst annotation features.
Amplitude features include range-EEG (D. O’ Reilly et al., 2012;
see [references](#references)), a clearly-defined alternative to amplitude-integrated EEG
(aEEG). All features are generated for four different frequency bands (typically 0.5–4,
4–7, 7–13, and 13–30 Hz), with some exceptions. The following table describes the features
in more detail:

| Feature Name               | Description                                                                   | FB  |
|----------------------------|-------------------------------------------------------------------------------|-----|
| spectral\_power            | spectral power: absolute                                                      | yes |
| spectral\_relative\_power  | spectral power: relative (normalised to total spectral power)                 | yes |
| spectral\_flatness         | spectral entropy: Wiener (measure of spectral flatness)                       | yes |
| spectral\_entropy          | spectral entropy: Shannon                                                     | yes |
| spectral\_diff             | difference between consecutive short-time spectral estimates                  | yes |
| spectral\_edge\_frequency  | cut-off frequency (fc): 95% of spectral power contained between 0.5 and fc Hz | no  |
| FD                         | fractal dimension                                                             | yes |
| amplitude\_total\_power    | time-domain signal: total power                                               | yes |
| amplitude\_SD              | time-domain signal: standard deviation                                        | yes |
| amplitude\_skew            | time-domain signal: skewness                                                  | yes |
| amplitude\_kurtosis        | time-domain signal: kurtosis                                                  | yes |
| amplitude\_env\_mean       | envelope: mean value                                                          | yes |
| amplitude\_env\_SD         | envelope: standard deviation (SD)                                             | yes |
| connectivity\_BSI          | brain symmetry index (see Van Putten 2007)                                    | yes |
| connectivity\_corr         | correlation (Spearman) between envelopes of hemisphere-paired channels        | yes |
| connectivity\_lag\_corr    | lag of maximum correlation coefficient between hemisphere-paired channels     | yes |
| connectivity\_coh\_mean    | coherence: mean value                                                         | yes |
| connectivity\_coh\_max     | coherence: maximum value                                                      | yes |
| connectivity\_coh\_freqmax | coherence: frequency of maximum value                                         | yes |
| rEEG\_mean                 | range EEG: mean                                                               | yes |
| rEEG\_median               | range EEG: median                                                             | yes |
| rEEG\_lower\_margin        | range EEG: lower margin (5th percentile)                                      | yes |
| rEEG\_upper\_margin        | range EEG: upper margin (95th percentile)                                     | yes |
| rEEG\_width                | range EEG: upper margin - lower margin                                        | yes |
| rEEG\_SD                   | range EEG: standard deviation                                                 | yes |
| rEEG\_CV                   | range EEG: coefficient of variation                                           | yes |
| rEEG\_asymmetry            | range EEG: measure of skew about median                                       | yes |


FB: features generated for each frequency band (FB)


