function [phi,arg,sigma] = co_fbtrT(theta,ngrid)

% Fourier series based transformation protophase theta --> phase phi 
% for one oscillator (when weakly coupled to another one), with
% optimization according to Tenreiro, Nonparametric Stat,v 23, 533, 2011
%
% Input parameters:  
% theta is the protophase
% ngrid is the grid size for computation of sigma 
%
% Output:  phi = co_fbtrT(...) if only the phase is required.
% Output:  [phi,arg,sigma] = co_fbtrT(...) if sigma is required.
% Sigma can be plotted as plot(arg,sigma); sigma is computed on the grid.
% Default grid size is 50.

nfft = 1000;          % Maximal number of Fourier coefficients
Spl = zeros(nfft,1);  % Fourier coefficients 1,...,nfft
Hl = zeros(nfft,1);   % Tenreiro function to be minimized

IN = find(diff(mod(theta,2*pi)) < 0);     % correction for short time series
npt = length(theta(IN(1):IN(end)));       % only full periods are used

S = 0; c = double(npt+1)/double(npt-1); % ?

% computing Fourier coefficients
for k=1:nfft        
    Spl(k) = sum(exp(-1i*k*theta(IN(1):IN(end))))/npt;
    S = S+Spl(k)*conj(Spl(k))-1./double(npt);
    Hl(k) = k/npt-c*S;   % Tenreiro function
end
[~,indopt] = min(Hl);

% Transformation theta --> phi
phi = theta;     
if nargout == 3  % sigma is computed along with the transformation
  if nargin < 2, ngrid = 50; end 
  arg = (0 : (ngrid-1))';
  arg = arg*pi*2/(ngrid-1);
%   arg = arg';
  sigma = ones(ngrid,1); % HUM It begins with 1 value 
  for k=1:indopt
      sigma = sigma + 2*real(Spl(k)*exp(1i*k*arg));
      phi = phi+2*imag(Spl(k)*(exp(1i*k*theta)-1)/k);
  end
else
  for k=1:indopt
      phi = phi+2*imag(Spl(k)*(exp(1i*k*theta)-1)/k);
  end
end

end