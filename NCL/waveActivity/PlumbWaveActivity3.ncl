; 3-D wave-activity flux derived by Plumb (1985, JAS)
; See (5.7) of Plumb 1985
;
; ************Used data: daily-mean data of NCEP/NCAR reanalys 1
;  **************air tempeature (air: degK)   ; air.2000.nc
;  *********geopotential height (hgt: m) ; hgt.2000.nc

; Used data: daily-mean data of ERA5
;  air tempeature (t: degK)   ;ERA5PerDay_.75_NovDecJanFeb_1998_2018_t200_300_download.nc 
;  geopotential  (z: m2/s2) ; ERA5PerDay_.75_NovDecJanFeb_1998_2018_z200_300_download.nc


;
; The data are available at 
; http://www.esrl.noaa.gov/psd/data/gridded/data.ncep.reanalysis.html

; input files are
;
; The unit of level is [hPa]
;
; Basic state: zonal-mean fields 
;
; Perturbation: deviation from zonal-mean fields
;
; Calculatitudeing the flux for each day of input data.
;
; Note that 
; (i)  10-day low-pass filter is applied
; (ii) The first and last 10 days of output data are missing.
; (iii) "p" (pressure) in Eq. (5.7) is dimensionless (pressure/1000mb)
;       See notation just after (2.2) of Plumb (1985)
;

; Output files are
; x-component:  Plumb1985-Fx.daily.2000.nc
; y-component:  Plumb1985-Fy.daily.2000.nc
; z-component:  Plumb1985-Fz.daily.2000.nc



load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin
; daily mean data in short
; modify direcotry name
;tfile = addfile("/e4b/ncep/plev/daily_mean/nc/air.2000.nc","r")
;zfile = addfile("/e4b/ncep/plev/daily_mean/nc/hgt.2000.nc","r")

tfile = addfile("/home/cccr/rameshv/dipti/Data/eraDown/ERA5PerDay_.75_NovDecJanFeb_2003_t200_300_download.nc","r")
zfile = addfile("/home/cccr/rameshv/dipti/Data/eraDown/ERA5PerDay_.75_NovDecJanFeb_2003_z200_300_download.nc","r")

; Test a variable's type prior to reading the variable

;if (getfilevartypes(tfile,"t").eq."short")then
tvarorg = short2flt(tfile->t)
;else
;tvarorg = tfile[:]->t
;end if

;if (getfilevartypes(zfile,"z").eq."short")then
zvarorg = short2flt(zfile->z)
;else
;zvarorg = zfile[:]->z
;end if

; covert geopotential to geootential height
zvarorg=zvarorg/9.81

;printVarSummary(zvarorg)

;exit


time = tfile->time
latitude = tfile->latitude
longitude = tfile->longitude
level = tfile->level

printVarSummary(time)
;exit

ntime = dimsizes(time)
nlatitude = dimsizes(latitude)
nlongitude = dimsizes(longitude)
nlevel = dimsizes(level)

;  Gas constant
gc=290
;  Gravitational acceleration
ga=9.80665

;  Radius of the earth
re=6378388

; scale height
sclhgt=8000.

; pi
pi = atan(1.0)*4.

; Coriolis parameter
f =  2.*2.*pi/(60.*60.*24.)*sin(pi/180. * latitude(:))
f!0 = "latitude"
f&latitude = latitude
f@_FillValue = -1.e+21

; missing for 10S - 10N
do ilatitude = 0, nlatitude-1
if (abs(latitude(ilatitude) ).lt. 10. ) then
f(ilatitude)= f@_FillValue
end if
end do

; cosine
coslatitude = cos(latitude(:)*pi/180.)

;10-day low-pass fileter
; The output data of the first and latitude 10 days is all missing.
wgt = filwgts_lanczos(21, 0,0.1, -999.,1)

zvar = wgt_runave_n_Wrap(zvarorg,wgt,0,0)
tvar = wgt_runave_n_Wrap(tvarorg,wgt,0,0)
;zvar=zvarorg
;tvar=tvarorg

; zonal mean
tznl = dim_avg_n_Wrap(tvar(:,:,:,:),3)


