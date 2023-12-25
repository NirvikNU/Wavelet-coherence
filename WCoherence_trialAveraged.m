function [MsqC,sigval,F,Coi,Phase] = WCoherence_trialAveraged(x,y,FLimits,fs,nv,alpha)

    % INPUTS:
    % x,y       -> input and output signals (must be of the format time vs. trial)
    % FLimits   -> Frequency limits of coherence computation
    % fs        -> Sampling frequency
    % nv        -> No. of voices per octave 
    % alpha     -> desired significance level e.g., 0.95 for 95%

    % OUTPUTS:
    % MsqC      -> Magnitude squared coherence
    % sigval    -> Significance threshold 
    % F         -> Pseudo-frequencies at which MsqC was computed
    % Coi       -> Cone of influence outside which edge effects dominate
    % Phase     -> Coherence phase    

    % PART 1: Construct filter bank
        fb = cwtfilterbank(coder.const('SignalLength'), size(x,1),...
                           coder.const('Wavelet'), 'amor', coder.const('FrequencyLimits'),...
                           FLimits, coder.const('SamplingFrequency'), fs,...
                           coder.const('VoicesPerOctave'), nv);  

    % PART 2: Compute coherence
        [MsqC,F,Coi,Phase] = computeCoherence_trialAveraged(x,y,fb);

    % PART 3: Significance levels (For details see the enclosed 'literature/trial_based_coherence' folder)
        sigval = 1-alpha^(1/(size(x,2)-1));
        
end