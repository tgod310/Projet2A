function [model,radar] = interpolation(model,radar,shared)
% interp : fonction d'interpolation sur l'espace du model et moyenne
% journaliere du radar

%% Interpolation spatiale du model
for i=1:length(model.time)
    model.interp_U(:,:,i)=interp2(model.lat,model.lon,model.U(:,:,1,i),shared.lat,shared.lon,'cubic'); % interpolation de U
    model.interp_V(:,:,i)=interp2(model.lat,model.lon,model.V(:,:,1,i),shared.lat,shared.lon,'cubic'); % interpolation de V
end

%% Moyenne journaliere du radar
s=length(shared.time); % nombre de jours etudiers
for i=1:s
    i_min=find(radar.time>=floor(shared.time(i)), 1 ); % debut du jour etudie
    i_max=find(radar.time<=ceil(shared.time(i)), 1, 'last' ); % fin du jour etudie
    radar.interp_Vr(:,:,i)=mean(radar.Vr(:,:,i_min:i_max),3,'omitnan'); % calcul de la moyenne de la vitesse du radar sur le jour etudie
end
end