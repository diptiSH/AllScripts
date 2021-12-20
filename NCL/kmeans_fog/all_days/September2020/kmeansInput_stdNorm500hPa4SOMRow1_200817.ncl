;;;;;;;;;;;;;; code to prepare input for kmeans
;;;;;;;;;;; intended output is like nc file with variable 
;;;variable structure is like each row represents a day and standard values of variables
;;;at diffent levels and over area are appended as 1D array


begin

years=ispan(1980,2019,1)
nyrs=dimsizes(years)
ntimes=nyrs*62

;;;; add anomaly normalised by standard deviation data files

;fslp=addfile("/home/cccr/rameshv/dipti/Data/eraDown/StdAnomERA5PerDay_.75_decJan_1979_2019_z500_download.nc","r")

fslp=addfile("/home/cccr/rameshv/dipti/Data/eraDown/ERA5to19/StdAnomERA5PerDay_.75_decJan_1979_2019_z500_download.nc","r")


;;;; read variables
slp=short2flt(fslp->z(:,{20:40},{60:85}))


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

;;;;;;;;;;;;;;; get 4-node SOM analysis file
somInput=asciiread("/home/cccr/rameshv/dipti/pySom/August2020/final_2_2_SOM/Write2_by_2.txt",-1,"string")
printVarSummary(somInput)

count_SOM0=num(somInput.eq."0_0")
count_SOM1=num(somInput.eq."0_1")
count_SOM2=num(somInput.eq."1_0")
count_SOM3=num(somInput.eq."1_1")
print(count_SOM0)
print(count_SOM1)
print(count_SOM2)
print(count_SOM3)


;;;;;;;;;initialize variable

;kmeansInput=new((/count_SOM0,nlat*nlon/),typeof(slp))
;kmeansInput=new((/count_SOM1,nlat*nlon/),typeof(slp))
;kmeansInput=new((/count_SOM2,nlat*nlon/),typeof(slp))
kmeansInput=new((/count_SOM3,nlat*nlon/),typeof(slp))
printVarSummary(kmeansInput)



;;;;;;;;;;;;;;;;; get data on given days
in=0
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
; if(somInput(i).eq."0_0")then
; if(somInput(i).eq."0_1")then
; if(somInput(i).eq."1_0")then
 if(somInput(i).eq."1_1")then
kmeansInput(in,0:nlat*nlon-1)=ndtooned(slp_std({JTime},:,:))
in=in+1
end if
i=i+1
end do
end do
end do


; ncdf = addfile("kmeansInput_z500_4nodesSOM0_stdnormAnom_20-40_60-85_1980_2019.nc" ,"c")  ; open output netCDF file
; ncdf = addfile("kmeansInput_z500_4nodesSOM1_stdnormAnom_20-40_60-85_1980_2019.nc" ,"c")  ; open output netCDF file
; ncdf = addfile("kmeansInput_z500_4nodesSOM2_stdnormAnom_20-40_60-85_1980_2019.nc" ,"c")  ; open output netCDF file
 ncdf = addfile("kmeansInput_z500_4nodesSOM3_stdnormAnom_20-40_60-85_1980_2019.nc" ,"c")  ; open output netCDF file
 ncdf->kmeansInput=kmeansInput

end
