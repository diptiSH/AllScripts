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

eventID=stringtofloat(str_get_field(data, 6, delim))

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


;;;;;;;;;;*******fog data
fogfile=addfile("/home/cccr/rameshv/dipti/Data/CombineStation_fog_data_24.nc","r")
fogdata=fogfile->fogdata
printVarSummary(fogdata)

geStations=0

;;;;;;;;;;;;; get count of days
cnt=0
cnt15=0
cnt20=0
cnt2=0
cnt0=0
do yr=1979,2014
 do mon=1,2
  if(mon.eq.2)then
    mn=12
  else
    mn=mon
  end if
  do d=1,31
   if(sum(fogdata({:},{yr},{mn},{d})) .ge. geStations) then
   ;  print(sum(fogdata({:},{yr},{mn},{d})))
     ;print(yr+"-"+mn+"-"+d)
    cnt=cnt+1  
	if(sum(fogdata({:},{yr},{mn},{d})) .ge. 15)
	 cnt15=cnt15+1
	end if
	if(sum(fogdata({:},{yr},{mn},{d})) .ge. 20)
	 cnt20=cnt20+1
		end if
	if(sum(fogdata({:},{yr},{mn},{d})) .le. 0)
	 cnt0=cnt0+1
	end if
	if(sum(fogdata({:},{yr},{mn},{d})) .le. 2)
	 cnt2=cnt2+1
	
	end if
   end if
  end do
 end do
end do

print(cnt)
print(cnt0)
print(cnt2)
print(cnt15)
print(cnt20)

;exit
;;;;;;;;;;;;;;;;;;; Get WD count

wdDIst=new(cnt,"integer")

wdDIst0=new(cnt0,"integer")
wdDIst2=new(cnt2,"integer")
wdDIst15=new(cnt15,"integer")
wdDIst20=new(cnt20,"integer")

in=0
in0=0
in2=0
in15=0
in20=0

do yr=1979,2014
 do mon=1,2
  if(mon.eq.2)then
    mn=12
  else
    mn=mon
  end if
  do d=1,31
   if(sum(fogdata({:},{yr},{mn},{d})) .ge. geStations) then
   ;  print(sum(fogdata({:},{yr},{mn},{d})))
     ;print(yr+"-"+mn+"-"+d)
     cntObs=0
     do i=0,dimsizes(lon)-1
       if (yr.eq.year(i) .and. mn.eq.month(i).and.d.eq.day(i) .and. (lon(i).ge.70 .and. lon(i).le.90 ) .and. lat(i).le.32 )then
	       cntObs=cntObs+1
       end if
     end do
	 
	 if(cntObs.eq.0)then
	 wdDIst(in)=0
	 in=in+1
	 else
     eventIds=new(cntObs,integer)	
       inn=0	 
	 do i=0,dimsizes(lon)-1
       if (yr.eq.year(i) .and. mn.eq.month(i).and.d.eq.day(i) .and. (lon(i).ge.70 .and. lon(i).le.90 ) .and. lat(i).le.32 )then
	       eventIds(inn)=eventId(i)
		   inn=inn+1
       end if
     end do
	 wdDIst(in)=num(get_unique_values(eventIds))
	 in=in+1
	 delete(eventIds)
	 end if
	 
	 
	
	if(sum(fogdata({:},{yr},{mn},{d})) .ge. 15)
	 cntObs=0
     do i=0,dimsizes(lon)-1
       if (yr.eq.year(i) .and. mn.eq.month(i).and.d.eq.day(i) .and. (lon(i).ge.70 .and. lon(i).le.90 ) .and. lat(i).le.32 )then
	       cntObs=cntObs+1
       end if
     end do
	 if(cntObs.eq.0)then
	 wdDIst15(in15)=0
	 in15=in15+1
	 else
     eventIds=new(cntObs,integer)	
       inn=0	 
	 do i=0,dimsizes(lon)-1
       if (yr.eq.year(i) .and. mn.eq.month(i).and.d.eq.day(i) .and. (lon(i).ge.70 .and. lon(i).le.90 ) .and. lat(i).le.32 )then
	       eventIds(inn)=eventId(i)
		   inn=inn+1
       end if
     end do
	 wdDIst15(in15)=num(get_unique_values(eventIds))
	 in15=in15+1
	 delete(eventIds)
	end if
	end if

	if(sum(fogdata({:},{yr},{mn},{d})) .ge. 20)
	    
		cntObs=0
     do i=0,dimsizes(lon)-1
       if (yr.eq.year(i) .and. mn.eq.month(i).and.d.eq.day(i) .and. (lon(i).ge.70 .and. lon(i).le.90 ) .and. lat(i).le.32 )then
	       cntObs=cntObs+1
       end if
     end do
	 if(cntObs.eq.0)then
	 wdDIst20(in20)=0
	 in20=in20+1
	 else
	 
     eventIds=new(cntObs,integer)	
       inn=0	 
	 do i=0,dimsizes(lon)-1
       if (yr.eq.year(i) .and. mn.eq.month(i).and.d.eq.day(i) .and. (lon(i).ge.70 .and. lon(i).le.90 ) .and. lat(i).le.32 )then
	       eventIds(inn)=eventId(i)
		   inn=inn+1
       end if
     end do
	 wdDIst20(in20)=num(get_unique_values(eventIds))
	 in20=in20+1
	 delete(eventIds)
	 end if
	end if
	
	
	if(sum(fogdata({:},{yr},{mn},{d})) .le. 0)
	 
	 cntObs=0
     do i=0,dimsizes(lon)-1
       if (yr.eq.year(i) .and. mn.eq.month(i).and.d.eq.day(i) .and. (lon(i).ge.70 .and. lon(i).le.90 ) .and. lat(i).le.32 )then
	       cntObs=cntObs+1
       end if
     end do
	 
	 if(cntObs.eq.0)then
	 wdDIst0(in0)=0
	 in0=in0+1
	 else
     eventIds=new(cntObs,integer)	
       inn=0	 
	 do i=0,dimsizes(lon)-1
       if (yr.eq.year(i) .and. mn.eq.month(i).and.d.eq.day(i) .and. (lon(i).ge.70 .and. lon(i).le.90 ) .and. lat(i).le.32 )then
	       eventIds(inn)=eventId(i)
		   inn=inn+1
       end if
     end do
	 wdDIst0(in0)=num(get_unique_values(eventIds))
	 in0=in0+1
	 delete(eventIds)
	 end if
	end if

	if(sum(fogdata({:},{yr},{mn},{d})) .le. 2)
	 cntObs=0
     do i=0,dimsizes(lon)-1
       if (yr.eq.year(i) .and. mn.eq.month(i).and.d.eq.day(i) .and. (lon(i).ge.70 .and. lon(i).le.90 ) .and. lat(i).le.32 )then
	       cntObs=cntObs+1
       end if
     end do
	 if(cntObs.eq.0)then
	 wdDIst2(in2)=0
	 in2=in2+1
	 else
     eventIds=new(cntObs,integer)	
       inn=0	 
	 do i=0,dimsizes(lon)-1
       if (yr.eq.year(i) .and. mn.eq.month(i).and.d.eq.day(i) .and. (lon(i).ge.70 .and. lon(i).le.90 ) .and. lat(i).le.32 )then
	       eventIds(inn)=eventId(i)
		   inn=inn+1
       end if
     end do
	 wdDIst2(in2)=num(get_unique_values(eventIds))
	 in2=in2+1
	 delete(eventIds)
	end if
	end if
   end if
  end do
 end do
