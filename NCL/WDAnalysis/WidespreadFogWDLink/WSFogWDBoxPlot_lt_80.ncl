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

geStations=15
;;;;;;;;;;;;; get count of days
cnt=0
do yr=1998,2016
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
do yr=1998,2016
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
       if (yr.eq.year(i) .and. mn.eq.month(i).and.d.eq.day(i) .and. lon(i).ge.60 .and.lon(i).lt.80 )then
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
featureValsFGe15=new((/counts,4/),float)  ;;;;;;;;;;lat,lon,intensity,size
in=0
do yr=1998,2016
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
       if (yr.eq.year(i) .and. mn.eq.month(i).and.d.eq.day(i) .and. lon(i).ge.60 .and.lon(i).lt.80 )then
        featureValsFGe15(in,0)=lat(i)
        featureValsFGe15(in,1)=lon(i)
        featureValsFGe15(in,2)=intensity(i)
        featureValsFGe15(in,3)=size(i)
        in=in+1
       end if
     end do
     end if
  end do
 end do
end do

iarrFGe15=new((/4,5/),float) ; fill with minimum, 25th percentile, median,
                          ; 75th percentile, maximum of each time series

x25F  = round(0.25*counts,3)-1     ; -1 to account for NCL indexing starting
x75F  = round(.75*counts,3)-1     ; at 0
x10F  = round(.05*counts,3)-1     ; -1 to account for NCL indexing starting
x90F  = round(.95*counts,3)-1     ; at 0

do i=0,3

qsort(featureValsFGe15(:,i))
tsFGe15=featureValsFGe15(:,i)
iarrFGe15(i,:) = (/min(tsFGe15),tsFGe15(x25F),dim_median(tsFGe15),tsFGe15(x75F),max(tsFGe15)/)
end do

geStations=20
;;;;;;;;;;;;; get count of days
cnt=0
do yr=1998,2016
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
do yr=1998,2016
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
       if (yr.eq.year(i) .and. mn.eq.month(i).and.d.eq.day(i) .and. lon(i).ge.60 .and.lon(i).lt.80 )then
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
featureValsFGe20=new((/counts,4/),float)  ;;;;;;;;;;lat,lon,intensity,size
in=0
do yr=1998,2016
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
       if (yr.eq.year(i) .and. mn.eq.month(i).and.d.eq.day(i) .and. lon(i).ge.60 .and.lon(i).lt.80 )then
        featureValsFGe20(in,0)=lat(i)
        featureValsFGe20(in,1)=lon(i)
        featureValsFGe20(in,2)=intensity(i)
        featureValsFGe20(in,3)=size(i)
        in=in+1
       end if
     end do
     end if
  end do
 end do
end do

iarrFGe20=new((/4,5/),float) ; fill with minimum, 25th percentile, median,
                          ; 75th percentile, maximum of each time series

x25F  = round(0.25*counts,3)-1     ; -1 to account for NCL indexing starting
x75F  = round(.75*counts,3)-1     ; at 0
x10F  = round(.05*counts,3)-1     ; -1 to account for NCL indexing starting
x90F  = round(.95*counts,3)-1     ; at 0

do i=0,3

qsort(featureValsFGe20(:,i))
tsFGe20=featureValsFGe20(:,i)
iarrFGe20(i,:) = (/min(tsFGe20),tsFGe20(x25F),dim_median(tsFGe20),tsFGe20(x75F),max(tsFGe20)/)
end do


geStations=12
;;;;;;;;;;;;; get count of days
cnt=0
do yr=1998,2016
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
do yr=1998,2016
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
       if (yr.eq.year(i) .and. mn.eq.month(i).and.d.eq.day(i) .and. lon(i).ge.60 .and.lon(i).lt.80 )then
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
featureValsFGe12=new((/counts,4/),float)  ;;;;;;;;;;lat,lon,intensity,size
in=0
do yr=1998,2016
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
       if (yr.eq.year(i) .and. mn.eq.month(i).and.d.eq.day(i) .and. lon(i).ge.60 .and.lon(i).lt.80 )then
        featureValsFGe12(in,0)=lat(i)
        featureValsFGe12(in,1)=lon(i)
        featureValsFGe12(in,2)=intensity(i)
        featureValsFGe12(in,3)=size(i)
        in=in+1
       end if
     end do
     end if
  end do
 end do
end do

iarrFGe12=new((/4,5/),float) ; fill with minimum, 25th percentile, median,
                          ; 75th percentile, maximum of each time series

