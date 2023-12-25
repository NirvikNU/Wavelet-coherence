% Signal specs
fs = 1000;                    % Sampling frequency
Flimits = [3 100];            % Frequency band of interest in Hz
nv = 12;                      % Number of logarithmic divisions per octave of frquency 
                              % (a measure of granularity of the frequency axis, usually 12/16
                              % is good enough)
alpha = 0.05;                  % significance level

% For threshold computation, there are 2 options:
% 1) Compute coherence as in the Fourier-based approach where there is a 'trial'
%    structure in your data. Here the cross- and auto- spectra are averaged
%    across trials and then the coherence is computed. Subsequently the
%    theoretical significance level is obtained based on the number of
%    trials. For details see the article in
%    literature/trial_based_coherence.
% 2) Compute coherence of a single long data segment along with significance
%    computation. This is when you do not have any 'trial' structure
%    in your data. Here the cross- and auto- spectra are smoothed using a kernel
%    and then the coherence is computed.
%    There are several approaches to significance testing: theoretical/Monte-Carlo approach 
%    with further removal of false positives with area wise significance
%    testing (the latter part is not implemented in my code at the moment). 
%    For details see the articles in literature/classic_wavelet_coherence

%% Approach 1: This approach is similar to the Fourier-based coherence 
% Raw signals
tv = linspace(-1.5,1.5,3000); % time axis in seconds
x = rand(3000,25); % time vs. trial
y = rand(3000,25); % time vs. trial
[MsqC,SigVal,F,Coi,Phase] = WCoherence_trialAveraged(x,y,Flimits,fs,nv,alpha);

% Remove edge effects
for k = 1:size(MsqC,1)
    MsqC(k,F(k)<Coi) = NaN;
    Phase(k,F(k)<Coi) = NaN;
end

% Plot results
figure;
pcolor(tv,log2(F),MsqC); shading flat;
fvals  = [5 10 20 30 40 50 60 70 80 90];
yticks(log2(fvals));
yticklabels(fvals);
ylabel('Frequency (Hz)');
xlabel('Time (s)');
set(gca,'FontSize',20);
colormap winter; colorbar;
hold on;
ArrowDensity = [100,2]; % Density of arrows for phase indication in plot
plotPhase(gca,Phase,tv,log2(F),ArrowDensity(1),ArrowDensity(2)); 
% Create a binary matrix where values exceed the threshold
binaryMatrix = MsqC > SigVal;
contour(binaryMatrix, [1, 1], 'k'); % Contour around significant values

%% Approach 2: This approach is used clasically in wavelet coherence
% Raw signals
tv = linspace(-5,5,10000); % time axis in seconds
x = rand(1,10000); % 10 seconds of data
y = rand(1,10000); % 10 seconds of data 
[MsqC,sigvalMC,sigvalTh,F,Coi,Phase] = WCoherence_Classic(x,y,Flimits,fs,nv,10,alpha,5,6/(2*pi));

% Remove edge effects
for k = 1:size(MsqC,1)
    MsqC(k,F(k)<Coi) = NaN;
    Phase(k,F(k)<Coi) = NaN;
end

% Plot results
figure;
pcolor(tv,log2(F),MsqC); shading flat; 
fvals  = [5 10 20 30 40 50 60 70 80 90];
yticks(log2(fvals));
yticklabels(fvals);
ylabel('Frequency (Hz)');
xlabel('Time (s)');
set(gca,'FontSize',20);
colormap winter;
hold on;
ArrowDensity = [100,2]; % Density of arrows for phase indication in plot
plotPhase(gca,Phase,tv,log2(F),ArrowDensity(1),ArrowDensity(2));
% Create a binary matrix where values exceed the threshold
binaryMatrix = MsqC > sigvalMC;
contour(binaryMatrix, [1, 1], 'k'); % Contour around significant values (Monte-Carlo approach)
binaryMatrix = MsqC > sigvalTh;
contour(binaryMatrix, [1, 1], 'b'); % Contour around significant values (theoretical approach)
