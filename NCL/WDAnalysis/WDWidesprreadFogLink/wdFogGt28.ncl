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


;;;;;;;;;;;;; get count of days
cnt=0
;do i=0,dimsizes(lon)-1

do yr=1998,2014
 do mon=1,2
  if(mon.eq.2)then
    mn=12
  else
    mn=mon
  end if
  wdFlag=0
  do d=1,31
     do i=0,dimsizes(lon)-1
       if (yr.eq.year(i) .and. mn.eq.month(i).and.d.eq.day(i) .and. lon(i).ge.70 .and.lon(i).le.90 .and.  lat(i).gt.28)then
       wdFlag=1
       end if
     end do
if(wdFlag.eq.0)then
  cnt=cnt+1
end if
   
  end do
 end do
end do

print(cnt)



;;;;;;;;;;;;;;;;;;;;; Get no WD dates

dateList=new(cnt,"string")
fogNums=new(cnt,"integer")

in=0
do yr=1998,2014
 do mon=1,2
  if(mon.eq.2)then
    mn=12
  else
    mn=mon
  end if
  wdFlag=0
  do d=1,31
     do i=0,dimsizes(lon)-1
       if(yr.eq.year(i) .and. mn.eq.month(i).and.d.eq.day(i) .and. lon(i).ge.70 .and.lon(i).le.90 .and.  lat(i).gt.28 )then
       wdFlag=1
       end if
     end do
if(wdFlag.eq.0)then
  dateList(in)=tostring(yr)+"-"+tostring(mn)+"-"+tostring(d)
  fogNums(in)=sum(fogdata({:},{yr},{mn},{d}))
  in=in+1
end if

  end do
 end do
end do

print(dateList)
print(fogNums)




iarrFLe10=new(5,float) ; fill with minimum, 25th percentile, median,
                          ; 75th percentile, maximum of each time series

x25F  = round(0.25*cnt,3)-1     ; -1 to account for NCL indexing starting
x75F  = round(.75*cnt,3)-1     ; at 0
x10F  = round(.05*cnt,3)-1     ; -1 to account for NCL indexing starting
x90F  = round(.95*cnt,3)-1     ; at 0



qsort(fogNums)
tsFLe10=fogNums
iarrFLe10 = (/min(tsFLe10),tsFLe10(x25F),dim_median(tsFLe10),tsFLe10(x75F),max(tsFLe10)/)



wks = gsn_open_wks("png","WDLatGT28")               ; send graphics to PNG file
  plot=new(1,graphic)
  res            = True                         ; plot mods desired
  res@gsnDraw   = False
  res@gsnFrame  = False
 res@tmXBLabels = (/"All"/) ; labels for each box
  ; res@tiMainString = "Box Plot"
  ; res@trYMinF = 230.
 ; res@trYMaxF = 345.
 opti=True
;print(iarrFGe15)

do i=0,0
  res@tiMainString = i+1
  res@gsnLeftString=i
  opti@boxColors = (/"blue"/)
  plot(i)=boxplot(wks,(/0,1/),(/iarrFLe10,iarrFLe10/),opti,res,False)
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