x25F  = round(0.25*counts,3)-1     ; -1 to account for NCL indexing starting
x75F  = round(.75*counts,3)-1     ; at 0
x10F  = round(.05*counts,3)-1     ; -1 to account for NCL indexing starting
x90F  = round(.95*counts,3)-1     ; at 0

do i=0,3

qsort(featureValsFGe12(:,i))
tsFGe12=featureValsFGe12(:,i)
iarrFGe12(i,:) = (/min(tsFGe12),tsFGe12(x25F),dim_median(tsFGe12),tsFGe12(x75F),max(tsFGe12)/)
end do

geStations=0
;;;;;;;;;;;;; get count of days
cnt=0
do yr=1998,2016
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
do yr=1998,2016
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
       if (yr.eq.year(i) .and. mn.eq.month(i).and.d.eq.day(i) .and. lon(i).ge.60 .and.lon(i).lt.80 )then
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
featureValsFGe0=new((/counts,4/),float)  ;;;;;;;;;;lat,lon,intensity,size
in=0
do yr=1998,2016
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
       if (yr.eq.year(i) .and. mn.eq.month(i).and.d.eq.day(i) .and. lon(i).ge.60 .and.lon(i).lt.80 )then
        featureValsFGe0(in,0)=lat(i)
        featureValsFGe0(in,1)=lon(i)
        featureValsFGe0(in,2)=intensity(i)
        featureValsFGe0(in,3)=size(i)
        in=in+1
       end if
     end do
     end if
  end do
 end do
end do

iarrFGe0=new((/4,5/),float) ; fill with minimum, 25th percentile, median,
                          ; 75th percentile, maximum of each time series

x25F  = round(0.25*counts,3)-1     ; -1 to account for NCL indexing starting
x75F  = round(.75*counts,3)-1     ; at 0
x10F  = round(.05*counts,3)-1     ; -1 to account for NCL indexing starting
x90F  = round(.95*counts,3)-1     ; at 0

do i=0,3

qsort(featureValsFGe0(:,i))
tsFGe0=featureValsFGe0(:,i)
iarrFGe0(i,:) = (/min(tsFGe0),tsFGe0(x25F),dim_median(tsFGe0),tsFGe0(x75F),max(tsFGe0)/)
end do

geStations=0
;;;;;;;;;;;;; get count of days
cnt=0
do yr=1998,2016
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
;counts=new(cnt,"integer") ;;; count of WD event ids associated with each WSF day
counts=0
uniqueEventsCount=0
do yr=1998,2016
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
       if (yr.eq.year(i) .and. mn.eq.month(i).and.d.eq.day(i) .and. lon(i).ge.60 .and.lon(i).lt.80 )then
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
featureValsFEq0=new((/counts,4/),float)  ;;;;;;;;;;lat,lon,intensity,size
in=0
do yr=1998,2016
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
       if (yr.eq.year(i) .and. mn.eq.month(i).and.d.eq.day(i) .and. lon(i).ge.60 .and.lon(i).lt.80 )then
        featureValsFEq0(in,0)=lat(i)
        featureValsFEq0(in,1)=lon(i)
        featureValsFEq0(in,2)=intensity(i)
        featureValsFEq0(in,3)=size(i)
        in=in+1
       end if
     end do
     end if
  end do
 end do
end do

iarrFEq0=new((/4,5/),float) ; fill with minimum, 25th percentile, median,
                          ; 75th percentile, maximum of each time series

x25F  = round(0.25*counts,3)-1     ; -1 to account for NCL indexing starting
x75F  = round(.75*counts,3)-1     ; at 0
x10F  = round(.05*counts,3)-1     ; -1 to account for NCL indexing starting
x90F  = round(.95*counts,3)-1     ; at 0

do i=0,3

qsort(featureValsFEq0(:,i))
tsFEq0=featureValsFEq0(:,i)
iarrFEq0(i,:) = (/min(tsFEq0),tsFEq0(x25F),dim_median(tsFEq0),tsFEq0(x75F),max(tsFEq0)/)
end do


geStations=5
;;;;;;;;;;;;; get count of days
cnt=0
do yr=1998,2016
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


;;;;;;;;;;;;;;; get wd characteristics on above selected WSF days
;;;;;;;;;;;;;;;;;; get counts of wd entries
;counts=new(cnt,"integer") ;;; count of WD event ids associated with each WSF day
counts=0
uniqueEventsCount=0
do yr=1998,2016
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
       if (yr.eq.year(i) .and. mn.eq.month(i).and.d.eq.day(i) .and. lon(i).ge.60 .and.lon(i).lt.80 )then
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
featureValsFLe5=new((/counts,4/),float)  ;;;;;;;;;;lat,lon,intensity,size
in=0
do yr=1998,2016
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
       if (yr.eq.year(i) .and. mn.eq.month(i).and.d.eq.day(i) .and. lon(i).ge.60 .and.lon(i).lt.80 )then
        featureValsFLe5(in,0)=lat(i)
        featureValsFLe5(in,1)=lon(i)
        featureValsFLe5(in,2)=intensity(i)
        featureValsFLe5(in,3)=size(i)
        in=in+1
       end if
     end do
     end if
  end do
 end do
