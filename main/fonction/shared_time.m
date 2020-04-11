function [data1,data2,shared] = shared_time(data1,data2,shared)
% shared_time : fonction permettant de recuperer les plages de temps
% communes
data1.time_min=min(data1.time); % temps min data1
data1.time_max=max(data1.time); % temps max data1

data2.time_min=min(data2.time); % temps min data2
data2.time_max=max(data2.time); % temps max data2

[shared.time_0,shared.time_end]=crossed_data(data2.time_min,data2.time_max,data1.time_min,data1.time_max); % recuperation du premier temps et dernier temps de la plage commune

i_time=data1.time>=shared.time_0 & data1.time<=shared.time_end; % indice des temps de data1 compris dans la plage de donnee commune
shared.time=data1.time(i_time); % creation du vecteur de temps commun
end

