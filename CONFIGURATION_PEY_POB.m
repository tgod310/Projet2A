% MARMAIN - 08/06/2012
% DINEOF_namelist.m
% MARMAIN - 18/06/2012
% Adaptation pour utilisation "bijective" avec carto

% 
% Configuration parameters for the entire program
% 

active_sites = [1 2];% 1];   % indexes of the RADAR sites to be used
                        % The order is the one of the structure RADAR_infos


%% RADAR sites informations
% Peyras
RADAR_infos(1).name        = 'PEY';     % same as the cll/xyv files suffix
RADAR_infos(1).lon_rx      = 5.861066;  % RX longitude [decimal deg]
RADAR_infos(1).lat_rx      = 43.063078; % RX latitude  [decimal deg]
RADAR_infos(1).lon_tx      = 5.861066;  % TX longitude [decimal deg]
RADAR_infos(1).lat_tx      = 43.063078; % TX latitude  [decimal deg]
RADAR_infos(1).lon0        = 5.861066;  % Origin of the radial grid, longitude [decimal deg]
RADAR_infos(1).lat0        = 43.063078; % Origin of the radial grid, latitude  [decimal deg]
RADAR_infos(1).range       = [10 60];   % range min and max [km]
RADAR_infos(1).ouv_angle   = 120;       % azimuthal angle   [deg]
RADAR_infos(1).orientation = 270;       % orientation of the RX array wrt the geographic North [deg]
RADAR_infos(1).integr_time = 1;         % integration time (1 for a reference time (no matter the value),
                                            %                   n for n*the_reference_time)
% Bénat - Porquerolles
RADAR_infos(2).name        = 'POB';     % same as the cll/xyv files suffix
RADAR_infos(2).lon_rx      = 6.357616;  % RX longitude [decimal deg]
RADAR_infos(2).lat_rx      = 43.091933; % RX latitude  [decimal deg]
RADAR_infos(2).lon_tx      = 6.204189;  % TX longitude [decimal deg]
RADAR_infos(2).lat_tx      = 42.983084; % TX latitude  [decimal deg]
RADAR_infos(2).lon0        = 5.861066;  % Origin of the radial grid, longitude [decimal deg]
RADAR_infos(2).lat0        = 43.063078; % Origin of the radial grid, latitude  [decimal deg]
RADAR_infos(2).range       = [10 70];   % range min and max [km]
RADAR_infos(2).ouv_angle   = 120;       % azimuthal angle   [deg]
RADAR_infos(2).orientation = 120;       % orientation of the RX array wrt the geographic North [deg]
RADAR_infos(2).integr_time = 2;         % integration time (1 for a reference time (no matter the value),
                                            %                   n for n*the_reference_time)


%% Bénat
%RADAR_infos(2).name        = 'BEN';     % same as the cll/xyv files suffix
%RADAR_infos(2).lon_rx      = 6.357616;  % RX longitude [decimal deg]
%RADAR_infos(2).lat_rx      = 43.091933; % RX latitude  [decimal deg]
%RADAR_infos(2).lon_tx      = 5.861066;  % TX longitude [decimal deg]
%RADAR_infos(2).lat_tx      = 43.063078; % TX latitude  [decimal deg]
%RADAR_infos(2).lon0        = 5.861066;  % Origin of the radial grid, longitude [decimal deg]
%RADAR_infos(2).lat0        = 43.063078; % Origin of the radial grid, latitude  [decimal deg]
%RADAR_infos(2).range       = [10 70];   % range min and max [km]
%RADAR_infos(2).ouv_angle   = 120;       % azimuthal angle   [deg]
%RADAR_infos(2).orientation = 120;       % orientation of the RX array wrt the geographic North [deg]
%RADAR_infos(2).integr_time = 2;         % integration time (1 for a reference time (no matter the value),
                                            %                   n for n*the_reference_time)

                                            
%% Options for all geographic plots
map.lon_lim   = [5.4 6.8]';     % longitude range of the map [decimal deg]
map.lat_lim   = [42.2 43.2]';   % latitude range of the map  [decimal deg]
map.lon0      = 5.86;           % reference lon for x/y maps (only if map.lonlat_xy==2)
map.lat0      = 43.06;          % reference lat for x/y maps (only if map.lonlat_xy==2)
map.lonlat_xy = 2;              % use 1: lon/lat coordinates
                                %     2: x/y coordinates in km
map.plot_bath = 1;              % plot isobaths (0 or 1) whose values are in installation/trace_coast.m
map.plot_fig=1;                 % 1=plot all figures; 0= no plot


                                            
% %% Rectangular cartesian grid for mapping plots
% cart_grid.lon_lim    = [5.7 6.7]';      % longitude limits
% cart_grid.lat_lim    = [42.5 43.05]';   % latitude limits
% cart_grid.step       = 2;               % grid step (same for x and y) [km]
% cart_grid.rot_angle  = 0;               % counterclockwise rotation angle of the grid wrt the WE axis
% cart_grid.err_type   = 1;               % type of error for masking untrustworthy grid points.
%                                         %       1: GDOP, 2: angle between radial directions
% cart_grid.err_thresh = 2.5;             % threshold on the masking error
%                                         % if err_type==1 => max allowed normalized GDOP error wrt the Doppler error
%                                         % if err_type==2 => min allowed angle between radial directions [deg]

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % N.B.: The plots are done either in lon/lat coordinates or in x/y %
        %       according to the value of map.lonlat_xy                    %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Radial data path
