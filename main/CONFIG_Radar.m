%% File of configuration for radar constants

if type_RADAR=='PEY'
% PEY position
Const.Radar_type='PEY';
Const.lon_rx      = 5.861066;  % RX longitude [decimal deg]
Const.lat_rx      = 43.063078; % RX latitude  [decimal deg]
Const.lon_tx      = 5.861066;  % TX longitude [decimal deg]
Const.lat_tx      = 43.063078; % TX latitude  [decimal deg]
Const.lon0        = 5.861066;  % Origin of the radial grid, longitude [decimal deg]
Const.lat0        = 43.063078; % Origin of the radial grid, latitude  [decimal deg]
Const.mono        =1;          % Monostatique Radar

elseif type_RADAR=='POB'
% POB position
Const.Radar_type='POB';
Const.lon_rx      = 6.357616;  % RX longitude [decimal deg]
Const.lat_rx      = 43.091933; % RX latitude  [decimal deg]
Const.lon_tx      = 6.204189;  % TX longitude [decimal deg]
Const.lat_tx      = 42.983084; % TX latitude  [decimal deg]
Const.lon0        = 5.861066;  % Origin of the radial grid, longitude [decimal deg]
Const.lat0        = 43.063078; % Origin of the radial grid, latitude  [decimal deg]
Const.mono        = 2;         % Bistatique Radar

elseif type_RADAR=='COD'
% CODAR position
Const.Radar_type='COD';
Const.lat0        = 43.6750;   % Origin of the radial grid, latitude  [decimal deg]
Const.lon0        = 7.3271;    % Origin of the radial grid, longitude [decimal deg]
Const.lat_tx      = 43.6750;   % TX latitude  [decimal deg]radar.alpha  
Const.lon_tx      = 7.3271333; % TX longitude [decimal deg]
Const.lat_rx      = 43.6750;   % RX latitude  [decimal deg]
Const.lon_rx      = 7.3271333; % RX longitude [decimal deg]
Const.mono=1;

else
    error('Please enter a valid radar type')
end