; 1-D -> 4-D
leveltmp = conform_dims(dimsizes(tvar),level,1)
coslatitudetmp = conform_dims(dimsizes(tvar),coslatitude,2)
ftmp = conform_dims(dimsizes(tvar),f,2)

; 3-D -> 4-D
tznltmp = conform_dims( (/ntime,nlevel,nlatitude,nlongitude/),tznl,(/0,1,2/))

; potential temperature
theta = tznltmp*(1000./leveltmp)^0.286

;K/m
dthetadz = center_finite_diff_n(theta,-sclhgt*log(level/1000),False,0,1)

; Brunt Vaisala frequency
NN = (gc*(leveltmp/1000.)^0.286)/sclhgt * dthetadz

; deviations from zonal mean
psidev = dim_rmvmean(zvar)*ga /ftmp

;dpsidev/dlongitude
dpsidevdlongitude =  center_finite_diff_n(psidev,longitude*pi/180.,True,0,3)

;ddpsidev/dlongitudelongitude
ddpsidevdlongitudelongitude =  center_finite_diff_n(dpsidevdlongitude,longitude*pi/180.,True,0,3)

;dpsidev/dlatitude
dpsidevdlatitude = center_finite_diff_n(psidev, latitude*pi/180., False,0,2)

;ddpsidev/dlongitudelatitude
ddpsidevdlongitudelatitude =  center_finite_diff_n(dpsidevdlongitude,latitude*pi/180.,False,0,2)

;dpsidev/dz
dpsidevdz = center_finite_diff_n(psidev, -sclhgt*log(level/1000),False,0,1)

;ddpsidev/dlongitudedz
ddpsidevdlongitudez = center_finite_diff_n(dpsidevdlongitude, -sclhgt*log(level/1000),False,0,1)

;x-component of (5.7)
Fx = leveltmp/1000./(2.*re*re*coslatitudetmp)*(dpsidevdlongitude*dpsidevdlongitude-psidev*ddpsidevdlongitudelongitude)

;y-component of (5.7)
Fy = leveltmp/1000./(2.*re*re)*(dpsidevdlongitude*dpsidevdlatitude-psidev*ddpsidevdlongitudelatitude)

;z-component of (5.7)
Fz = leveltmp/1000.*ftmp*ftmp/(2.*NN*re)*(dpsidevdlongitude*dpsidevdz-psidev*ddpsidevdlongitudez)

; for output
Fx!0 = "time"
Fx&time = time
Fx!1 = "level"
Fx&level = level
Fx!2 = "latitude"
Fx&latitude = latitude
Fx!3 = "longitude"
Fx&longitude = longitude

Fy!0 = "time"
Fy&time = time
Fy!1 = "level"
Fy&level = level
Fy!2 = "latitude"
Fy&latitude = latitude
Fy!3 = "longitude"
Fy&longitude = longitude

Fz!0 = "time"
Fz&time = time
Fz!1 = "level"
Fz&level = level
Fz!2 = "latitude"
Fz&latitude = latitude
Fz!3 = "longitude"
Fz&longitude = longitude

psidev!0 = "time"
psidev&time = time
psidev!1 = "level"
psidev&level = level
psidev!2 = "latitude"
psidev&latitude = latitude
psidev!3 = "longitude"
psidev&longitude = longitude

NN!0 = "time"
NN&time = time
NN!1 = "level"
NN&level = level
NN!2 = "latitude"
NN&latitude = latitude
NN!3 = "longitude"
NN&longitude = longitude

Fx@units = "m^2/s^2"
Fx@units = "m^2/s^2"
Fz@units = "m^2/s^2"

psidev@units = "m^2/s"

NN@units = "1/s^2"

ncFx = addfile("Plumb1985-Fx.daily.NovFeb2003.nc","c")
ncFy = addfile("Plumb1985-Fy.daily.NovFeb2003.nc","c")
ncFz = addfile("Plumb1985-Fz.daily.NovFeb2003.nc","c")

ncpsidev = addfile("psidev.daily.NovFeb2003.nc","c")

ncNN = addfile("NN.daily.NovFeb2003.nc","c")

ncFx->Fx = Fx
ncFy->Fy = Fy
ncFz->Fz = Fz
ncpsidev->psidev = psidev
ncNN->NN = NN

