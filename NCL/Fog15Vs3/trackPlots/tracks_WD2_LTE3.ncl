begin

;;;;;;;Read Dates
dataF=asciiread("/home/cccr/rameshv/dipti/NCL/Fog15Vs3/WD2_DatesLTE3.txt",-1,"string")
inputVals=dimsizes(dataF)

delim="-"
year=toint(str_get_field(dataF, 1, delim))
month=toint(str_get_field(dataF, 2, delim))
day=toint(str_get_field(dataF, 3, delim))
;print(data)



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

;eventID=stringtofloat(str_get_field(data, 6, delim))

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
dayWD= stringtoint(str_get_field(Date,1,delim))
monthWD= stringtoint(str_get_field(Date,2,delim))
yearWD= stringtoint(str_get_field(Date,3,delim))

delim=":"
time=stringtoint(str_get_field(Time,1,delim))


;********************************************
   wks = gsn_open_wks("png","traj_WD2_LTE3")               ; send graphics to PNG file
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


do i=0,dimsizes(dataF)-1

;;;;;;;;;;;; Get uniq wd ids for each day
    cnt=0
	do k=0,dimsizes(data)-1
	   
		if(day(i).eq.dayWD(k) .and. month(i).eq.monthWD(k) .and. year(i).eq.yearWD(k))then
		cnt=cnt+1
		end if
	end do
 if (cnt.gt.0)then
	WDids=new(cnt,"integer")
	in=0
	do k=0,dimsizes(data)-1
	    if(day(i).eq.dayWD(k) .and. month(i).eq.monthWD(k) .and. year(i).eq.yearWD(k))then
		WDids(in)=eventId(k)
		in=in+1
		end if
	end do
    
	uniqWDids=get_unique_values(WDids)
	print(uniqWDids)
	delete(WDids)
	do l=0,dimsizes(uniqWDids)-1
		WDID=uniqWDids(l)
		
		;;;; get length
		len=0
        do il=0,dimsizes(lon)-1
         if (WDID .eq. eventId(il))then
          len=len+1
         end if
        end do
		print(len)
		
		;;;;;;;; get lats and lon of each event
        lats=new(len,"float")
        lons=new(len,"float")
        d=0
        do il=0,dimsizes(lon)-1
          if (WDID .eq. eventId(il))then
            lats(d) =lat(il)
            lons(d)=lon(il)
            d=d+1
          end if
        end do

        ;**********************************
        gsn_polyline(wks,map,lons,lats,pres)      ; draw the traj
                                     
        ;**********************************************
        delete(lats)
		delete(lons)
		
	end do
	
	
	delete(uniqWDids)
	
	
 end if


end do

;*****************
  draw(map)
   frame(wks)
;********************

end
