;;;;;;;;;;;;;; code to prepare input for kmeans
;;;;;;;;;;; intended output is like nc file with variable 
;;;variable structure is like each row represents a day and standard values of variables
;;;at diffent levels and over area are appended as 1D array


begin


;;;; add anomaly normalised by standard deviation data files

fslp=addfile("/home/cccr/rameshv/dipti/Data/eraDown/ERA5PerDay_.75_decJan_1979_2018_z500_download.nc","r")


;;;; read variables
slp=short2flt(fslp->z(:,{10:60},{0:120}))


time=fslp->time
unit=time@units
print(unit)
ntimes=dimsizes(time)


latitude=slp&latitude
longitude=slp&longitude
nlat=dimsizes(latitude)
nlon=dimsizes(longitude)
print(nlat)
print(nlon)


slp_std=dim_standardize_n_Wrap(slp, 0, 0)


;;;;;;;;;initialize variable

kmeansInput=new((/ntimes,nlat*nlon/),typeof(slp))
printVarSummary(kmeansInput)


;;;;;;;;;;;;;;;;; get data on given days

do i=0,ntimes-1

kmeansInput(i,0:nlat*nlon-1)=ndtooned(slp_std(i,:,:))

end do

 ncdf = addfile("kmeansInput_LargeDomain_z500_allDays.nc" ,"c")  ; open output netCDF file
 ncdf->kmeansInput=kmeansInput

end
