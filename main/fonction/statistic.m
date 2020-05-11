function [stat,shared] = statistic(drifter,data,shared,stat)
%Statistics
if length(drifter.U)>1
if data.name=='r'
%%% Remove NaN 
shared.i_notNaN=not(isnan(shared.delta_Vr));
to_ignore1 = isnan(data.closer_Vr) == 1;
to_ignore2 = isnan(drifter.Vr) == 1;
to_ignore=to_ignore1+to_ignore2;



%%% Speed without NaN 


stat.vr_rad = data.closer_Vr;
stat.vr_rad(to_ignore ~= 0)=[];
stat.vr_rad_alldrift= [stat.vr_rad_alldrift stat.vr_rad];

stat.vr_drift = drifter.Vr;
stat.vr_drift(to_ignore ~= 0)=[];
stat.vr_drift_alldrift = [stat.vr_drift_alldrift stat.vr_drift];

stat.mean_time=mean(shared.delta_T(shared.i_notNaN));
stat.mean_dist=mean(shared.delta_D(shared.i_notNaN));
stat.mean_delta_U=mean(shared.delta_Vr,'omitnan');
stat.mean_lat=mean(drifter.lat);

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

if data.name=='m'
    if length(drifter.U)>1
    %%% Remove NaN 
shared.i_notNaN=not(isnan(shared.delta_U));
shared.i_notNaN1=not(isnan(shared.delta_T));
shared.i_notNaN2=not(isnan(shared.delta_D));
to_ignore1 = isnan(data.closer_U) == 1;
to_ignore2 = isnan(drifter.U) == 1;
to_ignore=to_ignore1+to_ignore2;
    
%%% Speed without NaN 
stat.u_mod = data.closer_U;
stat.u_mod(to_ignore ~= 0)=[];
stat.u_mod_alldrift= [stat.u_mod_alldrift stat.u_mod];

stat.u_drift = drifter.U;
stat.u_drift(to_ignore ~= 0)=[];
stat.u_drift_alldrift = [stat.u_drift_alldrift stat.u_drift];

stat.mean_time=mean(shared.delta_T(shared.i_notNaN1));
stat.mean_dist=mean(shared.delta_D(shared.i_notNaN2));
stat.mean_delta_U=mean(shared.delta_U,'omitnan');
stat.mean_lat=mean(drifter.lat);    

stat.indiv.bias = mean(stat.u_drift) - mean(stat.u_mod);
stat.indiv.var_model = mean((stat.u_mod - mean(stat.u_mod)).^2);
stat.indiv.std_model = sqrt(stat.indiv.var_model);
stat.indiv.var_drifter = mean((stat.u_drift - mean(stat.u_drift)).^2);
stat.indiv.std_drifter = sqrt(stat.indiv.var_drifter);
stat.indiv.rms = sqrt(mean((stat.u_mod - stat.u_drift).^2));
stat.indiv.corr = sum( (stat.u_mod-mean(stat.u_mod)) .* (stat.u_drift-mean(stat.u_drift)) ) ...
                  ./ ( sqrt(sum((stat.u_mod - mean(stat.u_mod)).^2)).*sqrt(sum((stat.u_drift - mean(stat.u_drift)).^2)) );

stat.alldrift.bias       = mean(stat.u_drift_alldrift) - mean(stat.u_mod_alldrift);
stat.alldrift.var_model   = mean((stat.u_mod_alldrift - mean(stat.u_mod_alldrift)).^2);
stat.alldrift.std_model   = sqrt(stat.alldrift.var_model);
stat.alldrift.var_drifter = mean((stat.u_drift_alldrift - mean(stat.u_drift_alldrift)).^2);
stat.alldrift.std_drifter = sqrt(stat.alldrift.var_drifter);
stat.alldrift.rms        = sqrt(mean((stat.u_mod_alldrift - stat.u_drift_alldrift).^2));
stat.alldrift.corr        = sum( (stat.u_mod_alldrift-mean(stat.u_mod_alldrift)) .* (stat.u_drift_alldrift-mean(stat.u_drift_alldrift)) ) ...
     ./ ( sqrt(sum((stat.u_mod_alldrift - mean(stat.u_mod_alldrift)).^2)).*sqrt(sum((stat.u_drift_alldrift - mean(stat.u_drift_alldrift)).^2)) );
        
    end
end
end

