begin

geStations=15

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
do yr=1980,2016
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


;;;;;;;;;;;;;;; get wd characteristics on above selected WSF days
;;;;;;;;;;;;;;;;;; get counts of wd entries
;counts=new(cnt,"integer") ;;; count of WD event ids associated with each WSF day
counts=0
uniqueEventsCount=0
do yr=1980,2016
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
       if (yr.eq.year(i) .and. mn.eq.month(i).and.d.eq.day(i) .and. lon(i).gt.65 .and.lon(i).lt.95 )then
       counts=counts+1
       end if
     end do
     end if
  end do
 end do
end do
print("ooooooooooooooooooooooooooooook")
print(counts)


;;;;;;;;;;;;;;;;;get characteristics
featureValsF=new((/counts,4/),float)  ;;;;;;;;;;lat,lon,intensity,size
in=0
do yr=1980,2016
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
       if (yr.eq.year(i) .and. mn.eq.month(i).and.d.eq.day(i) .and. lon(i).gt.65 .and.lon(i).lt.95 )then
        featureValsF(in,0)=lat(i)
        featureValsF(in,1)=lon(i)
        featureValsF(in,2)=intensity(i)
        featureValsF(in,3)=size(i)
        in=in+1
       end if
     end do
     end if
  end do
 end do
end do

iarrF=new((/4,5/),float) ; fill with minimum, 25th percentile, median,
                          ; 75th percentile, maximum of each time series

x25F  = round(0.25*counts,3)-1     ; -1 to account for NCL indexing starting
x75F  = round(.75*counts,3)-1     ; at 0
x10F  = round(.05*counts,3)-1     ; -1 to account for NCL indexing starting
x90F  = round(.95*counts,3)-1     ; at 0

do i=0,3

qsort(featureValsF(:,i))
tsF=featureValsF(:,i)
iarrF(i,:) = (/min(tsF),tsF(x10F),dim_median(tsF),tsF(x90F),max(tsF)/)
end do


wks = gsn_open_wks("png","10box_WD")               ; send graphics to PNG file
  plot=new(4,graphic)
  res            = True                         ; plot mods desired
  res@gsnDraw   = False
  res@gsnFrame  = False
 res@tmXBLabels = (/"Fog","Fog"/) ; labels for each box
  ; res@tiMainString = "Box Plot"
  ; res@trYMinF = 230.
 ; res@trYMaxF = 345.
 opti=True
print(iarrF)

do i=0,3
  res@tiMainString = i+1
  res@gsnLeftString=i
  opti@boxColors = (/"blue","blue"/)
  plot(i)=boxplot(wks,(/0,1/),(/iarrF(i,:),iarrF(i,:)/),opti,res,False)
  end do
;  plot = boxplot(wks,(/0,1,2,3,4,5/),iarrF,False,res,False)
;  plot2 = boxplot(wks,(/0,1,2,3,4,5/),iarrN,False,res,False)
;************************************************
; create panel
;************************************************
  gsn_panel(wks,plot,(/2,2/),False)             ; now draw as one plot

draw(wks)                                    ; boxplot does not call these
  frame(wks)







end
