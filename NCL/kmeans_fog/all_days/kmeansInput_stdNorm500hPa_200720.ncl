;;;;;;;;;;;;;; code to prepare input for kmeans
;;;;;;;;;;; intended output is like nc file with variable 
;;;variable structure is like each row represents a day and standard values of variables
;;;at diffent levels and over area are appended as 1D array


begin

years=ispan(1980,2019,1)
nyrs=dimsizes(years)
ntimes=nyrs*62

;;;; add anomaly normalised by standard deviation data files

fslp=addfile("/home/cccr/rameshv/dipti/Data/eraDown/ERA5to19/StdAnomERA5PerDay_.75_decJan_1979_2019_z500_download.nc","r")


;;;; read variables
slp=short2flt(fslp->z(:,{30:40},{66:76}))


time=fslp->time
units=time@units
print(units)



latitude=slp&latitude
longitude=slp&longitude
nlat=dimsizes(latitude)
nlon=dimsizes(longitude)
print(nlat)
print(nlon)


;slp_std=dim_standardize_n_Wrap(slp, 0, 0)
slp_std=slp


;;;;;;;;;initialize variable

kmeansInput=new((/ntimes,nlat*nlon/),typeof(slp))
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
 JTime=cd_inv_calendar(yr,mon,da,9,00,00,units,0)
 
kmeansInput(i,0:nlat*nlon-1)=ndtooned(slp_std({JTime},:,:))
i=i+1

end do
end do
end do


 ncdf = addfile("kmeansInput_z500_allDays_stdnormAnom_30-40_66-76_1980_2019.nc" ,"c")  ; open output netCDF file
 ncdf->kmeansInput=kmeansInput

end
