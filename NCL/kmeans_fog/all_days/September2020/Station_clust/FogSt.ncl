begin

nStations=25

years=ispan(1980,2019,1)
nyrs=dimsizes(years)
ntimes=nyrs*62

input=new((/nStations,ntimes/),"integer")

 Ffog=addfile("/home/cccr/rameshv/dipti/Data/FogData/CombinedFogData_25Stations.nc","r")
  fog=Ffog->fogdata
  printVarSummary(fog)

do i=0,nStations-1

;;;;;;;;;;;;;;;;; get data on given days

j=0
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

if(.not.ismissing(fog(i,{year},{mon},{da})))then
input(i,j)=fog(i,{year},{mon},{da})
else
input(i,j)=5
end if

j=j+1

end do
end do
end do
         


end do


 ncdf = addfile("kmeansInput_StationFog.nc" ,"c")  ; open output netCDF file
 ncdf->input=input


end
