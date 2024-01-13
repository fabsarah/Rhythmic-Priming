# Passive-Listening
Code and notes from Passive Listening: this time with MSE!

## What has been done so far:
1. EEG Timeseries Import and multi-scale entropy (MSE) estimation (Code: 1. EEG_Import.m)
2. Running partial least squares (PLS) on the MSE matrices averaged by task (Code: 2. MARCS_MSE_PLS.m)

All results are in the Matlab file "First_Results.mat". I have a giant structure array with all of the input data as well, but it's too big for Github, hahaha

## Results so far:
### Brain MSE PLS Analyses (Code 2.)
I imported all the EEG data and broke it into epochs using the trigge information. For each participant, we have 24 sequences with three epochs: a prime (regular or irregular), sentence first position, and sentence second position. I extracted MSE fot each epoch, averaged them by prime type (e.g. regular prime, regular sentence first position, regular sentence second position, etc) and ran a mean-centred PLS. The first PLS was with all data in category (17 participants * 6 conditions), and returned one significant latent variable (LV; p < 0.001) showing the contrast between the prime stimulus and the sentences (S1, D2), particularly the sentences in the first position (S1). This LV shows a task effect where MSE is higher at coarse scales while listening to sentences vs listening to the priming stimuli (output in First_Results.Cond_res):
![Screenshot 2024-01-12 at 4 21 59 PM](https://github.com/fabsarah/Passive-Listening/assets/31863074/d74f42fa-d324-48c8-8426-17e776ef65ea)

The input data here, averaged across electrodes to show the overall MSE curves:
![Screenshot 2024-01-12 at 4 25 04 PM](https://github.com/fabsarah/Passive-Listening/assets/31863074/d5ea4bbb-7995-4fc8-b427-ffa8ef95f838)

And at the electrode level. Will investigate which electrodes are contributing most strongly here:
![Screenshot 2024-01-12 at 4 28 32 PM](https://github.com/fabsarah/Passive-Listening/assets/31863074/cddccbed-ff1d-4823-aca9-cf0c2e0c3937)

Next up, I ran a mean-centred PLS on just the sentences and just the primes. The sentences returned one significant LV (p = 0.028) that showed the contrast between sentences following regular and irregular primes. Some scale and localized differences here (output in First_Results.Lang_res):
![Screenshot 2024-01-12 at 4 39 28 PM](https://github.com/fabsarah/Passive-Listening/assets/31863074/c0be884a-857c-4e68-bbab-f7edc24fedcb)

It looks like there's higher MSE over a group of electrodes bilaterally following irregular primes (will make a mask and get us specific electrodes next week):
![Screenshot 2024-01-12 at 4 38 51 PM](https://github.com/fabsarah/Passive-Listening/assets/31863074/360c3d81-0b70-4e72-86e4-8aafacc51b2c)

And that specific locations are driving the effect. The mean curves are damn near identical:
![Screenshot 2024-01-12 at 4 42 14 PM](https://github.com/fabsarah/Passive-Listening/assets/31863074/6814958f-cd87-403e-bb52-0a2b60e8a52b)

Finally, I ran just the prime stimuli presentations. This analysis returned one LV (p<0.001) showing higher MSE at coarser scales broadly-distributed across bilateral electrodes during irregular primes (output in First_Results.Prime_res):
![Screenshot 2024-01-12 at 4 49 25 PM](https://github.com/fabsarah/Passive-Listening/assets/31863074/e25c2de9-a1b5-44fe-83bb-b14dec45cbc0)

The indata are here in "raw" form:
![Screenshot 2024-01-12 at 4 50 29 PM](https://github.com/fabsarah/Passive-Listening/assets/31863074/c8246e18-249b-416f-af30-d1c0d0f396eb)

And the mean MSE curves:
![Screenshot 2024-01-12 at 4 51 10 PM](https://github.com/fabsarah/Passive-Listening/assets/31863074/981225c5-0cbd-4a6c-9ec9-2573034e806d)

### So what does this tell us?
When the data are all lumped in together, the perceptual differences between the presentation of the primes vs. the sentences eats up the variance in the model. When we break it down into prime vs sentences, we see more detail. I might try sentence 1 vs sentence 2 just to see if I can get EVEN MORE detail, but first, I need to figure out which electrodes are driving the effect in the language task.

In the prime-only model, things are pretty compelling - MSE is higher at coarser scales during the irregular prime. This indicates greater brain signal complexity...which is pleasingly intuitive! When stimuli are irregular, we need to work harder to parse them. And we can see that in these results. 

