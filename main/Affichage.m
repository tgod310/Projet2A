i=7;

figure()
subplot(2,2,1)
hold on
contourf(shared.lon,shared.lat,radar.interp_Vr(:,:,i));
contour(shared.lon,shared.lat,model.Vr(:,:,i),'ShowText','on','LineColor','k','LineWidth',2)
s=colorbar;
c=caxis;
s.Label.String='Vitesse radiale (m\cdot s^{-1})';
title('Moyenne journaliere radar')
hold off

subplot(2,2,2)
hold on
contourf(shared.lon,shared.lat,model.Vr(:,:,i))
contour(shared.lon,shared.lat,radar.interp_Vr(:,:,i),'ShowText','on','LineColor','k','LineWidth',2)
s=colorbar;
caxis(c)
s.Label.String='Vitesse radiale (m\cdot s^{-1})';
title('Projection modele')
hold off

subplot(2,2,3)
contourf(shared.lon,shared.lat,shared.difference(:,:,i))
s=colorbar;
s.Label.String='Sans unitees';
title('Comparaison radar-model')

subplot(2,2,4)
contourf(shared.lon,shared.lat,shared.difference2(:,:,i))
s=colorbar;
s.Label.String='Vitesse (m\cdot s^{-1})';
title('Difference radar-modele')

sgtitle([datestr(shared.time(i)+shared.time_origin_julien),' i=',num2str(i)])