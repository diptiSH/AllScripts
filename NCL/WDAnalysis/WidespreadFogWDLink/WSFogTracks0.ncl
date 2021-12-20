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
   if(sum(fogdata({:},{yr},{mn},{d})) .le. geStations) then
   ;  print(sum(fogdata({:},{yr},{mn},{d})))
     print(yr+"-"+mn+"-"+d)
    cnt=cnt+1  
   end if
  end do
 end do
end do

print(cnt)


;********************************************
   wks = gsn_open_wks("png","trajGE_"+geStations)               ; send graphics to PNG file
   res            = True                          ; map resources
   res@gsnDraw    = False                         ; don't draw
   res@gsnFrame   = False                         ; don't advance frame

   res@gsnMaximize            = True
   res@mpGridAndLimbOn        = True               ; turn on grid lines 
   res@mpFillOn              = False
   res@mpPerimOn             = True
   res@mpMaxLatF  = 85                           ; select subregion
   res@mpMinLatF  = 10 
   res@mpMinLonF  = 0
   res@mpMaxLonF  = 180
map = gsn_csm_map_ce(wks,res)
   pres                  = True               ; polyline resources
   pres@gsLineThicknessF = 2.0                ; line thickness
;******************


;;;;;;;;;;;;;;; get wd characteristics on above selected WSF days
;;;;;;;;;;;;;;;;;; get counts of wd entries
;counts=new(cnt,"integer") ;;; count of WD event ids associated with each WSF day
counts=0
uniqueEventsCount=0
do yr=1998,2014
 do mon=1,2
  if(mon.eq.2)then
    mn=12
  else
    mn=mon
  end if
  do d=1,31
   if(sum(fogdata({:},{yr},{mn},{d})) .le. geStations) then
   ;  print(sum(fogdata({:},{yr},{mn},{d})))
    ; print(yr+"-"+mn+"-"+d)
     do i=0,dimsizes(lon)-1
       if (yr.eq.year(i) .and. mn.eq.month(i).and.d.eq.day(i) .and. lon(i).ge.60 .and.lon(i).le.90 )then
       counts=counts+1
       end if
     end do
     end if
  end do
 end do
end do
print("ooooooooooooooooooooooooooooook")
print(counts)


;;;;;;;;;;;;;;; get ids of WD and unique ids
eventIdS=new(counts,"integer")
in=0
do yr=1998,2014
 do mon=1,2
  if(mon.eq.2)then
    mn=12
  else
    mn=mon
  end if
  do d=1,31
   if(sum(fogdata({:},{yr},{mn},{d})) .le. geStations) then
   ;  print(sum(fogdata({:},{yr},{mn},{d})))
    ; print(yr+"-"+mn+"-"+d)
     do i=0,dimsizes(lon)-1
       if (yr.eq.year(i) .and. mn.eq.month(i).and.d.eq.day(i) .and. lon(i).ge.60 .and.lon(i).le.90 )then
       eventIdS(in)=eventId(i)
	   in=in+1
       end if
     end do
     end if
  end do
 end do
end do

uniqueEvents=get_unique_values(eventIdS)

;;;;;;; get length of each event
do p=0,num(uniqueEvents)-1
;print(uniqueEvents(p))
len=0
do i=0,dimsizes(lon)-1
 if (uniqueEvents(p) .eq. eventId(i))then
   len=len+1
 end if
end do

;;;;;;;; get lats and lon of each event
lats=new(len,"float")
lons=new(len,"float")
d=0
do i=0,dimsizes(lon)-1
 if (uniqueEvents(p) .eq. eventId(i))then
    lats(d) =lat(i)
    lons(d)=lon(i)
    d=d+1
 end if
end do

;**********************************
 gsn_polyline(wks,map,lons,lats,pres)      ; draw the traj
                                     
;**********************************************
delete(lats)
delete(lons)
end do

;*****************
  draw(map)
   frame(wks)
;********************

end
