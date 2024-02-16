# Rhythmic Priming
Code and notes from Rhythmic Priming: this time with MSE!

## What has been done so far:
1. EEG Timeseries Import and multi-scale entropy (MSE) estimation (Code: 1. EEG_Import.m)
2. Running partial least squares (PLS) on the MSE matrices averaged by task (Code: 2. MARCS_MSE_PLS.m)
3. MSE estimation on the stimulus files (Code: 3. Stimuli_MSE.m)
4. Computed Procrustes distance (more on that later) between the brain MSE and stimuli MSE (Code: 4.

All results are in the Matlab file "First_Results.mat". I have a giant structure array with all of the input data as well, but it's too big for Github, hahaha

## Results so far:
### Brain MSE PLS Analyses (Code 2.)
In the first analysis, I extracted multiscale entropy (MSE) on the clean time series data. MSE is a way of describing complexity in a time series where the optimally relevant timescale is unknown/ambiguous. It is an extension of sample entropy that examines excerpts from the time series at increasingly coarse lengths against the remainder of the series and can be run on any scalar time series. More information on the theory of MSE and its application to EEG is here and a paper from our lab applying MSE to EEG data and music stimuli is here. 

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

The effect is weaker here (which is normal for this type of analysis, so nothing to worry about there). I didn't threshold the LV plot as much as I did for the first LV, so we should interpret this one cautiously. The effect shows higher MSE at finer scales at left anterior, temporal, and parietal electrode sites, and right fronto-central, centro-parieral, and parietal sites. MSE is higher at moderate-to-coarse scales in left fronto central and temporo-parietal electrode sites and at right fronto-central and parietal sites:
![Screenshot 2024-01-19 at 11 17 21 AM](https://github.com/fabsarah/Rhythmic-Priming/assets/31863074/07d3a2a0-a6ed-4dd4-a294-a2d4e95fa36a)

This can be seen overall in the MSE curves (neat!):
![Screenshot 2024-01-19 at 11 24 29 AM](https://github.com/fabsarah/Rhythmic-Priming/assets/31863074/50eb8774-aafb-448e-99f3-c621ad9ca37b)
What this shows is that both sentence presentations follow broad similar MSE profiles, the difference in in the peaks. MSE peakes higher at finer scales for second position sentences (can discuss why this is...maybe brain is already primed from the prime (lol) and the first sentence), and shows higher MSE at coarse scales for sentences following regular primes. This could be a case of irregular primes getting "stuck" in local processing without progressing to global processing the same way sentences following a regular prime do. Extremely hypothetical, but let's discuss further...

Finally, I ran just the prime stimuli presentations. This analysis did not return any significant LVs.

### So what does this tell us?
When the data are all lumped in together, the perceptual differences between the presentation of the primes vs. the sentences eats up the variance in the model. When we break it down into prime vs sentences, we see more detail. 

### Brain and Stimulus MSE PLS Analyses (Code3 and 4)
I imported the stimuli .wav files into Matlab and extracted the upper amplitude envelope. I resampled the envelope files to 250 to match the sampling rate of the EEG data and computed MSE for each of the rhythmic primes and each of the sentences. It looks like this averaged down:
![Screenshot 2024-02-16 at 2 24 19 PM](https://github.com/fabsarah/Rhythmic-Priming/assets/31863074/91df6453-e041-4738-889d-e991b5151488)

The sentence excerpts had higher MSE overall - the recordings are a little more “live” and the accompanying noise might be coming through here. This isn’t an issue, though, since we’re computing Procrustes distance!

What is Procrustes distance? Roughly, it’s a way of calculating how (dis)similar two shapes are. It returns a single number that describes the dissimilarities between two numerical series’ in Euclidean (geometric) space. Lower numbers = less dissimilarity (two identical shapes would have a Procrustes distance of 0), higher numbers = more dissimilarity. The advantage here is that, like correlation, we have a scale-agnostic way of comparing two series’; but unlike correlation, Procrustes will manipulate the series’ (rotation, mirroring, etc) meaning we don’t have to worry about lag between the peaks. More information is here on the Mathworks site with some nice examples. We don’t get a significance value using Procrustes, rather, I assembled new matrices using the Procrustes values for significance testing using PLS.

SO. I compared each electrodes’ MSE curve to the relevant stimulus’ MSE curve, getting a Procrustes distance value. I averaged those down for each participant (average Procrustes distance for regular primes, sentences following regular primes in first and second position, irregular primes, and sentences following irregular primes in first and second position) and ran PLS analyses on them consistent with the MSE PLSes above. LET’S GO. 

The first analysis was including everything in the PLS (primes and sentences). There was one significant LV showing the contrast between primes and sentences:
![Screenshot 2024-02-16 at 2 24 58 PM](https://github.com/fabsarah/Rhythmic-Priming/assets/31863074/f28ab981-1d9d-49c9-b642-794d9216b111)

In this LV, Procrustes distance is greater in CP5, O1, Oz, CP4, P6, and O2 during language compared to rhythmic priming, and Procrustes distance is greater in CPz during rhythmic priming compared to language:
![Screenshot 2024-02-16 at 2 25 33 PM](https://github.com/fabsarah/Rhythmic-Priming/assets/31863074/0fa99d76-a276-4236-a5a9-7168ac79ab42)

Next, I looked at the sentences comparing the averaged Procrustes values per electrode per participant across all four categories (first or second position, regular or irregular prime). The one significant latent variable showed a contrast between second position sentences following regular primes and sentences following irregular primes in both positions:
![Screenshot 2024-02-16 at 2 25 49 PM](https://github.com/fabsarah/Rhythmic-Priming/assets/31863074/c597bd1d-caf4-420f-89a9-d07a6376d136)

The differences are in bilateral frontal and fronto-central electrodes, and in left-lateral central and parietal electrodes. These corresponded to greater Procrustes distance (“farther away” or more dissimilarity) between the stimulus and brain MSE curves when listening to sentences in the second position following a regular prime. Lower Procrustes distance (more similarity) was observed between second position sentences following regular primes and stimulus MSE in the CPz electrode:
![Screenshot 2024-02-16 at 2 26 06 PM](https://github.com/fabsarah/Rhythmic-Priming/assets/31863074/57f0fb5e-689c-4bc6-97c3-3fe1e88e68d1)

While the pattern is VERY similar for all sentence types, the effect is more pronounced (statistically significantly!) in the second position sentences following regular primes. 

This pattern held up when the sentence positions were combined:
![Screenshot 2024-02-16 at 2 26 21 PM](https://github.com/fabsarah/Rhythmic-Priming/assets/31863074/55742fbe-b89a-4921-a478-035b40a8566b)

Again, the sentences following regular primes are consistently more dissimilar to the stimuli MSE curves compared to the sentences following irregular primes:
![Screenshot 2024-02-16 at 2 26 46 PM](https://github.com/fabsarah/Rhythmic-Priming/assets/31863074/fe672816-98ec-4f50-9d68-346794c29e92)

Finally, I ran a PLS on regular vs irregular primes. The analysis was non-significant!

### So what does this tell us?
When the data are all modelled together, electrodes in bilateral CP and occipital electrodes (with bonus Oz and P6) more closely match the stimulus MSE when listening to the prime vs listening to the sentences. This does make sense - there’s more to pay attention to in the language, so the brain might not be as adept at tracking the signal as with the more repetitive prime excerpts. CPz was the one reversed electrode. MSE in this electrode was more similar to sentence excerpt MSE compared to rhythm excerpt MSE. Could be a modality-specific effect, could be an artifact…we can mull it over!

When we separate out the sentence excerpts, we see the contrast between sentences in position 2 following a regular prime vs sentences in both positions following an irregular prime. Sentences in the first position following regular primes don’t factor into this LV. This effect is more anterior than in the first model, and in the second position sentences following regular primes, the brain MSE is farther away, or more dissimilar, from the stimulus MSE. The lone exception is our pal the CPz electrode, which is more similar to the stimulus MSE during second position sentences following a regular prime.

This, to me, suggests something like a predictability/novelty/attention effect….a “decoupling” between brain and stimulus in the fronto-central and left parietal electrodes following a regular prime for the second position sentences. The first position sentences didn’t register here, possibly indicating the novelty/attention of a new sound (“I am going to listen to this new stimulus”) that peters out when the second-position sentence arrives. Following irregular primes, however, it could be that attention is maintained/the brain more closely tracks the stimulus for continued irregularities. 

