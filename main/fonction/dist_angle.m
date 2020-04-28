%	function radial
% ***** calcul des parametres des noeuds, relativement � un radar donne
%revu PB 02/2002
%  revu PFO 5/04/2012 pour le mono-bistatique

function [d, az, az_rx] = dist_angle(xA,yA,xB,yB,mono_bi,x,y)

% INPUTS:
% - xA/xB, yA/yB: RADAR coordinates (A: TX, B: RX) [km]
% - mono_bi:      1: monstatic, 2: bistatic
% -	x,y:	      grid cell coordinates            [km]

% OUTPUTS:
% - d: 	   bistatic distance (round-trip distance)                                                     [km]
% - az:    angle of the "radial" direction (normal to the circle (mono-) or to the ellipse (bi-static) [deg]
% - az_rx: angle from the RX RADAR to the grid cell                                                    [deg]
%   	N.B.: angles are in the trigonometric sense wrt to the WE direction

cord = 180/pi;	% conversion radians-degres

% radar monostatique (radar 1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if mono_bi == 1

    % calcul des distances bistatique
    xc = x-xA;
    yc = y-yA;
    d  = 2*sqrt(xc.^2 + yc.^2);

	% angle de la normale au cercle passant par M
    % (le vecteur pointe vers le RADAR - c'est pourquoi il y a +pi)
    tmp = atan2(yc,xc);
	az = (pi+tmp)*cord;
    
    % angle de la radiale radar-cellule
    % (le vecteur pointe vers la cellule)
    az_rx = tmp*cord;

% radar bistatique
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
else
    
    % calcul des distances bistatique
    % - site RX
    xcB = x-xB;
    ycB = y-yB;
    d = sqrt(xcB.^2 + ycB.^2);
    % - site TX
    xcA = x-xA;
    ycA = y-yA;
    d = d+sqrt(xcA.^2 + ycA.^2);
    
    % cotés du triangle ABM 
    AM = sqrt(xcA.^2 + ycA.^2);         % distance TX -> cellule (AM)
    BM = sqrt(xcB.^2 + ycB.^2);         % distance RX -> cellule (BM)
    AB = sqrt((xA-xB)^2 + (yA-yB)^2);   % distance TX -> RX      (AB)

    % angles du triangle ABM
    teta_AM = atan2(ycA,xcA);           % angle TX -> cellule (xAM)
    teta_BM = atan2(ycB,xcB);           % angle RX -> cellule (xBM)
    teta_AB = atan2(yB-yA,xB-xA);       % angle TX -> RX      (xAB)
    teta_MAB = 2*pi - teta_AM + teta_AB;
    teta_ABM = teta_BM - teta_AB - pi;

    % angle de la normale à l'ellipse
    AH = AB./(1+sin(teta_MAB)./sin(teta_ABM));
    HB = AB-AH;
    xH = xB + (xA-xB)*HB/AB;
    yH = yB + (yA-yB)*HB/AB;
    az = (pi+atan2(y-yH,x-xH))*cord;    % angle de la "radiale": cellule -> TX/RX baseline (xMH)
    
    az_rx = teta_BM*cord;               % angle RX -> cellule (xBM)
end

az(az > 180)  = -( 360 - az(az > 180));
az(az < -180) =    360 - az(az < -180);
az_rx(az_rx > 180)  = -( 360 - az_rx(az_rx > 180));
az_rx(az_rx < -180) =    360 - az_rx(az_rx < -180);


%%%%%%%%% BISTATIC TRIANGLE %%%%%%%%
%                                  %
%  y                               %
%  ^                               %
%  | A--------                     %    A: RADAR A (TX)
%  |   -       -----H---           %    H: intersection of the "radial" MH with AB
%  |   -            |  --------B   %    B: RADAR B (RX)
%  |    -           |         -    %
%  |     -          |        -     %
%  |      -         |       -      %
%  |       -       |       -       %    MH: "radial" direction, perpendicular to the ellipse @ M
%  |        -      |      -        %        CONVENTION: MH points towards H
%  |         -     |     -         %     _
%  |          -    |    -          %    AMB: bistatic angle
%  |           -   |   -           %           _
%  |            -  |  -            %    N.B.: MHB is not 90 deg (unless coincidence)
%  |             - | -             %
%  |              -|-              %
%  |               M               %    M: pixel of the "radial" map
%  |                               %
%  |---------------------------> x %
% O                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
