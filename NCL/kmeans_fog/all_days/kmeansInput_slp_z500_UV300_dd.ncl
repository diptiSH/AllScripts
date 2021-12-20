;;;;;;;;;;;;;; code to prepare input for kmeans
;;;;;;;;;;; intended output is like nc file with variable 
;;;variable structure is like each row represents a day and standard values of variables
;;;at diffent levels and over area are appended as 1D array


begin

years=ispan(1980,2014,1)
nyrs=dimsizes(years)
ntimes=nyrs*62

;;;; add anomaly normalised by standard deviation data files

fslp=addfile("/home/cccr/rameshv/dipti/Data/eraDown/ERA5PerDay_.75_decJan_1979_2018_mslp_download.nc","r")
fz500=addfile("/home/cccr/rameshv/dipti/Data/eraDown/ERA5PerDay_.75_decJan_1979_2018_z500_download.nc","r")
f300UV=addfile("/home/cccr/rameshv/dipti/Data/eraDown/ERA5PerDay_.75_decJan_1979_2018_uvrh300_download.nc","r")


fdd=addfile("/home/cccr/rameshv/dipti/Data/eraDown/ERA5_.75_decJan_1979_2018_dd_3.nc","r")

;;;; read variables
slp=short2flt(fslp->msl_0001(:,{20:35},{70:90}))
z500=short2flt(fz500->z(:,{20:35},{70:90}))
u300=short2flt(f300UV->u(:,{20:35},{70:90}))
v300=short2flt(f300UV->v(:,{20:35},{70:90}))
dd=short2flt(fdd->dd(:,{20:35},{70:90}))


time=fslp->time
units=time@units
print(units)



latitude=slp&latitude
longitude=slp&longitude
nlat=dimsizes(latitude)
nlon=dimsizes(longitude)
print(nlat)
print(nlon)


slp_std=dim_standardize_n_Wrap(slp, 0, 0)
z500_std=dim_standardize_n_Wrap(z500, 0, 0)
u300_std=dim_standardize_n_Wrap(u300, 0, 0)
v300_std=dim_standardize_n_Wrap(v300, 0, 0)

dd_std=dim_standardize_n_Wrap(dd, 0, 0)


;;;;;;;;;initialize variable

kmeansInput=new((/ntimes,5*nlat*nlon/),typeof(slp))
printVarSummary(kmeansInput)


;;;;;;;;;;;;;;;;; get data on given days

i=0
do yr=1980,2014

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
JTime1=cd_inv_calendar(yr,mon,da,3,00,00,units,0)
 
kmeansInput(i,0:nlat*nlon-1)=ndtooned(slp_std({JTime},:,:))
kmeansInput(i,nlat*nlon:nlat*nlon*2-1)=ndtooned(z500_std({JTime},:,:))
kmeansInput(i,nlat*nlon*2:nlat*nlon*3-1)=ndtooned(u300_std({JTime},:,:))
kmeansInput(i,nlat*nlon*3:nlat*nlon*4-1)=ndtooned(v300_std({JTime},:,:))
kmeansInput(i,nlat*nlon*4:nlat*nlon*5-1)=ndtooned(dd_std({JTime1},:,:))
i=i+1

end do
end do
end do


 ncdf = addfile("kmeansInput_slp_z500_uv300_dd_allDays_1980_2014.nc" ,"c")  ; open output netCDF file
 ncdf->kmeansInput=kmeansInput

end
