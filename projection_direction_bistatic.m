function [ alpha, v_normale_x , v_normale_y ] = projection_direction_bistatic(XM,YM,XTX,YTX,XRX,YRX )
%%% MARMAIN 
%%% 2012/08/07
%%% From Y. Barbin
%%%
%%% Calcul de la direction de projection de la vitesse %%%%%%%%%%%%%%%%%%%%
%%%
%%%     INPUT: XTX,YTX,XRX,YRX: positions of TX,RX in a km grid
%%%            XM;YM: position of the point where you to calcul the
%%%            projection direction
%%%     OUTPUT: v_normale: the direction of projection corresponding to the
%%%     normale to the ellipse at point XM;YM

%to be sure:
            %autre calcul de la normale (comme bissectrice de l angle RMT)
            %et de l angle de la projection (comme moitie de l angle RMT):

%             XM=Dxy(1)+XC;
%             YM=Dxy(2)+YC;
%ainsi XM et et YM sont les coordonnees du point M dans le repere choisi

%CALCUL DU VECTEUR UNITAIRE DE LA DROITE MT
            vMTx=XTX-XM;
            vMTy=YTX-YM;
            nvMT=sqrt(vMTx.^2 + vMTy.^2);
            vtx=vMTx./nvMT;
            vty=vMTy./nvMT;
            %vMT=[XTX;YTX]-[XM;YM];
            %nvMT=sqrt(vMT'*vMT);
            %vt=(1/nvMT)*vMT;
%CALCUL DU VECTEUR UNITAIRE DE LA DROITE MR
            vMRx=XRX-XM;
            vMRy=YRX-YM;
            nvMR=sqrt(vMRx.^2 + vMRy.^2);
            vrx=vMRx./nvMR;
            vry=vMRy./nvMR;
%             vMR=[XRX;YRX]-[XM;YM];
%             nvMR=sqrt(vMR'*vMR);
%             vr=(1/nvMR)*vMR;
%calcul du vecteur UNITAIRE porteur de la projection,
            V_normale_x=vtx+vrx;
            V_normale_y=vty+vry;
            nV_normale=sqrt(V_normale_x.^2 + V_normale_y.^2);
            v_normale_x=V_normale_x./nV_normale;
            v_normale_y=V_normale_y./nV_normale;
            
%             V_normale=vt+vr;
%             nV_normale=sqrt(V_normale'*V_normale);
%             v_normale=(1/nV_normale)*V_normale;

% angle of the "radial" direction (normal to the circle (mono-) or to the
% ellipse (bi-static) [rad]
%N.B.: angles are in the trigonometric sense wrt to the WE direction

alpha = atan2(v_normale_y,v_normale_x);

end

