begin

geStations=0

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
do yr=1980,2016
 do mon=1,2
  if(mon.eq.2)then
    mn=12
  else
    mn=mon
  end if
  do d=1,31
   if(sum(fogdata({:},{yr},{mn},{d})) .eq. geStations) then
   ;  print(sum(fogdata({:},{yr},{mn},{d})))
     print(yr+"-"+mn+"-"+d)
    cnt=cnt+1  
   end if
  end do
 end do
end do

print(cnt)


;;;;;;;;;;;;;;; get wd characteristics on above selected WSF days
;;;;;;;;;;;;;;;;;; get counts of wd entries
counts=new(cnt,"integer") ;;; count of WD event ids associated with each WSF day
counts=0
uniqueEventsCount=0
in=0
do yr=1980,2016
 do mon=1,2
  if(mon.eq.2)then
    mn=12
  else
    mn=mon
  end if
  do d=1,31
   if(sum(fogdata({:},{yr},{mn},{d})) .eq. geStations) then
   ;  print(sum(fogdata({:},{yr},{mn},{d})))
    ; print(yr+"-"+mn+"-"+d)
     do i=0,dimsizes(lon)-1
       if (yr.eq.year(i) .and. mn.eq.month(i).and.d.eq.day(i) .and. lon(i).gt.65 .and.lon(i).lt.95 )then
       counts(in)=counts(in)+1
       end if
     end do
if(counts(in).gt.0) then
     ;;;;; get unique event ids
     idarray=new(counts(in),"integer")
     k=0
     do i=0,dimsizes(lon)-1
       if (yr.eq.year(i) .and. mn.eq.month(i).and.d.eq.day(i).and. lon(i).gt.65 .and.lon(i).lt.95)then
        idarray(k)=eventId(i)
        k=k+1
       end if
     end do

print(get_unique_values(idarray))
uniqueEvents=get_unique_values(idarray)
uniqueEventsCount=uniqueEventsCount+num(uniqueEvents)
delete(uniqueEvents)
   delete(idarray)
end if
   in=in+1 
   end if
  end do
 end do
end do
print("ooooooooooooooooooooooooooooook")
print(uniqueEventsCount)



;;;;;;;;;;;;;;;;;;;;;; Get unique event ids
EventsCount=new(uniqueEventsCount,"integer")
EventsCount=0
iin=0
in=0
do yr=1980,2016
 do mon=1,2
  if(mon.eq.2)then
    mn=12
  else
    mn=mon
  end if
  do d=1,31
if(sum(fogdata({:},{yr},{mn},{d})) .eq. geStations) then
if(counts(in).gt.0) then
     ;;;;; get unique event ids
     idarray=new(counts(in),"integer")
     k=0
     do i=0,dimsizes(lon)-1
       if (yr.eq.year(i) .and. mn.eq.month(i).and.d.eq.day(i).and. lon(i).gt.65 .and.lon(i).lt.95)then
        idarray(k)=eventId(i)
        k=k+1
       end if
     end do

;print(get_unique_values(idarray))
uniqueEventsCnt=num(get_unique_values(idarray))
EventsCount(iin:iin+uniqueEventsCnt-1)=get_unique_values(idarray)
iin=iin+uniqueEventsCnt
;delete(uniqueEvents)
   delete(idarray)
end if
    in=in+1
   end if
  end do
 end do
end do

WSFOgWDiDs=get_unique_values(EventsCount)

;********************************************
   wks = gsn_open_wks("png","traj_eq_"+geStations)               ; send graphics to PNG file
   res            = True                          ; map resources
   res@gsnDraw    = False                         ; don't draw
   res@gsnFrame   = False                         ; don't advance frame

   res@gsnMaximize            = True
   res@mpGridLineDashPattern  = 5                  ; lat/lon lines dashed
   res@mpGridLatSpacingF      = 2
  res@mpGridLonSpacingF      = 5
   res@mpGridAndLimbOn        = True               ; turn on grid lines
   res@mpFillOn              = False
   res@mpPerimOn             = True
   res@mpMaxLatF  = 60                           ; select subregion
   res@mpMinLatF  = 15
   res@mpMinLonF  = 0
   res@mpMaxLonF  = 180
map = gsn_csm_map_ce(wks,res)
   pres                  = True               ; polyline resources
   pres@gsLineThicknessF = 2.0                ; line thickness
;******************


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Plot tracks of those events

lengths=new(num(WSFOgWDiDs),"integer")

lengths=0
do i=0,num(WSFOgWDiDs)-1
   ;;;;;;;;;;get length of tracks

   	do j=0,dimsizes(lon)-1
		if(eventId(j).eq.WSFOgWDiDs(i))then
                  lengths(i)=lengths(i)+1
                end if
        end do
    ;;;;;;;;;;get lan and lots
    lats=new(lengths(i),"float")
    lons=new(lengths(i),"float")
    in=0
    do j=0,dimsizes(lon)-1
                if(eventId(j).eq.WSFOgWDiDs(i))then
                  lats(in)=lat(j)
                  lons(in)=lon(j)
                   in=in+1
                end if
    end do
    ;;;;;;;;;;;;;;;; plot traj

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
