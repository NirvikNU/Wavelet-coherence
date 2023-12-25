function [MsquaredC,f,coi,Phase] = computeCoherence_trialAveraged(x,y,fb)

    tmp = fb.wt(x(:,1));
    cwtx = nan([size(tmp),size(x,2)]);
    cwty = nan(size(cwtx));

    for i = 1:size(x,2)
        % CWT of x
        [cwtx(:,:,i),f,coi] = fb.wt(x(:,i));
        
        % CWT of y
        cwty(:,:,i) = fb.wt(y(:,i));
    end

    % Compute cross spectrum
    crossCFS = mean(cwtx.*conj(cwty),3);  

    % Compute phase
    Phase = angle(crossCFS);     

    % Compute autospectra
    cfsX = mean(abs(cwtx).^2,3);
    cfsY = mean(abs(cwty).^2,3);

    % Compute magnitude squared coherence
    MsquaredC = abs(crossCFS).^2./(cfsX.*cfsY);  

end