function [MsquaredC,f,coi,Phase] = computeCoherence_Classic(x,y,fb)
    % Recast x and y to appropriate forms
    x = x(:); y = y(:);

    % CWT of x
    [cwtx,f,coi] = fb.wt(x);
    
    % CWT of y
    cwty = fb.wt(y);

    % Compute cross spectrum
    crossCFS = cwtx.*conj(cwty);  

    % Compute phase
    Phase = unwrap(angle(crossCFS));    

    % Number of scales to smooth
    ns = min(floor(numel(fb.Scales)/2),fb.VoicesPerOctave);   

    % Perform smoothing
    cfsX = MysmoothCFS(abs(cwtx).^2,fb.Scales,ns);
    cfsY = MysmoothCFS(abs(cwty).^2,fb.Scales,ns);
    crossCFS = MysmoothCFS(crossCFS,fb.Scales,ns);

    % Compute magnitude squared coherence
    MsquaredC = abs(crossCFS).^2./(cfsX.*cfsY);  

end
