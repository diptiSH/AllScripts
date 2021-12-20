begin

;fsurface=addfile("/home/cccr/rameshv/dipti/pySom/Data/ER5_level_DecJan_1979-2019_00_Down.nc","r")
fsurface=addfile("/home/cccr/rameshv/dipti/Data/ERA5/ERA5files/ER5_MSLP_DecJan_1979-2019_0_Down.nc","r")

tsurf=short2flt(fsurface->msl(:,:,:))
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


do i=0,dimsizes(dates)-1
print(year(i))
Time=cd_inv_calendar(year(i),months(i),days(i),0,0,0,units,0)
;dd(i,:,:)=tsurf({Time},:,:)-dsurf({Time},:,:)
;dd(i,:)=ndtooned(tsurf({Time},:,:)-dsurf({Time},:,:))
dd(i,:,:)=(tsurf({Time},:,:))



end do

;ddone=

ncdf = addfile("/home/cccr/rameshv/dipti/Data/357WDFDaysMSLP.nc" ,"c")  ; open output netCDF file
ncdf->dd=dd






end
