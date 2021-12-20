;;;;;;;;;;;;;; code to prepare input for kmeans
;;;;;;;;;;; intended output is like nc file with variable 
;;;variable structure is like each row represents a day and standard values of variables
;;;at diffent levels and over area are appended as 1D array


begin


;;;; add anomaly normalised by standard deviation data files
fdd=addfile("/home/cccr/rameshv/dipti/Data/eraDown/ERA5_.75_decJan_1979_2018_d2m_t2m_3_download.nc","r")
fWind=addfile("/home/cccr/rameshv/dipti/Data/eraDown/ERA5_.75_decJan_1979_2018_u10_v10_3_download.nc","r")
f950temp=addfile("/home/cccr/rameshv/dipti/Data/eraDown/ERA5_.75_decJan_1979_2018_t950_3_download.nc","r")
fslp=addfile("/home/cccr/rameshv/dipti/Data/eraDown/ERA5_.75_decJan_1979_2018_slp_3_download.nc","r")


;;;; read variables
d2m=short2flt(fdd->d2m(:,{20:35},{70:90}))
t2m=short2flt(fdd->t2m(:,{20:35},{70:90}))
u10=short2flt(fWind->u10(:,{20:35},{70:90}))
v10=short2flt(fWind->v10(:,{20:35},{70:90}))
t950=short2flt(f950temp->t(:,{20:35},{70:90}))
slp=short2flt(fslp->msl(:,{20:35},{70:90}))

printVarSummary(d2m)
printVarSummary(t2m)
printVarSummary(u10)
printVarSummary(v10)
printVarSummary(t950)

time=fdd->time
unit=time@units
print(unit)


latitude=t950&latitude
longitude=t950&longitude
nlat=dimsizes(latitude)
nlon=dimsizes(longitude)
print(nlat)
print(nlon)


dd=t2m
dd=t2m-d2m

inv=t2m
inv=t2m-t950

wind=wind_speed(u10,v10)

slp_std=dim_standardize_n_Wrap(slp, 0, 0)

v10_std=dim_standardize_n_Wrap(v10, 0, 0)

t2m_std=dim_standardize_n_Wrap(t2m, 0, 0)

dd_std=dim_standardize_n_Wrap(dd, 0, 0)
printVarSummary(dd_std)

inv_std=dim_standardize_n_Wrap(inv, 0, 0)
printVarSummary(inv_std)

wind_std=dim_standardize_n_Wrap(wind, 0, 0)
printVarSummary(wind_std)


;;;;;;;;; read tes

;print(Dates)

data=asciiread("Dates.txt",-1,"string")

print(data)

delim="-"
year=toint(str_get_field(data, 1, delim))
month=toint(str_get_field(data, 2, delim))
day=toint(str_get_field(data, 3, delim))

;;;;;;;;;initialize variable

kmeansInput=new((/dimsizes(data),nlat*nlon/),typeof(dd))
printVarSummary(kmeansInput)

;;;;;;;;;; loop through

print(nlat*nlon)
print(nlat*nlon*2)
print(nlat*nlon*3)

;;;;;;;;;;;;;;;;; get data on given days

do i=0,dimsizes(data)-1
JTime=cd_inv_calendar(year(i),month(i),day(i),3,00,00,unit,0)
kmeansInput(i,0:nlat*nlon-1)=ndtooned(slp_std({JTime},:,:))
;kmeansInput(i,0:nlat*nlon-1)=ndtooned(dd_std({JTime},:,:))
;kmeansInput(i,nlat*nlon:nlat*nlon*2-1)=ndtooned(wind_std({JTime},:,:))
;kmeansInput(i,nlat*nlon*2:nlat*nlon*3-1)=ndtooned(wind_std({JTime},:,:))
;kmeansInput(i,nlat*nlon*3:nlat*nlon*4-1)=ndtooned(inv_std({JTime},:,:))


end do

 ncdf = addfile("kmeansInput_slp.nc" ,"c")  ; open output netCDF file
 ncdf->kmeansInput=kmeansInput

end
