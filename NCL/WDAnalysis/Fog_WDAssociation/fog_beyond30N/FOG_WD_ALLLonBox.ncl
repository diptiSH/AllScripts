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
do yr=1998,2014
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
	if(sum(fogdata({:},{yr},{mn},{d})) .le. 3)
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

;;;;;;;;;;;;;;;;;; get counts of obs when WD  between 70 to 90 E 

counts=0
counts15=0
counts20=0
counts2=0
counts0=0

do yr=1998,2014
 do mon=1,2
  if(mon.eq.2)then
    mn=12
  else
    mn=mon
  end if
  do d=1,31
   if(sum(fogdata({:},{yr},{mn},{d})) .ge. geStations) then
   ;  print(sum(fogdata({:},{yr},{mn},{d})))
    ; print(yr+"-"+mn+"-"+d)
     do i=0,dimsizes(lon)-1
       if (yr.eq.year(i) .and. mn.eq.month(i).and.d.eq.day(i) .and. (lon(i).ge.70 .and. lon(i).le.90 ) .and. lat(i).le.32 )then
       counts=counts+1
	 ; print(yr+"-"+mn+"-"+d)
	 
	 if(sum(fogdata({:},{yr},{mn},{d})) .ge. 15)
	 counts15=counts15+1
	end if
	if(sum(fogdata({:},{yr},{mn},{d})) .ge. 20)
	 counts20=counts20+1
		end if
	if(sum(fogdata({:},{yr},{mn},{d})) .le. 0)
	 counts0=counts0+1
	end if
	if(sum(fogdata({:},{yr},{mn},{d})) .le. 3)
	 counts2=counts2+1
	
	end if
	 
	 
       end if
     end do
     end if
  end do
 end do
end do
print("ooooooooooooooooooooooooooooook")
print(counts)
print(counts0)
print(counts2)
print(counts15)
print(counts20)




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; get lats

lats=new(counts,"float")
lats15=new(counts15,"float")
lats20=new(counts20,"float")
lats2=new(counts2,"float")
lats0=new(counts0,"float")

in=0
in15=0
in20=0
in2=0
in0=0
do yr=1998,2014
 do mon=1,2
  if(mon.eq.2)then
    mn=12
  else
    mn=mon
  end if
  do d=1,31
   if(sum(fogdata({:},{yr},{mn},{d})) .ge. geStations) then
   ;  print(sum(fogdata({:},{yr},{mn},{d})))
    ; print(yr+"-"+mn+"-"+d)
     do i=0,dimsizes(lon)-1
       if (yr.eq.year(i) .and. mn.eq.month(i).and.d.eq.day(i) .and. (lon(i).ge.70 .and. lon(i).le.90 )  .and. lat(i).le.32 )then
         lats(in)=lon(i)
	 in=in+1
	 
	 if(sum(fogdata({:},{yr},{mn},{d})) .ge. 15)
	   lats15(in15)=lon(i)
	 in15=in15+1
	end if
	if(sum(fogdata({:},{yr},{mn},{d})) .ge. 20)
	 lats20(in20)=lon(i)
	 in20=in20+1
		end if
	if(sum(fogdata({:},{yr},{mn},{d})) .le. 0)
	 lats0(in0)=lon(i)
	 in0=in0+1
	end if
	if(sum(fogdata({:},{yr},{mn},{d})) .le. 3)
	 lats2(in2)=lon(i)
	  
	 in2=in2+1
	
	end if
	   
       end if
     end do
     end if
  end do
 end do
end do


qsort(lats)
qsort(lats15)
qsort(lats20)
qsort(lats0)
qsort(lats2)


  x25  = round(.25*counts,3)-1     ; -1 to account for NCL indexing starting
  x75  = round(.75*counts,3)-1     ; at 0 
  
  latVals=(/min(lats),lats(x25),dim_median(lats),lats(x75),max(lats)/)

 x25  = round(.25*counts15,3)-1     ; -1 to account for NCL indexing starting
  x75  = round(.75*counts15,3)-1     ; at 0


  latVals15=(/min(lats15),lats15(x25),dim_median(lats15),lats15(x75),max(lats15)/)
 x25  = round(.25*counts20,3)-1     ; -1 to account for NCL indexing starting
  x75  = round(.75*counts20,3)-1     ; at 0

  latVals20=(/min(lats20),lats20(x25),dim_median(lats20),lats20(x75),max(lats20)/)
 x25  = round(.25*counts2,3)-1     ; -1 to account for NCL indexing starting
  x75  = round(.75*counts2,3)-1     ; at 0

  latVals2=(/min(lats2),lats2(x25),dim_median(lats2),lats2(x75),max(lats2)/)
 x25  = round(.25*counts0,3)-1     ; -1 to account for NCL indexing starting
  x75  = round(.75*counts0,3)-1     ; at 0

  latVals0=(/min(lats0),lats0(x25),dim_median(lats0),lats0(x75),max(lats0)/)


print(latVals)
print(latVals0)
print(latVals2)
print(latVals15)
print(latVals20)

wks = gsn_open_wks("png","box_lon_98-14_7525")               ; send graphics to PNG file

  res            = True                         ; plot mods desired
  res@tmXBLabels = (/"AllDays","0Fog","le3","ge15","ge20"/) ; labels for each box
  
  res@tiMainString = "Box Plot"
  ;res@trYMinF = 230.
  ;res@trYMaxF = 345.

  plot = boxplot(wks,(/0,1,2,3,4/),(/latVals,latVals0,latVals2,latVals15,latVals20/),False,res,False)	
  draw(wks)                                    ; boxplot does not call these
  frame(wks)                                   ; for you

end
