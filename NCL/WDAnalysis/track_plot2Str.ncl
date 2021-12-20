begin


;;;;;;;;;;
;********************************************
   wks = gsn_open_wks("png","trajStrong_Pattern_2")               ; send graphics to PNG file
   res            = True                          ; map resources
   res@gsnDraw    = False                         ; don't draw
   res@gsnFrame   = False                         ; don't advance frame

   res@gsnMaximize            = True
   res@mpGridAndLimbOn        = True               ; turn on grid lines 
   res@mpFillOn              = False
   res@mpPerimOn             = True
   res@mpMaxLatF  = 60                           ; select subregion
   res@mpMinLatF  = 10 
   res@mpMinLonF  = 60
   res@mpMaxLonF  = 100
   map = gsn_csm_map_ce(wks,res)
   pres                  = True               ; polyline resources
 ;  pres@gsLineThicknessF = 2.0                ; line thickness
 clrs= (/"red", "black", "PeachPuff", "MintCream", "SlateBlue",  \
           "Khaki", "OliveDrab","BurlyWood", "LightSalmon", "Coral", \
           "HotPink", "LemonChiffon", "AliceBlue", "LightGrey",      \
           "MediumTurquoise", "DarkSeaGreen", "Peru", "Tomato",      \
           "Orchid","PapayaWhip","Brown","grey","deeppink4","darksalmon","darkslategray"/)

;;;;;;;;; data

data=asciiread("era-interim-derived-wd-tracks.csv",-1,"string")
;print(data)

delim=","
 eventId= stringtoint( str_get_field(data, 1, delim))
; print(eventId)

ndata=dimsizes(eventId)

lon= stringtofloat(str_get_field(data, 2, delim))
;print(lon)

lat= stringtofloat(str_get_field(data, 3, delim))
;print(lat)

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

;;;;;;;;;; read dates 
infile="pattern2_WD.txt"
  
  ;;;;; read input dates
  ;;;;;;;;;FogDates_1.txt
  InData=asciiread(infile,-1,"string")
  datesData=str_get_field(InData,1,",")
  ;print(datesData) ;;;	year-month-day	
  yearIn=toint(str_get_field(datesData,1,"-"))
  monthIn=toint(str_get_field(datesData,2,"-"))
  dayIn=toint(str_get_field(datesData,3,"-"))
  ndays=dimsizes(datesData)  


;;;;;;;;;;; get count of WD entries on given days
cnt=0
do i=0,ndays-1 ;;;;; fogday loop
 do j=0,ndata-1 ;;;; data loop
 if(yearIn(i).eq.year(j) .and. monthIn(i).eq.month(j) .and. dayIn(i).eq.day(j))then
  cnt=cnt+1
  break
 end if
 end do ;;;;; data loop
end do ;;;; fogday loop

;;;;; get unique event ids
idarray=new(cnt,"integer")
k=0

do i=0,ndays-1 ;;;;; fogday loop
 do j=0,ndata-1 ;;;; data loop
 if(yearIn(i).eq.year(j) .and. monthIn(i).eq.month(j) .and. dayIn(i).eq.day(j))then
 idarray(k)=eventId(j)
   k=k+1
  break
 end if
 end do ;;;;; data loop
end do ;;;; fogday loop

uniqueEvents=get_unique_values(idarray)
print(uniqueEvents)

cntEvents=dimsizes(uniqueEvents)
print(cntEvents)

;;;;;;;;;;;;; plot each event
;;;;;;;;;;; each event location on fog days
do k=0,cntEvents-1 ;;;;;;; events loop

cntloc=0
do i=0,ndays-1 ;;;;; fogday loop
 do j=0,ndata-1 ;;;; data loop
 if(yearIn(i).eq.year(j) .and. monthIn(i).eq.month(j) .and. dayIn(i).eq.day(j) .and. eventId(j).eq.uniqueEvents(k))then
   cntloc=cntloc+1
  break
 end if
 end do ;;;;; data loop
end do ;;;; fogday loop

;;;;;;;; get lats and lon of each event
lats=new(cntloc,"float")
lons=new(cntloc,"float")
d=0
do i=0,ndays-1 ;;;;; fogday loop
 do j=0,ndata-1 ;;;; data loop
 if(yearIn(i).eq.year(j) .and. monthIn(i).eq.month(j) .and. dayIn(i).eq.day(j) .and. eventId(j).eq.uniqueEvents(k))then
    lats(d) =lat(j)
    lons(d)=lon(j)
    d=d+1
  break
 end if
 end do ;;;;; data loop
end do ;;;; fogday loop

print(uniqueEvents(k))
;gsn_polyline(wks,map,lons,lats,pres)      ; draw the traj
pres@gsMarkerColor  = clrs(k)
gsn_polymarker(wks,map,lons,lats,pres)


delete(lats)
delete(lons)
end do ;;;;;;;;; event loop

;*****************
  draw(map)
   frame(wks)
;********************

end