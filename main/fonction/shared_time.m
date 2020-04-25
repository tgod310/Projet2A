function [data1,data2,shared] = shared_time(data1,data2,shared)
    % shared_time : return common data time range 

    data1.time_min=min(data1.time); % time min data1
    data1.time_max=max(data1.time); % time max data1

    data2.time_min=min(data2.time); % time min data2
    data2.time_max=max(data2.time); % time max data2

    [shared.time_0,shared.time_end]=crossed_data(data2.time_min,data2.time_max,data1.time_min,data1.time_max); % recuperation du premier temps et dernier temps de la plage commune

    i_time=data1.time>=shared.time_0 & data1.time<=shared.time_end; % indice of time of data1 in common data range
    shared.time=data1.time(i_time); % common data time
end

