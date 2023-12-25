# Wavelet-coherence
Wavelet coherence with significance testing

This repo contains functions for wavelet coherence analyses. Refer to demo.m for details.
Included is also a literature folder for in-depth information on significance testing.

For threshold computation, there are 2 options:
1) Compute coherence as in the Fourier-based approach where there is a 'trial' structure in your data. Here the cross- and auto- spectra are averaged across trials and then the coherence is computed. Subsequently the theoretical significance level is obtained based on the number of trials. For details see the article in literature/trial_based_coherence.
2) Compute coherence of a single long data segment along with significancecomputation. This is when you do not have any 'trial' structure in your data. Here the cross- and auto- spectra are smoothed using a kernel and then the coherence is computed. There are several approaches to significance testing: theoretical/Monte-Carlo approach with further removal of false positives with area wise significance testing (the latter part is not implemented in my code at the moment). For details see the articles in literature/classic_wavelet_coherence
