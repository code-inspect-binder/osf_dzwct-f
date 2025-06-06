function [theta,ampl] = co_hilbproto(x,fignum,x0,y0,ntail)

% Ho cambiato: al posto di farmi restituire minampl, mi faccio restituire
% le ampiezze istante per istante
% This function computes the protophase via the Hilbert transform
% The output is truncated from both ends to avoid boundary effects
% Form of call: [theta,minampl] = co_hilbphase(x,fignum,x0,y0,ntail)
%               [theta,minampl] = co_hilbphase(x,fignum,x0,y0)
%               [theta,minampl] = co_hilbphase(x,fignum,x0)
%               [theta,minampl] = co_hilbphase(x,fignum)
%               [theta,minampl] = co_hilbphase(x)
%
% Input parameters:
% x - scalar timeserie
% x0,y0 - origin coordinates (default x0=0, y0=0)
% ntail - number of points at the ends to be cut off (default ntail = 0)
% Output parameters:
% theta - protophase in [0,2*pi]
% ampl - amplitude of signal % is the minimal instantaneous amplitude

if nargin < 5, ntail = 0; end
if nargin < 4, y0 = 0; end
if nargin < 3, x0 = 0; end

ht = hilbert(x); ht = ht(ntail+1:end-ntail);
ht = ht-mean(ht);  % subtracting the mean value
ht = ht-x0-1i*y0;
theta = mod(angle(ht),2*pi);  % phase is in 0,2pi interval
% theta = theta(:);         % to ensure that theta is a column vector

ampl = abs(ht); 
minampl = min(ampl); avampl = mean(ampl);

if minampl < avampl/20
    disp([minampl, avampl, avampl/20])
    disp('WARNING: the phase may be not well-defined!')
end

if (nargin > 1) && (fignum > 0)  % plot to check whether the origin is evolved
    figure(fignum), clf
    ax = 1 : length(ht); [nn,dd] = size(ht);
    if nn > dd, ax = ax'; end
    plot(ax,ht,'-.k',x0,y0,'ro');    
    xlabel('signal'); ylabel('HT(signal)'); title('Hilbert embedding');
    axis square; grid on    
end