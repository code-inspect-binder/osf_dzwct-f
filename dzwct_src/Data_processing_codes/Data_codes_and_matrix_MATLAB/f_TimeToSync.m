function TTS = f_TimeToSync(opmt, synclevel, UT, ind_delay) % Period, NumbPer, level,sampFreq)

% Author: CC & SJ
% Input:
% opmt - orderParamTime: degree of phase synchronization in time
% thrlevel - the min value of sync level (see GLOBAL)
% UT - unique TIMES of signal after interpolation
% USES
% Parameters.TypicalCycleDuration = 1.5; % seconds
% Parameters.NumbCyclesinSync = 3; % significant nb. of cycles group is able to keep in sync
% % - Period = typical period of the oscillation
% % - NumbPer= minimum amount of period required to define synchronization
% % - level= level of synchronization detected with LevelR.m (it does not
% %          apply to trials 'Not in sync')
% % - sampFreq= sampling frequency of the signal;
%
% Output
% TTS: time to synchronization (default Inf) the first time instant s.t.
% 1. OrderParameters is >= thrlevel
% 2. It stays >= thrlevel for a significant duration

GLOBAL_CHRONOS;

NCS = Parameters.NumbCyclesinSync;
TCD = Parameters.TypicalCycleDuration;
% Significant number of samples to be in sync
MinNbofSamplesInSync = round(NCS * TCD * TRIALFREQUENCY);

thrlevel = min(synclevel);
TTS = Inf; % when not possible to define TTS, it is equal to infinity
if thrlevel < eps, disp('Incompatible level'), return, end

% Detect the first instant :
% 1. OrderParameters is >= threshold
% 2. It stays >= threshold for MinNbofSamplesInSync - a significant duration
% if ~isempty(ind_delay)
%     opmt = opmt(ind_delay : end);
% end
T = length(opmt); 
for k = 1 : (T-MinNbofSamplesInSync)    
    if (opmt(k) >= thrlevel)
        IX = sum(opmt(k:(k+MinNbofSamplesInSync-1)) >= thrlevel);
        if IX == MinNbofSamplesInSync
            TTS = UT(k); break
        end
    end
end