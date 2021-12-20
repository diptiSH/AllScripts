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

WDID=314134


;********************************************
   wks = gsn_open_wks("png","traj_"+WDID)               ; send graphics to PNG file
   res            = True                          ; map resources
   res@gsnDraw    = False                         ; don't draw
   res@gsnFrame   = False                         ; don't advance frame

   res@gsnMaximize            = True
   res@mpGridAndLimbOn        = True               ; turn on grid lines 
   res@mpFillOn              = False
   res@mpPerimOn             = True
;   res@mpCenterLonF=50
   res@mpMaxLatF  = 90                           ; select subregion
   res@mpMinLatF  = 0 
   res@mpMinLonF  = 0
   res@mpMaxLonF  = 360
map = gsn_csm_map_ce(wks,res)
   pres                  = True               ; polyline resources
   pres@gsLineThicknessF = 2.0                ; line thickness
;******************
len=0
do i=0,dimsizes(lon)-1
 if (WDID .eq. eventId(i))then
   len=len+1
 end if
end do

;;;;;;;; get lats and lon of each event
lats=new(len,"float")
lons=new(len,"float")
d=0
do i=0,dimsizes(lon)-1
 if (WDID .eq. eventId(i))then
    lats(d) =lat(i)
    lons(d)=lon(i)
    d=d+1
 end if
end do

;**********************************
 gsn_polyline(wks,map,lons,lats,pres)      ; draw the traj
                                     
;**********************************************



;*****************
  draw(map)
   frame(wks)
;********************






end