exit                         
	 
;ntime = dimsizes(time)
;nlatitude = dimsizes(latitude)
;nlongitude = dimsizes(longitude)
;nlevel = dimsizes(level)
	
fout=addfile("Plumb1985.daily.NovFeb1998_2018.nc","c")
;===================================================================
    ; explicitly declare file definition mode. Improve efficiency.
    ;===================================================================
        setfileoption(fout,"DefineMode",True)

;===================================================================
    ; predefine the coordinate variables and their dimensionality
    ; Note: to get an UNLIMITED record dimension, we set the dimensionality
    ; to -1 (or the actual size) and set the dimension name to True.
    ;===================================================================
        dimNames = (/"time", "latitude", "longitude", "level"/)  
	dimSizes = (/ ntime ,  nlatitude,  nlongitude, nlevel /) 
	dimUnlim = (/ False , False, False, False/)   
	filedimdef(fout,dimNames,dimSizes,dimUnlim)
;===================================================================
    ; predefine the the dimensionality of the variables to be written out
    ;===================================================================
    ; Here we are using NCL functions to facilitate defining 
    ; each variable's dimension name(s) and type. 
    ; The following could be replaced with explicit, user defined dimension 
    ; names different from those associated with the variable in memory. 
    ; Say, PS(time,latitude,longitude) in the NCL script. They could be redefined for the file via: 
    ; filevardef(fout, "PS"   ,typeof(PS) ,(/"TIME","latitude","longitude"/)) 
    ;===================================================================
       filevardef(fout, "time" ,typeof(zvarorg),getvardims(time)) 
       filevardef(fout, "level"  ,typeof(level),getvardims(level) )                           
       filevardef(fout, "latitude"  ,typeof(latitude),getvardims(latitude))                          
       filevardef(fout, "longitude"  ,typeof(longitude),getvardims(longitude))                          
       filevardef(fout, "Fx"    ,typeof(zvarorg)  ,getvardims(zvarorg))    
       filevardef(fout, "Fy"   ,typeof(zvarorg) ,getvardims(zvarorg))          
       filevardef(fout, "Fz"   ,typeof(zvarorg) ,getvardims(zvarorg))
       filevardef(fout, "psidev"   ,typeof(zvarorg) ,getvardims(zvarorg))
       filevardef(fout, "NN"   ,typeof(zvarorg) ,getvardims(zvarorg))
  ;     filevardef(fout, "TOPOG",typeof(ORO),getvardims(ORO))  ; variable name on the file                
                                                              ; different from name on script

    ;===================================================================
    ; Copy attributes associated with each variable to the file
    ; All attributes associated with each variable will be copied.
    ;====================================================================
       filevarattdef(fout,"Fx",Fx)                           ; copy T attributes
       filevarattdef(fout,"time" ,time)                    ; copy time attributes
       filevarattdef(fout,"level"  ,level)                     ; copy lev attributes
       filevarattdef(fout,"latitude"  ,latitude)                     ; copy latitude attributes
       filevarattdef(fout,"longitude"  ,longitude)                     ; copy longitude attributes
       filevarattdef(fout,"Fy"   ,Fy)                      ; copy PS attributes
       filevarattdef(fout,"Fz",Fz)                     ; copy TOPOG attributes
       filevarattdef(fout,"psidev",psidev)                     ; copy TOPOG attributes
       filevarattdef(fout,"NN",NN)                     ; copy TOPOG attributes

    ;===================================================================
    ; explicitly exit file definition mode. **NOT REQUIRED**
    ;===================================================================
        setfileoption(fout,"DefineMode",False)

;===================================================================
    ; output only the data values since the dimensionality and such have
    ; been predefined. The "(/", "/)" syntax tells NCL to only output the
    ; data values to the predefined locations on the file.
    ;====================================================================
       fout->time   = tofloat((/time/))
       fout->level    = (/level/)
       fout->latitude    = (/latitude/)
       fout->longitude    = (/longitude/) 
       fout->Fx      = (/Fx/)
       fout->Fy     = (/Fy/)
       fout->Fz  = (/Fz/)
       fout->psidev  = (/psidev/)
       fout->NN  = (/NN/)
end
