begin

fsurface=addfile("/home/cccr/rameshv/dipti/Data/ERA5/ERA5files/ER5_surface_DecJan_1979-2019_0_Down.nc","r")
;tsurf=short2flt(fsurface->t2m(:,{23:32},{73:86}))
tsurf=short2flt(fsurface->t2m(:,{0:90},{0:180}))
;dsurf=short2flt(fsurface->d2m(:,{23:32},{73:86}))
units=tsurf&time@units


data=asciiread("WSFogDays_1.5ddCriteriaRF50Per.txt",-1,"string")
delim=","
dates=str_get_field(data, 1, delim)
delim="-"
year=toint(str_get_field(dates, 1, delim))
months=toint(str_get_field(dates, 2, delim))
days=toint(str_get_field(dates, 3, delim))

dd=new((/dimsizes(dates),dimsizes(tsurf(0,:,0)),dimsizes(tsurf(0,0,:))/),typeof(tsurf))
;dd=new((/dimsizes(dates),dimsizes(tsurf(0,:,0))*dimsizes(tsurf(0,0,:))/),typeof(tsurf))

dd!0 = "time"
 dd!1 = "latitude"
 dd!2 = "longitude"

dd&latitude=tsurf&latitude
dd&longitude=tsurf&longitude

do i=0,dimsizes(dates)-1
print(year(i))
Time=cd_inv_calendar(year(i),months(i),days(i),0,0,0,units,0)
;dd(i,:,:)=tsurf({Time},:,:)-dsurf({Time},:,:)
;dd(i,:)=ndtooned(tsurf({Time},:,:)-dsurf({Time},:,:))
;dd(i,:)=ndtooned(tsurf({Time},:,:))
dd(i,:,:)=(tsurf({Time},:,:))

end do
printVarSummary(dd)
;ddone=

ncdf = addfile("/home/cccr/rameshv/dipti/Data/WDF_RF_Dayst2m_forEOF.nc" ,"c")  ; open output netCDF file
ncdf->dd=dd






end
