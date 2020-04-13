function [model,drifter,shared] = shared_time_model_drifter(model,drifter,shared)
% shared_time : fonction permettant de recuperer les plages de temps
% communes
drifter.time_min=min(drifter.time); % temps min drifter
drifter.time_max=max(drifter.time); % temps max drifter
drifter.time_step=(drifter.time_max-drifter.time_min)/length(drifter.time); % pas de temps drifter

model.time_min=min(model.time); % temps min model
model.time_max=max(model.time); % temps max model
model.time_step=model.time(2)-model.time(1); % pas de temps model

[shared.time_0,shared.time_end]=crossed_data_model_drifter(drifter.time_min,drifter.time_max,model.time_min,model.time_max); % recuperation du premier temps et dernier temps de la plage commune

i_time=model.time>=shared.time_0 & model.time<=shared.time_end;
i_time1=drifter.time>=shared.time_0 & drifter.time<=shared.time_end;% indice des temps du model compris dans la plage de donnee commune
shared.time_model=model.time(i_time); % creation du vecteur de temps commun
shared.time_drifter=drifter.time(i_time1);
end

