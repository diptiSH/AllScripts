;;;;;;;;;;;;;; code to prepare input for kmeans
;;;;;;;;;;; intended output is like nc file with variable 
;;;variable structure is like each row represents a day and standard values of variables
;;;at diffent levels and over area are appended as 1D array


begin

years=ispan(1980,2019,1)
nyrs=dimsizes(years)
ntimes=nyrs*62

;;;; add anomaly normalised by standard deviation data files

fdd=addfile("/home/cccr/rameshv/dipti/Data/eraDown/ERA5to19/StdAnomERA5_3UTC_.75_DecJan_1979_2019_dd_download.nc","r")
fuv950=addfile("/home/cccr/rameshv/dipti/Data/eraDown/ERA5to19/StdAnomERA5PerDay_.75_DecJan_1979_2019_uv950_download.nc","r")
;f200=addfile("/home/cccr/rameshv/dipti/Data/eraDown/ERA5to19/StdAnomERA5PerDay_.75_DecJan_1979_2019_z200_download.nc","r")

foro=addfile("/home/cccr/rameshv/dipti/Data/eraDown/ERA5to19/topography.nc","r")


;;;; read variables
dd=short2flt(fdd->t2m(:,{24:33},{70:90}))
u950=short2flt(fuv950->u(:,{24:33},{70:90}))
v950=short2flt(fuv950->v(:,{24:33},{70:90}))

z_old=short2flt(foro->z(0,{24:33},{70:90}))
z=z_old/9.81
copy_VarMeta(z_old,z)

lt500htPoints=num(z.lt.500.0)

time=fdd->time
units=time@units
print(units)

latitude=z&latitude
longitude=z&longitude
nlat=dimsizes(latitude)
nlon=dimsizes(longitude)
;print(nlat)
;print(nlon)

;;;;;;;;;initialize variable
kmeansInput=new((/ntimes,3*lt500htPoints/),typeof(dd))
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
  j=0
 do la=0,nlat-1
  do lo=0,nlon-1
  if(z(la,lo).lt.500.0)then
kmeansInput(i,j)=(dd({JTime},la,lo))
 j=j+1
end if
 end do
end do  

 do la=0,nlat-1
  do lo=0,nlon-1
  if(z(la,lo).lt.500.0)then
kmeansInput(i,j)=(u950({JTime},la,lo))
 j=j+1
 end if
 end do
end do

 do la=0,nlat-1
  do lo=0,nlon-1
  if(z(la,lo).lt.500.0)then
kmeansInput(i,j)=(v950({JTime},la,lo))
 j=j+1
 end if
 end do
end do


i=i+1

end do
end do
end do


 ncdf = addfile("kmeansInput_dd_uv950_allDays_stdnormAnom_24-33_70-90_1980_2019.nc" ,"c")  ; open output netCDF file
 ncdf->kmeansInput=kmeansInput

end