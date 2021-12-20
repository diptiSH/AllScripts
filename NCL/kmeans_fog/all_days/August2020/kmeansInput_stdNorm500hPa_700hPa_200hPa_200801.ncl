;;;;;;;;;;;;;; code to prepare input for kmeans
;;;;;;;;;;; intended output is like nc file with variable 
;;;variable structure is like each row represents a day and standard values of variables
;;;at diffent levels and over area are appended as 1D array


begin

years=ispan(1980,2019,1)
nyrs=dimsizes(years)
ntimes=nyrs*62

;;;; add anomaly normalised by standard deviation data files

f500=addfile("/home/cccr/rameshv/dipti/Data/eraDown/ERA5to19/StdAnomERA5PerDay_.75_decJan_1979_2019_z500_download.nc","r")
f700=addfile("/home/cccr/rameshv/dipti/Data/eraDown/ERA5to19/StdAnomERA5PerDay_.75_DecJan_1979_2019_z700_download.nc","r")
f200=addfile("/home/cccr/rameshv/dipti/Data/eraDown/ERA5to19/StdAnomERA5PerDay_.75_DecJan_1979_2019_z200_download.nc","r")


;;;; read variables
z500=short2flt(f500->z(:,{20:40},{60:85}))
z200=short2flt(f200->z(:,{20:40},{60:85}))
z700=short2flt(f700->z(:,{20:40},{60:85}))

time=f500->time
units=time@units
print(units)



latitude=z500&latitude
longitude=z500&longitude
nlat=dimsizes(latitude)
nlon=dimsizes(longitude)
print(nlat)
print(nlon)

;;;;;;;;;initialize variable

kmeansInput=new((/ntimes,3*nlat*nlon/),typeof(z500))
printVarSummary(kmeansInput)


;;;;;;;;;;;;;;;;; get data on given days

i=0
do yr=1980,2019

do mn=1,2
    if(mn.eq.1)then
      year=yr-1
      mon=12
    else
      year=yr
      mon=1
    end if
  do da=1,31
 JTime=cd_inv_calendar(year,mon,da,9,00,00,units,0)
 
kmeansInput(i,0:nlat*nlon-1)=ndtooned(z500({JTime},:,:))
kmeansInput(i,nlat*nlon:nlat*nlon*2-1)=ndtooned(z700({JTime},:,:))
kmeansInput(i,nlat*nlon*2:nlat*nlon*3-1)=ndtooned(z200({JTime},:,:))
i=i+1

end do
end do
end do


 ncdf = addfile("kmeansInput_z500_z700_z200_allDays_stdnormAnom_20-40_60-85_1980_2019.nc" ,"c")  ; open output netCDF file
 ncdf->kmeansInput=kmeansInput

end
