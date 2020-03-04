function [model,radar,shared] = shared_time(model,radar,shared)
% shared_time : fonction permettant de recuperer les plages de temps
% communes
radar.time_min=min(radar.time); % temps min radar
radar.time_max=max(radar.time); % temps max radar
radar.time_step=(radar.time_max-radar.time_min)/length(radar.time); % pas de temps radar
model.time_min=min(model.time); % temps min radar
model.time_max=max(model.time); % temps max radar
model.time_step=model.time(2)-model.time(1); % pas de temps radar

[shared.time_0,shared.time_end]=crossed_data(radar.time_min,radar.time_max,model.time_min,model.time_max); % recuperation du premier temps et dernier temps de la plage commune

i_time=model.time>=shared.time_0 & model.time<=shared.time_end; % indice des temps du model compris dans la plage de donnee commune
shared.time=model.time(i_time); % creation du vecteur de temps commun
end

