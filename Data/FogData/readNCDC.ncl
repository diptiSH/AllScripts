load "readLibNcdc.ncl"


begin
;;;;;;; Constants

stationList=(/42071 , 42101 , 42131 , 42182 , 42369 , 42379 , 42475 , 42492 , 42591  /)
nstations=dimsizes(stationList)
nyears=dimsizes(ispan(1979,2019,1))
;;;;;;;; fog presence
       fogdata=new((/nstations,nyears,2,31/),"integer",9)
       fogdata!0    = "stations"                      ; assign named dimensions
       fogdata!1    = "years"
       fogdata!2    = "months"
       fogdata!3    = "days"
       
       fogdata&stations  = stationList                      ; copy lat from T to ORO
       fogdata&years  = ispan(1979,2019,1)
       fogdata&months=(/1,12/)
       fogdata&days=ispan(1,31,1) 

       fogdata@long_name = "fog presence (ncdc)"           ; assign attributes 
;       fogdata@units     = "m"
;;;;;;;;;;;;; mean temperature
       meanTemp=new((/nstations,nyears,2,31/),"float",99999.9)
       meanTemp!0    = "stations"                      ; assign named dimensions
       meanTemp!1    = "years"
       meanTemp!2    = "months"
       meanTemp!3    = "days"
       
       meanTemp&stations  = stationList                      ; copy lat from T to ORO
       meanTemp&years  = ispan(1979,2019,1)
       meanTemp&months=(/1,12/)
       meanTemp&days=ispan(1,31,1) 

       meanTemp@long_name = "mean temperature  (ncdc)"           ; assign attributes 
       meanTemp@units     = "F"

;;;;;;;;;;;;;;; mean dew point temp
       meanDewTemp=new((/nstations,nyears,2,31/),"float",99999.9)
       meanDewTemp!0    = "stations"                      ; assign named dimensions
       meanDewTemp!1    = "years"
       meanDewTemp!2    = "months"
       meanDewTemp!3    = "days"
       
       meanDewTemp&stations  = stationList                      ; copy lat from T to ORO
       meanDewTemp&years  = ispan(1979,2019,1)
       meanDewTemp&months=(/1,12/)
       meanDewTemp&days=ispan(1,31,1) 

       meanDewTemp@long_name = "mean dew point temperature  (ncdc)"           ; assign attributes 
       meanDewTemp@units     = "F"

;;;;;;;;;;;;;;; mean dew point depression temp
       meanDD=new((/nstations,nyears,2,31/),"float",99999.9)
       meanDD!0    = "stations"                      ; assign named dimensions
       meanDD!1    = "years"
       meanDD!2    = "months"
       meanDD!3    = "days"
       
       meanDD&stations  = stationList                      ; copy lat from T to ORO
       meanDD&years  = ispan(1979,2019,1)
       meanDD&months=(/1,12/)
       meanDD&days=ispan(1,31,1) 

       meanDD@long_name = "mean dew point depression  (ncdc)"           ; assign attributes 
       meanDD@units     = "F"


;;;;;;;;;;;;;;; mean sea level pressure
       meanMSLP=new((/nstations,nyears,2,31/),"float",99999.9)
       meanMSLP!0    = "stations"                      ; assign named dimensions
       meanMSLP!1    = "years"
       meanMSLP!2    = "months"
       meanMSLP!3    = "days"
       
       meanMSLP&stations  = stationList                      ; copy lat from T to ORO
       meanMSLP&years  = ispan(1979,2019,1)
       meanMSLP&months=(/1,12/)
       meanMSLP&days=ispan(1,31,1) 

       meanMSLP@long_name = "mean mean sea level pressure  (ncdc)"           ; assign attributes 
       meanMSLP@units     = "hPa"


