function DATE = julday2date(DATEj,time_origin)
%%% MARMAIN
%%% 2012/06/14
%%% from the julian date DATEj = DATEjulian(JJJ) since time_origin, computes 
%%% DATE.julian the julian day since the time_origin, and DATE.calendar 
%%% with format YYYY-MM-DD hh:mm:ss and DATE.radar (YYYYJJJhhmm) the date
%%% at radar format


if nargin == 1  %%% default case
    time_origin = '20100101000000';  %%% YYYYMMDDhhmmss
end

if length(time_origin) == 14                % 20100101000000 format
    YYYYo = str2double(time_origin(1:4));
    MMo   = str2double(time_origin(5:6));
    DDo   = str2double(time_origin(7:8));
    hho   = str2double(time_origin(9:10));
    mmo   = str2double(time_origin(11:12));
    sso   = str2double(time_origin(13:14));
elseif length(time_origin) == 19            % 2010-01-01 00:00:00 format
    [YYYYo MMo DDo hho mmo sso] = datevec(time_origin);
else
    error('Unrecongized format for the time origin!');
end


DATE.julian = DATEj;

DATE.calendar = datestr(DATE.julian + datenum(YYYYo,MMo,DDo,hho,mmo,sso),31);   % 31 is the numeric format for YYYY-MM-DD hh:mm:ss

DATE.time_origin=datestr(datenum(YYYYo,MMo,DDo,hho,mmo,sso),31);

for t = 1 : length(DATEj)
    
    YYYY = str2double(DATE.calendar(t,1:4));
    %%% ATTENTION !!! +1 pour obtenir la bonne date RADAR!!!
    JJJ = num2str( floor( DATE.julian(t)+1 - (datenum(YYYY,01,01,0,0,0) - datenum(YYYYo,MMo,DDo,hho,mmo,sso)) ) );
    
    if length(JJJ) == 1; JJJ = ['00' JJJ]; end
    if length(JJJ) == 2; JJJ = ['0' JJJ];  end
    
    DATE.radar(t,:) = ...
        [DATE.calendar(t,1:4) num2str(JJJ) DATE.calendar(t,12:13) DATE.calendar(t,15:16)];
    
end
