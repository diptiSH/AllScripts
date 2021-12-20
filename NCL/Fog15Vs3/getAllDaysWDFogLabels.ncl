begin

;;;;;;;;;;;;;;;;;;;**************** WD Data
data=asciiread("/home/cccr/rameshv/dipti/NCL/WDAnalysis/era-interim-derived-wd-tracks.csv",-1,"string")
;print(data)

delim=","
 eventId= stringtoint( str_get_field(data, 1, delim))
; print(eventId)

lon= stringtofloat(str_get_field(data, 2, delim))
;print(lon)

lat= stringtofloat(str_get_field(data, 3, delim))
;print(lat)

intensity=stringtofloat(str_get_field(data, 4, delim))

;eventID=stringto(str_get_field(data, 6, delim))

size=stringtofloat(str_get_field(data, 5, delim))

timeStepID= stringtoint( str_get_field(data, 10, delim))
;print(timeStepID)

DateTime= str_get_field(data, 8, delim)
;print(DateTime)

delim=" "
Date=str_get_field(DateTime, 1, delim)
;print(Date)

Time=str_get_field(DateTime, 2, delim)
;rint(Time)

delim="-"
day= stringtoint(str_get_field(Date,1,delim))
month= stringtoint(str_get_field(Date,2,delim))
year= stringtoint(str_get_field(Date,3,delim))

delim=":"
time=stringtoint(str_get_field(Time,1,delim))



;*******fog data
fogfile=addfile("/home/cccr/rameshv/dipti/Data/CombineStation_fog_data_24.nc","r")
fogdata=fogfile->fogdata
printVarSummary(fogdata)

nyrs=dimsizes(ispan(1998,2014,1))
outString=new((nyrs*2*31),"string")

innn=0
do yr=1998,2014
 do mon=1,2
  if(mon.eq.2)then
    mn=12
  else
    mn=mon
  end if
  do d=1,31
  wdNo=0  
  cntObs=0
  do i=0,dimsizes(lon)-1

    if (yr.eq.year(i) .and. mn.eq.month(i) .and. d.eq.day(i) .and. (lon(i).ge.70 .and. lon(i).le.90 ) .and. lat(i).le.32 )then
	       cntObs=cntObs+1
    end if
 end do
	
	if(cntObs.eq.0)then
        wdNo=0
   else
   
    eventIDS=new(cntObs,"integer")
    inn=0
    do i=0,dimsizes(lon)-1
     if (yr.eq.year(i) .and. mn.eq.month(i) .and. d.eq.day(i) .and. (lon(i).ge.70 .and. lon(i).le.90 ) .and. lat(i).le.32 )then
  
      eventIDS(inn)=eventId(i) 
      inn=inn+1
      end if
    end do
	wdNo=num(get_unique_values(eventIDS))
      delete(eventIDS)
	end if
	
	if(sum(fogdata({:},{yr},{mn},{d})).ge.15 .and. wdNo.eq.0) then
	 outString(innn)=yr+"-"+mn+"-"+d+","+"WD0 GTE15"
	 
	else
	
	  if(sum(fogdata({:},{yr},{mn},{d})).ge.15 .and. wdNo.gt.0) then
	     outString(innn)=yr+"-"+mn+"-"+d+","+"WD1 GTE15"
	 
	  else
	    if(sum(fogdata({:},{yr},{mn},{d})).le.3 .and. wdNo.gt.0) then
	     outString(innn)=yr+"-"+mn+"-"+d+","+"WD1 LTE3"
	 
	    else
		
		 if(sum(fogdata({:},{yr},{mn},{d})).le.3 .and. wdNo.eq.0) then
	     outString(innn)=yr+"-"+mn+"-"+d+","+"WD0 LTE3"
		
	 
	    else
	       outString(innn)=yr+"-"+mn+"-"+d+","
        end if
	
        end if
	  
	
      end if	
	
    end if	 
	
	
  innn=innn+1
  
    end do
 end do
end do


asciiwrite ("WD_fog_labels_allDays.txt",outString)

end