;;;;;;;;;;;;;;;;;;;;;; mean visibility
       meanVis=new((/nstations,nyears,2,31/),"float",99999.9)
       meanVis!0    = "stations"                      ; assign named dimensions
       meanVis!1    = "years"
       meanVis!2    = "months"
       meanVis!3    = "days"
       
       meanVis&stations  = stationList                      ; copy lat from T to ORO
       meanVis&years  = ispan(1979,2019,1)
       meanVis&months=(/1,12/)
       meanVis&days=ispan(1,31,1) 

       meanVis@long_name = "mean visibility  (ncdc)"           ; assign attributes 
       meanVis@units     = "miles"
;;;;;;;;;;;;;;;;;;;;;;; mean wind speed
       meanWind=new((/nstations,nyears,2,31/),"float",99999.9)
       meanWind!0    = "stations"                      ; assign named dimensions
       meanWind!1    = "years"
       meanWind!2    = "months"
       meanWind!3    = "days"
       
       meanWind&stations  = stationList                      ; copy lat from T to ORO
       meanWind&years  = ispan(1979,2019,1)
       meanWind&months=(/1,12/)
       meanWind&days=ispan(1,31,1) 

       meanWind@long_name = "mean wind speed  (ncdc)"           ; assign attributes 
       meanWind@units     = "knots"
;;;;;;;;;;;;;;;;;;;;;;; Maximum Temperature
       maxTemp=new((/nstations,nyears,2,31/),"float",99999.9)
       maxTemp!0    = "stations"                      ; assign named dimensions
       maxTemp!1    = "years"
       maxTemp!2    = "months"
       maxTemp!3    = "days"
       
       maxTemp&stations  = stationList                      ; copy lat from T to ORO
       maxTemp&years  = ispan(1979,2019,1)
       maxTemp&months=(/1,12/)
       maxTemp&days=ispan(1,31,1) 

       maxTemp@long_name = "maximum temperature  (ncdc)"           ; assign attributes 
       maxTemp@units     = "F"
;;;;;;;;;;;;;;;;;; Minimum Temperature
       minTemp=new((/nstations,nyears,2,31/),"float",99999.9)
       minTemp!0    = "stations"                      ; assign named dimensions
       minTemp!1    = "years"
       minTemp!2    = "months"
       minTemp!3    = "days"
       
       minTemp&stations  = stationList                      ; copy lat from T to ORO
       minTemp&years  = ispan(1979,2019,1)
       minTemp&months=(/1,12/)
       minTemp&days=ispan(1,31,1) 

       minTemp@long_name = "minimum temperature (ncdc)"           ; assign attributes 
       minTemp@units     = "F"

printVarSummary(fogdata)
do f=0,nstations-1  ;;;station loop      
do yr=1979,2019;;;;;;year loop
  fFlag=FileExistence(stationList(f),yr)
  if (fFlag) then ;;;; file existence check
;     print(yr + "  "+stationList(f))
    fgData=getNCDCData(stationList(f),yr)   
    fogdata(f,yr-1979,:,:)=(/fgData[0]/)
    meanTemp(f,yr-1979,:,:)=(/fgData[1]/)
    meanDewTemp(f,yr-1979,:,:)=(/fgData[2]/)    
    meanVis(f,yr-1979,:,:)=(/fgData[3]/) 
    meanWind(f,yr-1979,:,:)=(/fgData[4]/) 
    maxTemp(f,yr-1979,:,:)=(/fgData[5]/) 
    minTemp(f,yr-1979,:,:)=(/fgData[6]/) 
    meanDD(f,yr-1979,:,:)=(/fgData[7]/)    
    meanMSLP(f,yr-1979,:,:)=(/fgData[8]/)    
  end if        ;;;;;file existence check
end do  ;;;;station loop end
end do  ;;;; year loop end


;;;;;;;;;write data to nc file
ncdf = addfile("NCDCDetails2.nc" ,"c")  ; open output netCDF file

ncdf->fogdata=fogdata
ncdf->meanTemp=meanTemp
ncdf->meanDewTemp=meanDewTemp
ncdf->meanVis=meanVis
ncdf->meanWind=meanWind
ncdf->maxTemp=maxTemp
ncdf->minTemp=minTemp
ncdf->meanDD=meanDD
ncdf->meanMSLP=meanMSLP
             






end
