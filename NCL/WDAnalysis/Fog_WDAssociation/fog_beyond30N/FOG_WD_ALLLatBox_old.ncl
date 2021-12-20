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
     print(yr+"-"+mn+"-"+d)
    cnt=cnt+1  
   end if
  end do
 end do
end do

print(cnt)


;;;;;;;;;;;;;;;;;; get counts of obs when WD  between 70 to 90 E 

counts=0

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
       end if
     end do
     end if
  end do
 end do
end do
print("ooooooooooooooooooooooooooooook")
print(counts)


;;;;;;;;;;;;;;;;;; get dates when WD  between 70 to 90 E 

cnt=0
datesString=new(counts,"string")
in=0
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
    ;   counts=counts+1
	  cnt=cnt+1
	 datesString(in)=yr+"-"+mn+"-"+d
	 in=in+1
       end if
     end do
     end if
  end do
 end do
end do
;print("ooooooooooooooooooooooooooooook")
;print(counts)

print(get_unique_values(datesString))
;print(num(datesString))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; get lats

lats=new(cnt,"float")
in=0
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
         lats(in)=lat(i)
	 in=in+1
       end if
     end do
     end if
  end do
 end do
end do


qsort(lats)

  x25  = round(.25*cnt,3)-1     ; -1 to account for NCL indexing starting
  x75  = round(.75*cnt,3)-1     ; at 0 
  
  latVals=(/min(lats),lats(x25),dim_median(lats),lats(x75),max(lats)/)

wks = gsn_open_wks("png","box")               ; send graphics to PNG file

  res            = True                         ; plot mods desired
  res@tmXBLabels = (/"AllDays"/) ; labels for each box
  res@tiMainString = "Box Plot"
  ;res@trYMinF = 230.
  ;res@trYMaxF = 345.

  plot = boxplot(wks,(/0/),latVals,False,res,False)	
  draw(wks)                                    ; boxplot does not call these
  frame(wks)                                   ; for you

end
