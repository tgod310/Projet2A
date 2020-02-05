function DATE = julrad2date(DATEr,time_origin)
%%% MARMAIN
%%% 2012/05/25
%%% from the radar date DATEr = DATE.radar (YYYYJJJhhmm), computes 
%%% DATE.julian the julian day since the time_origin, and DATE.calendar 
%%% with format YYYY-MM-DD hh:mm:ss
%%%########################################################################

if nargin == 1  %%% default case
    time_origin = '20100101000000';  %%% YYYYMMDDhhmmss
end
length(time_origin)

if length(time_origin) == 14                % 20100101000000 format
    YYYYo = str2double(time_origin(1:4));
    MMo   = str2double(time_origin(5:6));
    DDo   = str2double(time_origin(7:8));
    hho   = str2double(time_origin(9:10));
    mmo   = str2double(time_origin(11:12));
    sso   = str2double(time_origin(13:14));
elseif length(time_origin) == 18            % 2010-01-01 00:00:00 format
    [YYYYo MMo DDo hho mmo sso] = datevec(time_origin);
else
    error('Unrecongized format for the time origin!');
end

DATE.radar = DATEr;

for t=1:size(DATE.radar,1)
   
YYYY = str2double(DATEr(t,1:4)); 
JJJ  = str2double(DATEr(t,5:7));
hh   = str2double(DATEr(t,8:9));
mm   = str2double(DATEr(t,10:11));


DATE.julian(t,:) = JJJ + hh/24 + (mm-1)/1440 + ...
                datenum(YYYY,01,01,0,0,0) - ...
                datenum(YYYYo,MMo,DDo,hho,mmo,sso)-1;

DATE.calendar(t,:) = datestr(DATE.julian(t,:) + datenum(YYYYo,MMo,DDo,hho,mmo,sso),31); % 31 is the numeric format for YYYY-MM-DD hh:mm:ss

end

DATE.time_origin=datestr(datenum(YYYYo,MMo,DDo,hho,mmo,sso),31);


end