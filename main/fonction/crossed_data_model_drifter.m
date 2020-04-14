function [data_0,data_end] = crossed_data_model_drifter(data1_min,data1_max,data2_min,data2_max)
%crée une plage commune de données
if data1_min > data2_max || data1_max < data2_min
    disp("Les donnees a comparer n'ont pas de plages communes");
    data_0=0;
    data_end=1;
elseif data1_max > data2_min && data1_max < data2_max
    data_0=max(data1_min,data2_min);
    data_end=data1_max;
elseif data1_max > data2_min && data1_max > data2_max 
    data_0=max(data2_min,data1_min);
    data_end=data2_max;
end
end
