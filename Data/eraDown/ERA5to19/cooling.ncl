begin

f=addfile("ERA5_.75_DecJan_1979_2019_surface_uv_t_dt_mslp_download.nc","r")
ftime=addfile("ERA5_0UTC_.75_DecJan_1979_2019_inv_download.nc","r")

time=ftime->time
t2m=short2flt(f->t2m)

printVarSummary(t2m)
printVarSummary(time)

nlat=dimsizes(t2m&latitude)
nlon=dimsizes(t2m&longitude)
ntimes=dimsizes(t2m&time)/4
unit=time@units

;time=new(ntimes,"integer")
;time@units="hours since 1900-01-01 00:00:00.0" 
;time@calendar = "gregorian"

cooling=new((/ntimes,nlat,nlon/),"float")
cooling!0="time"
cooling!1="latitude"
cooling!2="longitude"

cooling&latitude=t2m&latitude
cooling&longitude=t2m&longitude
cooling&time=time

cooling@long_name="previous day 12UTC t2m - 0UTC t2m "

printVarSummary(cooling)


do yr=1979,2019
 do mn=1,2
   if(mn.eq.2)then
     mon=12
   else
     mon=1
   end if
   if(mon.eq.12)then
    sDay=2
   else
    if(yr.eq.1979)then
    sDay=2
    else
     sDay=1
     end if
   end if
  do day=sDay,31
  JTime=cd_inv_calendar(yr,mon,day,00,00,00,unit,0)
  cooling({JTime},:,:)=t2m({JTime-12},:,:)-t2m({JTime},:,:)

  end do 
 end do
end do

ncdf2=addfile("cooling.nc" ,"c")  ; open output netCDF file
ncdf2->cooling=cooling

end
