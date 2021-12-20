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


;;;;;;;;;;*******fog data
fogfile=addfile("/home/cccr/rameshv/dipti/Data/CombineStation_fog_data_24.nc","r")
fogdata=fogfile->fogdata
printVarSummary(fogdata)


;;;;;;;;;;;;; get count of days
cnt=0
cnt1=0
cnt2=0
cnt3=0

do yr=1979,2014
 do mon=1,2
  if(mon.eq.2)then
    mn=12
  else
    mn=mon
  end if
  do d=1,31
   wdPresence=0 
   cWDobs=0
   do i=0,dimsizes(lon)-1
    if (yr.eq.year(i) .and. mn.eq.month(i).and.d.eq.day(i) .and. (lon(i).ge.70 .and. lon(i).le.90 ) .and. lat(i).le.32 )then
       cWDobs= cWDobs+1
     wdPresence=1
    end if
   end do
   
   if(wdPresence.eq.0) then
      cnt=cnt+1
   else 
     wdEventIds=new(cWDobs,"integer")
     in2=0
     do i=0,dimsizes(lon)-1
       if (yr.eq.year(i) .and. mn.eq.month(i).and.d.eq.day(i) .and. (lon(i).ge.70 .and. lon(i).le.90 ) .and. lat(i).le.32 )then
         wdEventIds(in2)=eventId(i)       
         in2=in2+1
       end if
     end do
	 eventCnts=num(get_unique_values(wdEventIds))
	 if(eventCnts.eq.1)then
         cnt1=cnt1+1
     end if
	 if(eventCnts.eq.2)then
         cnt2=cnt2+1
     end if
	 if(eventCnts.eq.3)then
         cnt3=cnt3+1
     end if
	 delete(eventCnts)
     delete(wdEventIds)
	 
   end if
   
  end do
 end do  
end do  


print(cnt)
print(cnt1)
print(cnt2)
print(cnt3)





;;;;;;;;;;;;;;;;;;;;; get fog station distribution

foggySTations=new(cnt,"integer")
foggySTations1=new(cnt1,"integer")
foggySTations2=new(cnt2,"integer")
foggySTations3=new(cnt3,"integer")

in=0
in1=0
in22=0
in3=0

do yr=1979,2014
 do mon=1,2
  if(mon.eq.2)then
    mn=12
  else
    mn=mon
  end if
  do d=1,31
   wdPresence=0 
   cWDobs=0
   do i=0,dimsizes(lon)-1
    if (yr.eq.year(i) .and. mn.eq.month(i).and.d.eq.day(i) .and. (lon(i).ge.70 .and. lon(i).le.90 ) .and. lat(i).le.32 )then
       cWDobs= cWDobs+1
     wdPresence=1
    end if
   end do
   
   if(wdPresence.eq.0) then
      foggySTations(in)=sum(fogdata({:},{yr},{mn},{d}))
		 in=in+1
   else 
     wdEventIds=new(cWDobs,"integer")
     in2=0
     do i=0,dimsizes(lon)-1
       if (yr.eq.year(i) .and. mn.eq.month(i).and.d.eq.day(i) .and. (lon(i).ge.70 .and. lon(i).le.90 ) .and. lat(i).le.32 )then
         wdEventIds(in2)=eventId(i)       
         in2=in2+1
       end if
     end do
	 eventCnts=num(get_unique_values(wdEventIds))
	 if(eventCnts.eq.1)then
         foggySTations1(in1)=sum(fogdata({:},{yr},{mn},{d}))
		 in1=in1+1
     end if
	 if(eventCnts.eq.2)then
         foggySTations2(in22)=sum(fogdata({:},{yr},{mn},{d}))
		 in22=in22+1
     end if
	 if(eventCnts.eq.3)then
         foggySTations3(in3)=sum(fogdata({:},{yr},{mn},{d}))
		 in3=in3+1
     end if
	 delete(eventCnts)
     delete(wdEventIds)
	 
   end if
   
  end do
 end do  
end do 

print(foggySTations3)

qsort(foggySTations)
qsort(foggySTations1)
qsort(foggySTations2)




  x25  = round(.25*cnt,3)-1     ; -1 to account for NCL indexing starting
  x75  = round(.75*cnt,3)-1     ; at 0

  foggySTationVals=(/min(foggySTations),foggySTations(x25),dim_median(foggySTations),foggySTations(x75),max(foggySTations)/)

 x25  = round(.25*cnt1,3)-1     ; -1 to account for NCL indexing starting
  x75  = round(.75*cnt1,3)-1     ; at 0


  foggySTationVals1=(/min(foggySTations1),foggySTations1(x25),dim_median(foggySTations1),foggySTations1(x75),max(foggySTations1)/)
 x25  = round(.25*cnt2,3)-1     ; -1 to account for NCL indexing starting
  x75  = round(.75*cnt2,3)-1     ; at 0

  foggySTationVals2=(/min(foggySTations2),foggySTations2(x25),dim_median(foggySTations2),foggySTations2(x75),max(foggySTations2)/)
 
 
  wks = gsn_open_wks("png","WDFogAssociation_1979_2014")               ; send graphics to PNG file

  res            = True                         ; plot mods desired
  res@tmXBLabels = (/"NoWD","1WD","2WD"/) ; labels for each box
  
  res@tiMainString = "Box Plot"
  ;res@trYMinF = 230.
  ;res@trYMaxF = 345.

  plot = boxplot(wks,(/0,1,2/),(/foggySTationVals,foggySTationVals1,foggySTationVals2/),False,res,False)	
  draw(wks)                                    ; boxplot does not call these
  frame(wks)                                   ; for you




end
