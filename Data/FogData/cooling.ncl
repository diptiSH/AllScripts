begin

inFile=addfile("/home/cccr/rameshv/dipti/Data/FogData/NCDCDetails.nc","r")

maxT=inFile->maxTemp
minT=inFile->minTemp

cooling=new((/dimsizes(maxT(:,0,0,0)),dimsizes(maxT(0,:,0,0)),dimsizes(maxT(0,0,:,0)),dimsizes(maxT(0,0,0,:))/),typeof(maxT));;;;;  maxT ;;;;;;;;; trick to copy metadata
copy_VarMeta(maxT,cooling)
cooling@long_name = "max Temp previous day - min temp today"           ; assign attributes 
printVarSummary(cooling)

do year=1979,2019 ;;;;;;; year loop
 do m=1,2 ;;;;;;;; month loop
   if(m.eq.1)then
     month=m
     stDay=1
   else
     month=12
     stDay=2
   end if
   do d = stDay,31 ;;;;;;; day loop
           print(year)
      print(month)
      print(d)
    if(d.eq.1) then
    if(year.ne.1979)then

    cooling(:,{year},{month},{d})=maxT(:,{year-1},{12},{31})-minT(:,{year},{month},{d})
    end if
    else
    cooling(:,{year},{month},{d})=maxT(:,{year},{month},{d-1})-minT(:,{year},{month},{d})
    end if
   end do ;;;;;; day loop end 
 end do ;;;;;;;;;;; month loop end
end do ;;;;;;; year loop end

;;;;;;;;;write data to nc file
ncdf = addfile("NCDCCooling.nc" ,"c")  ; open output netCDF file

ncdf->cooling=cooling


end
