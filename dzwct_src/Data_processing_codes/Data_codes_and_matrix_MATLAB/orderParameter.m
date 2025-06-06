function [orderParamTime, orderParam, timephase] = orderParameter(groupphases)

% Author: Carmela Calabrese
% Input:
% GROUP phases (GROUPSIZE x TIMESPAN) matrix for each trial
% - phases with dimension equal to number of players(rows) x time_instants(columns)
% Output:
% - orderParamTime: degree of phase synchronization in time
% - orderParam: average degree of phase synchronization
% - q : phase in time of the phase synchronization index

[N, Nt] = size(groupphases); %,1); Nt=size(groupphases,2);
timephase = zeros(1,Nt);
orderParamTime = zeros(1,Nt);
orderParam = 0;

for j = 1 : Nt
    for k = 1 : N
        timephase(j) = timephase(j) + exp(1i*groupphases(k,j));
    end
    timephase(j) = timephase(j)/N;
    orderParamTime(j) = abs(timephase(j));
%     orderParam = orderParam + orderParamTime(j);
    timephase(j) = atan2(imag(timephase(j)),real(timephase(j))); % WHAT is the role of this HERE
end
orderParam = mean(orderParamTime); %orderParam / Nt;
end