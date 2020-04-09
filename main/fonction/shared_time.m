function [data1,data2,shared] = shared_time(data1,data2,shared)
% shared_time : fonction permettant de recuperer les plages de temps
% communes
data2.time_min=min(data2.time); % temps min radar
data2.time_max=max(data2.time); % temps max radar
data2.time_step=(data2.time_max-data2.time_min)/length(data2.time); % pas de temps radar
data1.time_min=min(data1.time); % temps min radar
data1.time_max=max(data1.time); % temps max radar
data1.time_step=data1.time(2)-data1.time(1); % pas de temps radar

[shared.time_0,shared.time_end]=crossed_data(data2.time_min,data2.time_max,data1.time_min,data1.time_max); % recuperation du premier temps et dernier temps de la plage commune

i_time=data1.time>=shared.time_0 & data1.time<=shared.time_end; % indice des temps du model compris dans la plage de donnee commune
shared.time=data1.time(i_time); % creation du vecteur de temps commun
end

