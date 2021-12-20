begin

;;;;;;;;******* constants
years=ispan(1981,2019,1)
months=(/1,12/)
day=ispan(1,31,1)
days=dimsizes(years)*dimsizes(months)*dimsizes(day)
print(days)


stationList=(/42071 , 42101 , 42131 , 42182 , 42369 , 42379 , 42475 , 42492 , 42591  /)
stationNums=dimsizes(stationList)
lats=(/31.38 , 30.2 , 29.1 , 28.35 , 26.45 , 26.45 , 25.27 , 25.36 , 24.45 /)
lons=(/74.5 , 76.3 , 75.4 , 77.1 , 80.5 , 83.2 , 81.4 , 85.1 , 84.6/)

;;;;;;;;;;*******fog data
fogfile=addfile("/home/cccr/rameshv/dipti/Data/FogData/CombinedFogData_25Stations.nc","r")
fogdata=fogfile->fogdata
printVarSummary(fogdata(:,:,:,:))
;exit
stationS=fogfile->stations
stations=dimsizes(stationS)
;print(stationS)
;print(fogdata)

data_points=0
do i=0,stationNums-1
data_points=data_points+num(.not.ismissing(fogdata({stationList(i)},{1979:2019},:,:)))
end do

print(data_points)

labels=new(data_points,"integer")
fetureinput=new((/data_points,7/),"float")


;;add data files
fDetailsfile=addfile("/home/cccr/rameshv/dipti/Data/FogData/NCDCDetails2.nc","r")
meanTemp=fDetailsfile->meanTemp
meanDewTemp=fDetailsfile->meanDewTemp
meanDD=fDetailsfile->meanDD
meanMSLP=fDetailsfile->meanMSLP
meanWind=fDetailsfile->meanWind



k=0

do i=0,stationNums-1

do y=1979,2019
 do m=1,2
  if(m.eq.2)then
    mon=12
   else
     mon=1
  end if
  do d=1,31
     
   if(.not.ismissing(fogdata({stationList(i)},{y},{mon},{d}) ) )then
   labels(k)=fogdata({stationList(i)},{y},{mon},{d})
   if(meanTemp({stationList(i)},{y},{mon},{d}) .ne. 9999.9)then
   fetureinput(k,0)=meanTemp({stationList(i)},{y},{mon},{d})
   end if
   if(meanDewTemp({stationList(i)},{y},{mon},{d}) .ne. 9999.9)then
   fetureinput(k,1)=meanDewTemp({stationList(i)},{y},{mon},{d})
   end if
   if(meanDD({stationList(i)},{y},{mon},{d}) .ne. 9999.9)then
   fetureinput(k,2)=meanDD({stationList(i)},{y},{mon},{d})
   end if
   if(meanMSLP({stationList(i)},{y},{mon},{d}) .ne. 9999.9)then
   fetureinput(k,3)=meanMSLP({stationList(i)},{y},{mon},{d})
   end if
   if(meanWind({stationList(i)},{y},{mon},{d}) .ne. 9999.9)then
   fetureinput(k,4)=meanWind({stationList(i)},{y},{mon},{d})
   end if
   fetureinput(k,5)=lats(i)
   fetureinput(k,6)=lons(i)
  
   
   k=k+1

 end if


  end do
 end do
end do


end do

 ncdf = addfile("/home/cccr/rameshv/dipti/pySom/Data/inputNCDC.nc" ,"c")  ; open output netCDF file
 ncdf->labels=labels
 ncdf->fetureinput=fetureinput


end