radial_data(1).path_cll_xyv = '/home/marmain/Data/ECCOP/SYNCHROWERA/PEY/Radial/';%'/mnt/l7syno1/POSTPROCWERA/PEY/Radial/';
% radial_data(1).path_cll_xyv = '/mnt/l7syno1/wera/PEY_RESULTS/v944/raw_projection_RR3_15/DF/';
radial_data(1).path_nc      = '/home/molcard/RADAR_NEW/COMPARISON/DERDYLAN';%CARTO/TOSCA_dylan/';%'/home/molcard/TOSCA/TOSCA2_august/RADAR/';%/programme_ju/';
radial_data(1).ext          = 'xyv';                    % 'cll' (monostatic) or 'xyv' (bistatic)
radial_data(1).dates        = ['20191750001'; '20191772301'];%['20122170000'; '20122222300'];%['20121900000'; '20122402359'];%['20122180601'; '20122210221'];
radial_data(1).use_NetCDF   = 1;
radial_data(1).path_mask    = './mask_interp_PEY.mat';

radial_data(2).path_cll_xyv = '/home/marmain/Data/ECCOP/SYNCHROWERA/POB/Radial/';
% radial_data(2).path_cll_xyv = '/mnt/l7syno1/wera/BEN_RESULTS/v944/raw_projection_RR3_15/DF/';
radial_data(2).path_nc      = '/home/molcard/RADAR_NEW/COMPARISON/DERDYLAN';%/CARTO/TOSCA_dylan/';%'/home/molcard/TOSCA/TOSCA2_august/RADAR/';%programme_ju/';
radial_data(2).ext          = 'xyv';
radial_data(2).dates        = ['20191750001'; '20191772301'];%['20122170000'; '20122222300'];%['20121900000'; '20122452359'];%['20122180601'; '20122210221'];
radial_data(2).use_NetCDF   = 1;
radial_data(2).path_mask    = './mask_interp_BEN.mat';


%% DRIFTERS infos
path_drifter = '/home/molcard/RADAR_NEW/COMPARISON/DERDYLAN/DRIFTERS/';

% color
k=1;
plot_param.col(k,:) = [0 1 1];         k=k+1; 
plot_param.col(k,:) = [0 0.75 0.75];   k=k+1; 
plot_param.col(k,:) = [0 0.5 0.5];     k=k+1; 
plot_param.col(k,:) = [1 0 0];         k=k+1; 
plot_param.col(k,:) = [0.75 0.25 0];   k=k+1;    
plot_param.col(k,:) = [0.5 0.5 0];     k=k+1;      
plot_param.col(k,:) = [0.75 0.75 0];   k=k+1;    
plot_param.col(k,:) = [1 1 0];         k=k+1; 
plot_param.col(k,:) = [0 0 0];         k=k+1; 
plot_param.col(k,:) = [0.25 0.25 0.25];k=k+1; 
plot_param.col(k,:) = [0.5 0.5 0.5];   k=k+1; 
plot_param.col(k,:) = [1 0 1];         k=k+1; 
plot_param.col(k,:) = [0 1 1];         k=k+1; 
plot_param.col(k,:) = [1 0 0];         k=k+1; 
plot_param.col(k,:) = [0.75 0 0.75];   k=k+1; 
plot_param.col(k,:) = [0.75 0 0];      k=k+1; 
plot_param.col(k,:) = [0.75 0.25 0];   k=k+1;    
plot_param.col(k,:) = [0.25 1 0];      k=k+1;  
plot_param.col(k,:) = [0.25 0 1];      k=k+1; 
plot_param.col(k,:)=[0.6 0.4 0]; k=k+1
clear k
       
%%%%% plot_parameters %%%%%%%%%
plot_param.ste=2;4;                % pas pour fleches de courant
plot_param.sca=0.1;0.4;            % echelle des fleches de courant
plot_param.lw=1;                   % linewidth du gca
plot_param.lwc=1.5;                % linewidth des cotes
plot_param.fsb=10;                 % fontsize des labels de bathy
plot_param.levels=[50 100 1000];   % isobathes
plot_param.lwcont=0.5;             % linewidth des contours
plot_param.lwfl=0.5;               % linewidth des fleches
plot_param.cax_min=-0.5;  cax_max=0.5;  %caxis des vecteurs projetes (99: pas de caxis)
plot_param.fst=14;                 %fontsize du texte
plot_param.msr=5;                 %markersize des radars
plot_param.lwl=2;                  %linewidth des axes radar lateraux