end do


qsort( wdDIst)
qsort( wdDIst15)
qsort( wdDIst20)
qsort( wdDIst0)
qsort( wdDIst2)


  x25  = round(.25*cnt,3)-1     ; -1 to account for NCL indexing starting
  x75  = round(.75*cnt,3)-1     ; at 0 
  
  latVals=(/min( wdDIst), wdDIst(x25),dim_median( wdDIst), wdDIst(x75),max( wdDIst)/)

 x25  = round(.25*cnt15,3)-1     ; -1 to account for NCL indexing starting
  x75  = round(.75*cnt15,3)-1     ; at 0


  latVals15=(/min( wdDIst15), wdDIst15(x25),dim_median( wdDIst15), wdDIst15(x75),max( wdDIst15)/)
 x25  = round(.25*cnt20,3)-1     ; -1 to account for NCL indexing starting
  x75  = round(.75*cnt20,3)-1     ; at 0

  latVals20=(/min( wdDIst20), wdDIst20(x25),dim_median( wdDIst20), wdDIst20(x75),max( wdDIst20)/)
 x25  = round(.25*cnt2,3)-1     ; -1 to account for NCL indexing starting
  x75  = round(.75*cnt2,3)-1     ; at 0

  latVals2=(/min( wdDIst2), wdDIst2(x25),dim_median( wdDIst2), wdDIst2(x75),max( wdDIst2)/)
 x25  = round(.25*cnt0,3)-1     ; -1 to account for NCL indexing starting
  x75  = round(.75*cnt0,3)-1     ; at 0

  latVals0=(/min( wdDIst0), wdDIst0(x25),dim_median( wdDIst0), wdDIst0(x75),max( wdDIst0)/)


print(latVals)
print(latVals0)
print(latVals2)
print(latVals15)
print(latVals20)

wks = gsn_open_wks("png","box_WDCount_79-14_7525")               ; send graphics to PNG file

  res            = True                         ; plot mods desired
  res@tmXBLabels = (/"AllDays","0Fog","le2","ge15","ge20"/) ; labels for each box
  
  res@tiMainString = "Box Plot"
  ;res@trYMinF = 230.
  ;res@trYMaxF = 345.

  plot = boxplot(wks,(/0,1,2,3,4/),(/latVals,latVals0,latVals2,latVals15,latVals20/),False,res,False)	
  draw(wks)                                    ; boxplot does not call these
  frame(wks)                                   ; for you
  
  end