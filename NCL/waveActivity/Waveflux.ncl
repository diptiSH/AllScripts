load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

; SON
season = "DecJan"

infile = addfile("/home/cccr/rameshv/dipti/Data/eraDown/ClimERA5_.75_decJan_1979_2018_z300_download.nc", "r")
hgt_clim_old = infile->z
infile2=addfile("/home/cccr/rameshv/dipti/Data/eraDown/AnomERA5PerDay_.75_decJan_1979_2018_z300_download.nc", "r")
hgt_anom_old = infile2->z

hgt_clim=hgt_clim_old
hgt_clim=hgt_clim_old/9.81

hgt_anom=hgt_anom_old
hgt_anom=hgt_anom_old/9.81


printVarSummary(hgt_clim )
printVarSummary(hgt_anom )



mylev = 300.0
ctime=infile2->time
lat = infile->latitude
lon = infile->longitude

nlat = dimsizes(lat)

;tval_hgt = reshape(hgt_anom@tval,(/dimsizes(hgt_anom(:,0)),dimsizes(hgt_anom(0,:))/))
;copy_VarMeta(hgt_anom, tval_hgt)

;  Gas constant
gc=290
;  Gravitational acceleration
ga=9.80665

;  Radius of the earth
re=6378388

; pi
pi = atan(1.0)*4.

; Coriolis parameter
f =  2.*2.*pi/(60.*60.*24.)*sin(pi/180. * lat(:))
f!0 = "lat"
f&lat = lat
f@_FillValue = hgt_anom@_FillValue

; missing for 10S - 10N
do ilat = 0, nlat-1
if (abs(lat(ilat) ).lt. 5. ) then
f(ilat)= f@_FillValue
end if
end do

; cosine
coslat = cos(lat(:)*pi/180.)

printVarSummary(hgt_anom)
printVarSummary(coslat)

coslattmp = conform_dims(dimsizes(hgt_anom),coslat,1)
ftmp = conform_dims(dimsizes(hgt_anom),f,1)

bb=z2geouv(hgt_clim, lat, lon, 1)

printVarSummary(bb)

uwnd_clim = bb(0,:,:,:)
vwnd_clim = bb(1,:,:,:)

; magnitude of climatological wind
cumag = sqrt(uwnd_clim^2 + vwnd_clim^2)
cumag@_FillValue = uwnd_clim@_FillValue
cumag = where(cumag .gt. 0, cumag, cumag@_FillValue)

; QG steam function for anomaly
psidev = hgt_anom*ga /ftmp

printVarSummary(psidev)


;dpsidev/dlon
dpsidevdlon =  center_finite_diff_n(psidev,lon*pi/180.,True,0,2)

;ddpsidev/dlonlon
ddpsidevdlonlon =  center_finite_diff_n(dpsidevdlon,lon*pi/180.,True,0,2)

;dpsidev/dlat
dpsidevdlat = center_finite_diff_n(psidev, lat*pi/180., False,0,1)

;ddpsidev/dlonlat
ddpsidevdlonlat =  center_finite_diff_n(dpsidevdlon,lat*pi/180.,False,0,1)

;ddpsidev/dlatdlat
ddpsidevdlatlat = center_finite_diff_n(dpsidevdlat, lat*pi/180.,False,0,1)

xuterm = (dpsidevdlon*dpsidevdlon - psidev*ddpsidevdlonlon)
xvterm = (dpsidevdlon*dpsidevdlat - psidev*ddpsidevdlonlat)
;yuterm = xvterm
yvterm = (dpsidevdlat*dpsidevdlat - psidev*ddpsidevdlatlat)

; Mask out where westerlies is small or negative (less than 5 m/s).
;  by using mask

;x-component of (38)
Fx = mask( mylev/1000./(2.*cumag*re*re)*( uwnd_clim/coslattmp * xuterm + vwnd_clim * xvterm), uwnd_clim.lt.5,False)
;Fx =mylev/1000./(2.*cumag*re*re)*( uwnd_clim/coslattmp * xuterm + vwnd_clim * xvterm)

;y-component 
Fy = mask(mylev/1000./(2.*cumag*re*re)*( uwnd_clim*xvterm + coslattmp*vwnd_clim*yvterm),  uwnd_clim.lt.5,False)
;Fy = mylev/1000./(2.*cumag*re*re)*( uwnd_clim*xvterm + coslattmp*vwnd_clim*yvterm)


fspd = sqrt(Fx*Fx+Fy*Fy)
Fx = mask(Fx, fspd.le.0.035, False)
Fy = mask(Fy, fspd.le.0.035, False)

printVarSummary(Fx)

; for output
Fx!0 = "time"
Fx&time = ctime
Fx!1 = "lat"
Fx&lat = lat
Fx!2 = "lon"
Fx&lon = lon

Fy!0 = "time"
Fy&time = ctime
Fy!1 = "lat"
Fy&lat = lat
Fy!2 = "lon"
Fy&lon = lon

psidev!0 = "time"
psidev&time = ctime
psidev!1 = "lat"
psidev&lat = lat
psidev!2 = "lon"
psidev&lon = lon



Fx@units = "m^2/s^2"
Fx@units = "m^2/s^2"

copy_VarMeta(hgt_anom, Fx)
copy_VarMeta(hgt_anom, Fy)


printVarSummary(Fx)
end
