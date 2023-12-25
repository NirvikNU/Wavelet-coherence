function [MsqC,sigvalMC,sigvalTh,F,Coi,Phase] = WCoherence_Classic(x,y,FLimits,fs,nv,MCsize,alpha,kappa,fc)

    % INPUTS:
    % x,y       -> input and output signals
    % FLimits   -> Frequency limits of coherence computation
    % fs        -> Sampling frequency
    % nv        -> No. of voices per octave 
    % MCsize    -> Size of Monte Carlo samples for significance computation
    % alpha     -> desired significance level e.g., 0.95 for 95%
    % kappa     -> decorrelation length (usually from 5-20)
    % fc        -> center frequency (e.g., for morlet = 6/(2*pi))

    % OUTPUTS:
    % MsqC      -> Magnitude squared coherence
    % sigvalMC  -> Significant coherence at desired alpha level per scale (Monte-Carlo version)
    % sigvalTH  -> Significant coherence at desired alpha level per scale (Theroretical version)
    % F         -> Pseudo-frequencies at which MsqC was computed
    % Coi       -> Cone of influence outside which edge effects dominate
    % Phase     -> Coherence phase

    % PART 1: Construct filter bank
        fb = cwtfilterbank(coder.const('SignalLength'), length(x),...
                           coder.const('Wavelet'), 'amor', coder.const('FrequencyLimits'),...
                           FLimits, coder.const('SamplingFrequency'), fs,...
                           coder.const('VoicesPerOctave'), nv);  

    % PART 2: Compute coherence
            [MsqC,F,Coi,Phase] = computeCoherence_Classic(x,y,fb);

    % PART 3: Significance levels (For details see: D. Maraun and J. Kurths, Nonlin. Proc.
    % Geophys. 11: 505-514, 2004 in the enclosed 'literature/classic_wavelet_coherence' folder)
        % Approach 1: Compute point-wise significance levels (from theorectical distributions)
            sigvalTh = tanh(norminv(1-alpha) * sqrt(2 * sqrt(log(kappa)) * (fc./F) * fs/length(x))).^2;
    
    
        % Approach 2: Compute significance levels (Monte Carlo simulation)
            % a) Compute the AR(1) coefficients for x and y
            arX = arburg(x,1); % AR1 for X 
            arY = arburg(y,1); % AR1 for Y

            % b) Generate rednoise
            rng default; % for repeatability
            noiseV = 1; % noise variance
            redX = filter(1,arX,noiseV * randn(length(x),MCsize));
            redY = filter(1,arY,noiseV * randn(length(y),MCsize));
            SurrogateMsqC = zeros(length(F),length(x),MCsize);
    
            % c) Compute coherence for surrogate data and store coherence values for each frequency
            for i = 1:MCsize
                [SurrogateMsqC(:,:,i),~,~] = computeCoherence_Classic(redX(:,i),redY(:,i),fb);
            end
    
            % d) Obtain the alpha significance level Rsq values for each
            % frequency and time point
            sigvalMC = prctile(SurrogateMsqC,(1-alpha)*100,3);
        
end