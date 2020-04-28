%   xylonlat: conversion xy<-->lonlat
%   This function will convert longitude/latitude pairs to distances in 
%   kilometers east and west of a reference longitude/latitude point.  The
%   equation was obtained from Bowditch's book "The American Practical 
%   Navigator, 1995 edition, page 552."
%
%   opt=1: lonlat-->xy
%          en entrée x,y sont les longitudes,latitudes
%          en sortie X,Y sont les x,y
%   opt=2: xy-->lonlat
%          en entrée x,y sont les x,y
%          en sortie X,Y sont les lon,lat
%   lon0,lat0= lonlat de référence de la transformation

   function [X,Y]=xylonlat(x,y,lon0,lat0,opt)

   a=111.13292; b=-0.55982; c=111.41284;
   cos1=cos(d2r(lat0)); cos2=cos(2*d2r(lat0));
   
   %conversion lonlat-->xy
   if opt==1 X=(x-lon0).*(c*cos1); Y=(y-lat0).*(a+b*cos2); end

   %conversion xy-->lonlat
   if opt==2 X=lon0+x/(c*cos1); Y=lat0+y/(a+b*cos2); end
   