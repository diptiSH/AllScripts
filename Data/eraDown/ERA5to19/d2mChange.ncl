begin

f=addfile("ERA5_.75_DecJan_1979_2019_surface_uv_t_dt_mslp_download.nc","r")
ftime=addfile("ERA5_0UTC_.75_DecJan_1979_2019_inv_download.nc","r")

time=ftime->time
t2m=short2flt(f->d2m)

printVarSummary(t2m)
printVarSummary(time)

nlat=dimsizes(t2m&latitude)
nlon=dimsizes(t2m&longitude)
ntimes=dimsizes(t2m&time)/4
unit=time@units

;time=new(ntimes,"integer")
;time@units="hours since 1900-01-01 00:00:00.0" 
;time@calendar = "gregorian"

d2mChange=new((/ntimes,nlat,nlon/),"float")
d2mChange!0="time"
d2mChange!1="latitude"
d2mChange!2="longitude"

d2mChange&latitude=t2m&latitude
d2mChange&longitude=t2m&longitude
d2mChange&time=time

d2mChange@long_name="previous day 12UTC d2m - 0UTC d2m "

printVarSummary(d2mChange)


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
  d2mChange({JTime},:,:)=t2m({JTime-12},:,:)-t2m({JTime},:,:)

  end do 
 end do
end do

ncdf2=addfile("d2mChange.nc" ,"c")  ; open output netCDF file
ncdf2->d2mChange=d2mChange

end
