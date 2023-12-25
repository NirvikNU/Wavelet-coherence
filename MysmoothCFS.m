function cfs = MysmoothCFS(cfs,scales,ns)
N = size(cfs,2);
npad = 2.^nextpow2(N);
omega = 1:fix(npad/2);
omega = omega.*((2*pi)/npad);
omega = [0.0, omega, -omega(fix((npad-1)/2):-1:1)];
cfsDFT = fft(cfs,npad,2);
[~,c1] = size(scales);
[~,c2] = size(omega);
m = repmat(omega,c1,1);
n = repmat(scales',1,c2);
Fmat = exp(-0.5*((m.*n).^2));

% Perform symmetric IFFT if we can
if ~isreal(cfs) || ~isreal(Fmat) || ~isempty(coder.target)
    smooth = ifft(Fmat.*cfsDFT,[],2);
else
    smooth = ifft(Fmat.*cfsDFT,[],2,'symmetric');
end

cfs = smooth(:,1:N);

% Convolve the coefficients with a moving average smoothing filter across
% scales
H = 1/ns*ones(ns,1);
cfs = conv2(cfs,H,'same');
