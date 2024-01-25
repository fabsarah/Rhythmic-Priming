# Rhythmic Priming
Code and notes from Rhythmic Priming: this time with MSE!

## What has been done so far:
1. EEG Timeseries Import and multi-scale entropy (MSE) estimation (Code: 1. EEG_Import.m)
2. Running partial least squares (PLS) on the MSE matrices averaged by task (Code: 2. MARCS_MSE_PLS.m)

All results are in the Matlab file "First_Results.mat". I have a giant structure array with all of the input data as well, but it's too big for Github, hahaha

## Results so far:
### Brain MSE PLS Analyses (Code 2.)
I imported all the EEG data and broke it into epochs using the trigger information. For each participant, we have 24 sequences with three epochs: a prime (regular or irregular), sentence first position, and sentence second position. I extracted MSE for each epoch, averaged them by prime type (e.g. regular prime, regular sentence first position, regular sentence second position, etc) and ran a mean-centred PLS. The first PLS was with all data in category (17 participants * 6 conditions), and returned one significant latent variable (LV; p < 0.001) showing the contrast between the prime stimulus and the sentences (S1, S2), particularly the sentences in the first position (S1). This LV shows a task effect where MSE is higher at coarse scales while listening to sentences vs listening to the priming stimuli (output in First_Results.Cond_res):
![Screenshot 2024-01-15 at 2 45 09 PM](https://github.com/fabsarah/Rhythmic-Priming/assets/31863074/02147fd9-a1a9-45ad-939b-f3c593ab866f)

The input data here, averaged across electrodes to show the overall MSE curves:
![Screenshot 2024-01-19 at 2 09 45 PM](https://github.com/fabsarah/Rhythmic-Priming/assets/31863074/a4fea228-43bf-429d-83f7-4f368425b9a1)


And at the electrode level:
![Screenshot 2024-01-12 at 4 28 32 PM](https://github.com/fabsarah/Passive-Listening/assets/31863074/cddccbed-ff1d-4823-aca9-cf0c2e0c3937)

I've projected these through the PLS results and zoomed in on the regular prime an sentence-first-position matrices for readability:
![Screenshot 2024-01-15 at 3 24 34 PM](https://github.com/fabsarah/Rhythmic-Priming/assets/31863074/0b8e8b46-25ad-4bed-befc-9aac19b2004f)
What we see here is greater MSE at fine scales in the prime condition at the CPz electrode site, and broadly higher MSE at coarse scales at bilateral fronto-temporal (though moreso on the left), temporal, centro-parietal, parietal, and occipital electrode sites in the first-position sentence condition. The effect is a bit difficult to see in the figure, so I subtracted the sentence matrix from the prime matrix:
![Screenshot 2024-01-15 at 3 28 19 PM](https://github.com/fabsarah/Rhythmic-Priming/assets/31863074/76426b94-19a6-4c50-88c8-256ddd1e64e6)

Next up, I ran a mean-centred PLS on just the sentences and just the primes. The sentences returned one significant LV (p = 0.028) that showed the contrast between sentences following regular and irregular primes. Some scale and localized differences here (output in First_Results.Lang_res):
![Screenshot 2024-01-15 at 2 33 12 PM](https://github.com/fabsarah/Rhythmic-Priming/assets/31863074/57322e78-386a-4ccc-aa34-0c698c50fcc4)

It looks like there's higher MSE over a group of electrodes bilaterally following *regular* primes:

What this shows is higher MSE at fine scales in bilateral anterior, central, central-parietal, and parietal electrode sites; and higher MSE at mid and coarse scales in bilateral frontal sites during sentence perception following regular primes. 
![Screenshot 2024-01-25 at 11 49 45 AM](https://github.com/fabsarah/Rhythmic-Priming/assets/31863074/bd61a773-7fb2-4d24-9bb5-f764df43842d)

It's a very subtle effect, here's the matrices after subtracting the irregular prime from the regular:
![Screenshot 2024-01-15 at 2 37 15 PM](https://github.com/fabsarah/Rhythmic-Priming/assets/31863074/9a78f7b3-07c1-47c6-967c-544033256463)

The mean curves are damn near identical which points to these specific locations being the driving force behind the effect.:
![Screenshot 2024-01-12 at 4 42 14 PM](https://github.com/fabsarah/Passive-Listening/assets/31863074/6814958f-cd87-403e-bb52-0a2b60e8a52b)

For extra looking at-ed-ness, I ran the sentences separated into first and second position divided up by their prime condition. We have two significant LVs (p<0.01 and p = 0.02 respectively). The first shows the contrast between sentences in first position (S1) vs sentences in the second position (S2):
![Screenshot 2024-01-19 at 11 23 11 AM](https://github.com/fabsarah/Rhythmic-Priming/assets/31863074/418fc5a3-7b86-4739-853b-abaa49121e11)

This effect is driven by higher MSE values at finer scales in S2 across select electrodes at frontal, central, and parieto-occipital sites bilaterally:
![Screenshot 2024-01-19 at 11 10 05 AM](https://github.com/fabsarah/Rhythmic-Priming/assets/31863074/58c943f7-c113-4904-ad6e-9f18dd7caf4a)

While the second shows the contrast between regular and irregular primes:
![Screenshot 2024-01-19 at 11 22 29 AM](https://github.com/fabsarah/Rhythmic-Priming/assets/31863074/205d92e9-fd92-452e-85fd-3da87ba9e026)

The effect is weaker here (which is normal for this type of analysis, so nothing to worry about there). I didn't threshold the LV plot as much as I did for the first LV, so we should interpret this one cautiously. The effect shows higher MSE at left anterior, temporal, and parietal electrode sites, and right fronto-central, centro-parieral, and parietal sites. MSE is higher at moderate-to-coarse scales in left fronto central and temporo-parietal electrode sites and at right fronto-central and parietal sites:
![Screenshot 2024-01-19 at 11 17 21 AM](https://github.com/fabsarah/Rhythmic-Priming/assets/31863074/07d3a2a0-a6ed-4dd4-a294-a2d4e95fa36a)

This can be seen overall in the MSE curves (neat!):
![Screenshot 2024-01-19 at 11 24 29 AM](https://github.com/fabsarah/Rhythmic-Priming/assets/31863074/50eb8774-aafb-448e-99f3-c621ad9ca37b)
What this shows is that both sentence presentations follow broad similar MSE profiles, the difference in in the peaks. MSE peakes higher at finer scales for second position sentences (can discuss why this is...maybe brain is already primed from the prime (lol) and the first sentence), and shows higher MSE at coarse scales for sentences following regular primes. This could be a case of irregular primes getting "stuck" in local processing without progressing to global processing the same way sentences following a regular prime do. Extremely hypothetical, but let's discuss further...

Finally, I ran just the prime stimuli presentations. This analysis returned one LV (p<0.001) showing higher MSE at coarser scales broadly-distributed across bilateral electrodes during irregular primes (output in First_Results.Prime_res):

![Screenshot 2024-01-15 at 11 57 22 AM](https://github.com/fabsarah/Rhythmic-Priming/assets/31863074/131babd2-f9b3-4e80-9df3-f7cd26640c6e)

The indata are here in "raw" form, projected through the PLS results to show the specific electrodes driving the effect:
![Screenshot 2024-01-15 at 12 02 14 PM](https://github.com/fabsarah/Rhythmic-Priming/assets/31863074/f9d64f01-6bc7-48c4-8f67-7578d9bbdcae)
What we have here is higher MSE at finer scales in the CPz electrode during the regular prime presentation. Overall, the patterns are quite similar, but there is a significant difference in clusters of electrodes in the left fronto-temporal and central electroder, in right anterior frontal electrodes, and in bilaretal centro-parietal, and paroeto-occipital electrodes. These electrode sites all show significantly higher MSE at coarser scales during the presentation of the irregular prime. 

And the mean MSE curves:
![Screenshot 2024-01-12 at 4 51 10 PM](https://github.com/fabsarah/Passive-Listening/assets/31863074/981225c5-0cbd-4a6c-9ec9-2573034e806d)

### So what does this tell us?
When the data are all lumped in together, the perceptual differences between the presentation of the primes vs. the sentences eats up the variance in the model. When we break it down into prime vs sentences, we see more detail. 

In the prime-only model, things are pretty compelling - MSE is higher at coarser scales during the irregular prime. This indicates greater brain signal complexity...which is pleasingly intuitive! When stimuli are irregular, we need to work harder to parse them. And we can see that in these results. 