end do

iarrFLe5=new((/4,5/),float) ; fill with minimum, 25th percentile, median,
                          ; 75th percentile, maximum of each time series

x25F  = round(0.25*counts,3)-1     ; -1 to account for NCL indexing starting
x75F  = round(.75*counts,3)-1     ; at 0
x10F  = round(.05*counts,3)-1     ; -1 to account for NCL indexing starting
x90F  = round(.95*counts,3)-1     ; at 0

do i=0,3

qsort(featureValsFLe5(:,i))
tsFLe5=featureValsFLe5(:,i)
iarrFLe5(i,:) = (/min(tsFLe5),tsFLe5(x25F),dim_median(tsFLe5),tsFLe5(x75F),max(tsFLe5)/)
end do

geStations=10
;;;;;;;;;;;;; get count of days
cnt=0
do yr=1998,2016
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


;;;;;;;;;;;;;;; get wd characteristics on above selected WSF days
;;;;;;;;;;;;;;;;;; get counts of wd entries
;counts=new(cnt,"integer") ;;; count of WD event ids associated with each WSF day
counts=0
uniqueEventsCount=0
do yr=1998,2016
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
       if (yr.eq.year(i) .and. mn.eq.month(i).and.d.eq.day(i) .and. lon(i).ge.60 .and.lon(i).lt.80 )then
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
featureValsFLe10=new((/counts,4/),float)  ;;;;;;;;;;lat,lon,intensity,size
in=0
do yr=1998,2016
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
       if (yr.eq.year(i) .and. mn.eq.month(i).and.d.eq.day(i) .and. lon(i).ge.60 .and.lon(i).lt.80 )then
        featureValsFLe10(in,0)=lat(i)
        featureValsFLe10(in,1)=lon(i)
        featureValsFLe10(in,2)=intensity(i)
        featureValsFLe10(in,3)=size(i)
        in=in+1
       end if
     end do
     end if
  end do
 end do
end do

iarrFLe10=new((/4,5/),float) ; fill with minimum, 25th percentile, median,
                          ; 75th percentile, maximum of each time series

x25F  = round(0.25*counts,3)-1     ; -1 to account for NCL indexing starting
x75F  = round(.75*counts,3)-1     ; at 0
x10F  = round(.05*counts,3)-1     ; -1 to account for NCL indexing starting
x90F  = round(.95*counts,3)-1     ; at 0

do i=0,3

qsort(featureValsFLe10(:,i))
tsFLe10=featureValsFLe10(:,i)
iarrFLe10(i,:) = (/min(tsFLe10),tsFLe10(x25F),dim_median(tsFLe10),tsFLe10(x75F),max(tsFLe10)/)
end do




wks = gsn_open_wks("png","10box_WD_FogNoFogCats_after97_lt80lon")               ; send graphics to PNG file
  plot=new(4,graphic)
  res            = True                         ; plot mods desired
  res@gsnDraw   = False
  res@gsnFrame  = False
 res@tmXBLabels = (/"All","Ge12","Ge15","Ge20","LE10","LE5","NoFog"/) ; labels for each box
  ; res@tiMainString = "Box Plot"
  ; res@trYMinF = 230.
 ; res@trYMaxF = 345.
 opti=True
print(iarrFGe15)

do i=0,3
  res@tiMainString = i+1
  res@gsnLeftString=i
  opti@boxColors = (/"Grey","yellow","blue","Red","black","brown","Green"/)
  plot(i)=boxplot(wks,(/0,1,2,3,4,5,6/),(/iarrFGe0(i,:),iarrFGe12(i,:),iarrFGe15(i,:),iarrFGe20(i,:),iarrFLe10(i,:),iarrFLe5(i,:),iarrFEq0(i,:)/),opti,res,False)
  end do
;  plot = boxplot(wks,(/0,1,2,3,4,5/),iarrFGe15,False,res,False)
;  plot2 = boxplot(wks,(/0,1,2,3,4,5/),iarrN,False,res,False)
;************************************************
; create panel
;************************************************
  gsn_panel(wks,plot,(/2,2/),False)             ; now draw as one plot

draw(wks)                                    ; boxplot does not call these
  frame(wks)







end
