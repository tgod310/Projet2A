function [stat,shared] = statistic(drifter,radar,shared,stat)
%Statistics


%%% Remove NaN 
shared.i_notNaN=not(isnan(shared.delta_Vr));
to_ignore1 = isnan(radar.closer_Vr) == 1;
to_ignore2 = isnan(drifter.Vr) == 1;
to_ignore=to_ignore1+to_ignore2;

%%% Speed without NaN 


stat.vr_rad = radar.closer_Vr;
stat.vr_rad(to_ignore ~= 0)=[];
stat.vr_rad_alldrift= [stat.vr_rad_alldrift stat.vr_rad];

stat.vr_drift = drifter.Vr;
stat.vr_drift(to_ignore ~= 0)=[];
stat.vr_drift_alldrift = [stat.vr_drift_alldrift stat.vr_drift];

stat.mean_time=mean(shared.delta_T(shared.i_notNaN));
stat.mean_dist=mean(shared.delta_D(shared.i_notNaN));
stat.mean_delta_U=mean(shared.delta_Vr,'omitnan');

stat.indiv.bias = mean(stat.vr_drift) - mean(stat.vr_rad);
stat.indiv.var_radar = mean((stat.vr_rad - mean(stat.vr_rad)).^2);
stat.indiv.std_radar = sqrt(stat.indiv.var_radar);
stat.indiv.var_drifter = mean((stat.vr_drift - mean(stat.vr_drift)).^2);
stat.indiv.std_drifter = sqrt(stat.indiv.var_drifter);
stat.indiv.rms = sqrt(mean((stat.vr_rad - stat.vr_drift).^2));
stat.indiv.corr = sum( (stat.vr_rad-mean(stat.vr_rad)) .* (stat.vr_drift-mean(stat.vr_drift)) ) ...
                  ./ ( sqrt(sum((stat.vr_rad - mean(stat.vr_rad)).^2)).*sqrt(sum((stat.vr_drift - mean(stat.vr_drift)).^2)) );

stat.alldrift.bias       = mean(stat.vr_drift_alldrift) - mean(stat.vr_rad_alldrift);
stat.alldrift.var_radar   = mean((stat.vr_rad_alldrift - mean(stat.vr_rad_alldrift)).^2);
stat.alldrift.std_radar   = sqrt(stat.alldrift.var_radar);
stat.alldrift.var_drifter = mean((stat.vr_drift_alldrift - mean(stat.vr_drift_alldrift)).^2);
stat.alldrift.std_drifter = sqrt(stat.alldrift.var_drifter);
stat.alldrift.rms        = sqrt(mean((stat.vr_rad_alldrift - stat.vr_drift_alldrift).^2));
stat.alldrift.corr        = sum( (stat.vr_rad_alldrift-mean(stat.vr_rad_alldrift)) .* (stat.vr_drift_alldrift-mean(stat.vr_drift_alldrift)) ) ...
     ./ ( sqrt(sum((stat.vr_rad_alldrift - mean(stat.vr_rad_alldrift)).^2)).*sqrt(sum((stat.vr_drift_alldrift - mean(stat.vr_drift_alldrift)).^2)) );
        

end

