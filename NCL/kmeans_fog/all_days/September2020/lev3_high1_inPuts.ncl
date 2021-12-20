begin

years=ispan(1980,2019,1)
nyrs=dimsizes(years)
ntimes=nyrs*62


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

;;;;;;;; get Dates
somInput=asciiread("/home/cccr/rameshv/dipti/pySom/September2020/lev2/high1/Lev2_SOM0_fogCon9_wdCon9_1by2.txt",-1,"string")
printVarSummary(somInput)

Dates=str_get_field(somInput,1,",")
SOMNos=toint(str_get_field(somInput,2,","))

print(Dates)
print(SOMNos)

;;;;;;;; get count for each SOM
som0Cnt=num(SOMNos.eq.0)
som1Cnt=num(SOMNos.eq.1)

print(num(SOMNos.eq.0))
print(num(SOMNos.eq.1))


;;;;;; first SOM input
kmeansInput=new((/som0Cnt,nlat*nlon/),typeof(slp))
printVarSummary(kmeansInput)
DatesInput=new(som0Cnt,"string")

in=0
do i=0,som0Cnt-1
  year=toint(str_get_field(Dates(i),1,"-"))
  mon=toint(str_get_field(Dates(i),2,"-"))
  da=toint(str_get_field(Dates(i),3,"-"))
  JTime=cd_inv_calendar(year,mon,da,9,00,00,units,0)
  kmeansInput(in,0:nlat*nlon-1)=ndtooned(slp_std({JTime},:,:))
  DatesInput(in)=tostring(year)+"-"+tostring(mon)+"-"+tostring(da)
  in=in+1
end do

ncdf = addfile("kmeansInput_z500_lev2high1_SOM0_stdnormAnom_20-40_60-85_1980_2019.nc" ,"c")  ; open output netCDF file
ncdf->kmeansInput=kmeansInput
asciiwrite("lev2high1SOM0_Dates.txt",DatesInput)
delete(DatesInput)
delete(kmeansInput)

;;;;;; second SOM input
kmeansInput=new((/som1Cnt,nlat*nlon/),typeof(slp))
printVarSummary(kmeansInput)
DatesInput=new(som1Cnt,"string")

in=0
do i=som0Cnt,som0Cnt+som1Cnt-1
  year=toint(str_get_field(Dates(i),1,"-"))
  mon=toint(str_get_field(Dates(i),2,"-"))
  da=toint(str_get_field(Dates(i),3,"-"))
  JTime=cd_inv_calendar(year,mon,da,9,00,00,units,0)
  kmeansInput(in,0:nlat*nlon-1)=ndtooned(slp_std({JTime},:,:))
  DatesInput(in)=tostring(year)+"-"+tostring(mon)+"-"+tostring(da)
  in=in+1 
end do

ncdf1 = addfile("kmeansInput_z500_lev2high1_SOM1_stdnormAnom_20-40_60-85_1980_2019.nc" ,"c")  ; open output netCDF file
ncdf1->kmeansInput=kmeansInput
asciiwrite("lev2high1SOM1_Dates.txt",DatesInput)
delete(DatesInput)



end
