# Rhythmic Priming
Code and notes from Rhythmic Priming: this time with MSE!

## What has been done so far:
1. EEG Timeseries Import and multi-scale entropy (MSE) estimation (Code: 1. EEG_Import.m)
2. Running partial least squares (PLS) on the MSE matrices averaged by task (Code: 2. MARCS_MSE_PLS.m)

All results are in the Matlab file "First_Results.mat". I have a giant structure array with all of the input data as well, but it's too big for Github, hahaha

## Results so far:
### Brain MSE PLS Analyses (Code 2.)
I imported all the EEG data and broke it into epochs using the trigge information. For each participant, we have 24 sequences with three epochs: a prime (regular or irregular), sentence first position, and sentence second position. I extracted MSE fot each epoch, averaged them by prime type (e.g. regular prime, regular sentence first position, regular sentence second position, etc) and ran a mean-centred PLS. The first PLS was with all data in category (17 participants * 6 conditions), and returned one significant latent variable (LV; p < 0.001) showing the contrast between the prime stimulus and the sentences (S1, S2), particularly the sentences in the first position (S1). This LV shows a task effect where MSE is higher at coarse scales while listening to sentences vs listening to the priming stimuli (output in First_Results.Cond_res):
![Screenshot 2024-01-15 at 2 45 09 PM](https://github.com/fabsarah/Rhythmic-Priming/assets/31863074/02147fd9-a1a9-45ad-939b-f3c593ab866f)

The input data here, averaged across electrodes to show the overall MSE curves:
![Screenshot 2024-01-12 at 4 25 04 PM](https://github.com/fabsarah/Passive-Listening/assets/31863074/d5ea4bbb-7995-4fc8-b427-ffa8ef95f838)

And at the electrode level:
![Screenshot 2024-01-12 at 4 28 32 PM](https://github.com/fabsarah/Passive-Listening/assets/31863074/cddccbed-ff1d-4823-aca9-cf0c2e0c3937)

I've projected these through the PLS results and zoomed in on the prime an sentence-first-position matrices for readability:

Next up, I ran a mean-centred PLS on just the sentences and just the primes. The sentences returned one significant LV (p = 0.028) that showed the contrast between sentences following regular and irregular primes. Some scale and localized differences here (output in First_Results.Lang_res):
![Screenshot 2024-01-15 at 2 33 12 PM](https://github.com/fabsarah/Rhythmic-Priming/assets/31863074/57322e78-386a-4ccc-aa34-0c698c50fcc4)

It looks like there's higher MSE over a group of electrodes bilaterally following *regular* primes:
![Screenshot 2024-01-15 at 2 36 22 PM](https://github.com/fabsarah/Rhythmic-Priming/assets/31863074/5a100a87-bede-48e6-8c0c-e17f3182a240)
What this shows is higher MSE at fine scales in bilateral anterior, ceneal, central-parietal, and parietal electrode sites; and higher MSE at mid and coarse scales in bilateral frontal sites during sentence perception following regular primes. 

It's a very subtle effect, here's the matrices after subtracting the irregular prime from the regular:
![Screenshot 2024-01-15 at 2 37 15 PM](https://github.com/fabsarah/Rhythmic-Priming/assets/31863074/9a78f7b3-07c1-47c6-967c-544033256463)

The mean curves are damn near identical which points to these specific locations being the driving force behind the effect.:
![Screenshot 2024-01-12 at 4 42 14 PM](https://github.com/fabsarah/Passive-Listening/assets/31863074/6814958f-cd87-403e-bb52-0a2b60e8a52b)

Finally, I ran just the prime stimuli presentations. This analysis returned one LV (p<0.001) showing higher MSE at coarser scales broadly-distributed across bilateral electrodes during irregular primes (output in First_Results.Prime_res):
![Screenshot 2024-01-15 at 11 57 22 AM](https://github.com/fabsarah/Rhythmic-Priming/assets/31863074/131babd2-f9b3-4e80-9df3-f7cd26640c6e)

The indata are here in "raw" form, projected through the PLS results to show the specific electrodes driving the effect:
![Screenshot 2024-01-15 at 12 02 14 PM](https://github.com/fabsarah/Rhythmic-Priming/assets/31863074/f9d64f01-6bc7-48c4-8f67-7578d9bbdcae)
What we have here is higher MSE at finer scales in the CPz electrode during the regular prime presentation. Overall, the patterns are quite similar, but there is a significant difference in clusters of electrodes in the left fronto-temporal and central electroder, in right anterior frontal electrodes, and in bilaretal centro-parietal, and paroeto-occipital electrodes. These electrode sites all show significantly higher MSE at coarser scales during the presentation of the irregular prime. 

And the mean MSE curves:
![Screenshot 2024-01-12 at 4 51 10 PM](https://github.com/fabsarah/Passive-Listening/assets/31863074/981225c5-0cbd-4a6c-9ec9-2573034e806d)

### So what does this tell us?
When the data are all lumped in together, the perceptual differences between the presentation of the primes vs. the sentences eats up the variance in the model. When we break it down into prime vs sentences, we see more detail. I might try sentence 1 vs sentence 2 just to see if I can get EVEN MORE detail, but first, I need to figure out which electrodes are driving the effect in the language task.

In the prime-only model, things are pretty compelling - MSE is higher at coarser scales during the irregular prime. This indicates greater brain signal complexity...which is pleasingly intuitive! When stimuli are irregular, we need to work harder to parse them. And we can see that in these results. 

