begin


f=addfile("CombinedFogData_25Stations.nc","r")
fog=f->fogdata
nVals=2542

outString=new(nVals,"string")
inn=0
printVarSummary(outString)

do yr=1979,2019
 do mon=1,2
  if(mon.eq.2)then
    mn=12
  else
    mn=mon
  end if
  do d=1,31
  outString(inn)=yr+"-"+mn+"-"+d+","+sum(fog({:},{yr},{mn},{d}))
  inn=inn+1
 
end do
end do
end do


asciiwrite ("foggyStations.txt",outString)






end
