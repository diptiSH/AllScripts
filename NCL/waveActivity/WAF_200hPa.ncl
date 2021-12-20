begin


infile = addfile("/home/cccr/rameshv/dipti/Data/eraDown/ClimERA5PerDay_.75_NovDecJanFeb_1979_2016_z200_download.nc", "r")
hgt_clim_old1 = infile->z
hgt_clim_old=hgt_clim_old1
hgt_clim_old=hgt_clim_old1/9.81
units_clim=hgt_clim_old&time@units

infile1=addfile("/home/cccr/rameshv/dipti/Data/eraDown/AnomERA5PerDay_.75_NovDecJanFeb_1979_2016_z200_download.nc","r")
z=infile1->z
t=infile1->time

printVarSummary(hgt_clim_old)
;exit
;;;;;;;;;;;;; constants

lat = infile->latitude
lon = infile->longitude

nlat = dimsizes(lat)
ntime=dimsizes(t)
mylev = 200

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
f@_FillValue = hgt_clim_old@_FillValue

; missing for 10S - 10N
do ilat = 0, nlat-1
if (abs(lat(ilat) ).lt. 5. ) then
f(ilat)= f@_FillValue
end if
end do

; cosine
coslat = cos(lat(:)*pi/180.)

;;;;;;;;;;;;initialize WAFs

FX=z
FY=z

printVarSummary(FX)

FX@units="m^2/s^2"
FY@units="m^2/s^2"

FX@long_name="Wave activity flux zonal component"
FY@long_name="Wave activity flux meridional component"

FX@standard_name="WAFx"
FY@standard_name="WAFy"

printVarSummary(FX)

;exit

;;;;;;;;;; loop for each day to calculate WAF

do t1=0,ntime-1

hgt_anom_old = z(t1,:,:)

;printVarSummary(hgt_anom_old )

hgt_anom=hgt_anom_old
hgt_anom=hgt_anom_old/9.81

time=t(t1)
print(time)
units=time@units
;print(units)
utc_date=cd_calendar(time, 0)
print(utc_date)

month= tointeger(utc_date(0,1)) 
day=tointeger(utc_date(0,2))

;print(month)
;print(day)

time2=tointeger(cd_inv_calendar(2016,month,day,9,0,0,units_clim,0))
;print(time2)
;hgt_clim=hgt_clim_old(time|time2,latitude|:,longitude|:)
hgt_clim=hgt_clim_old({time2},:,:)

;print(sum(hgt_clim))
;printVarSummary(hgt_clim)

coslattmp = conform_dims(dimsizes(hgt_anom),coslat,0)
ftmp = conform_dims(dimsizes(hgt_anom),f,0)

bb=z2geouv(hgt_clim, lat, lon, 1)
uwnd_clim = bb(0,:,:)
vwnd_clim = bb(1,:,:)

; magnitude of climatological wind
cumag = sqrt(uwnd_clim^2 + vwnd_clim^2)
cumag@_FillValue = uwnd_clim@_FillValue
cumag = where(cumag .gt. 0, cumag, cumag@_FillValue)

; QG steam function for anomaly
psidev = hgt_anom*ga /ftmp


;dpsidev/dlon
dpsidevdlon =  center_finite_diff_n(psidev,lon*pi/180.,True,0,1)

;ddpsidev/dlonlon
ddpsidevdlonlon =  center_finite_diff_n(dpsidevdlon,lon*pi/180.,True,0,1)

;dpsidev/dlat
dpsidevdlat = center_finite_diff_n(psidev, lat*pi/180., False,0,0)

;ddpsidev/dlonlat
ddpsidevdlonlat =  center_finite_diff_n(dpsidevdlon,lat*pi/180.,False,0,0)

;ddpsidev/dlatdlat
ddpsidevdlatlat = center_finite_diff_n(dpsidevdlat, lat*pi/180.,False,0,0)

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
printVarSummary(Fy)


FX(t1,:,:)=(/Fx/)
FY(t1,:,:)=(/Fy/)

end do


printVarSummary(FX)

ncdf=addfile("ERA5_WAF_NovDecJanFeb_1979-2016_200hPa.nc" ,"c")  ; open output netCDF file

;===================================================================
    ; create global attributes of the file (optional)
    ;===================================================================
       fAtt               = True            ; assign file attributes
       fAtt@title         = "Wave activity flux calculated using geopotential height at level 200hPa"
       fAtt@source_file   =  "created using script /home/cccr/rameshv/dipti/NCL/waveActivity/WAF_200hPa.ncl"
       fAtt@Conventions   = "None"
       fAtt@creation_date = systemfunc ("date")
       fileattdef( ncdf, fAtt )            ; copy file attributes


 ;===================================================================
    ; output variables directly; NCL will call appropriate functions
    ; to write the meta data associated with each variable
    ;===================================================================
       ncdf->FX  = FX                                        
       ncdf->FY = FY                         









end
