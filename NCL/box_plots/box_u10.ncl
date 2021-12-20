begin
latS=25
latN=35
lonL=70
lonR=75

f=addfile("/home/cccr/rameshv/dipti/Data/ERA5/ERA5files/ER5_surface_DecJan_1979-2019_0_Down.nc","r")
u10=short2flt(f->u10(:,{latS:latN},{lonL:lonR}))
v10=short2flt(f->v10(:,{latS:latN},{lonL:lonR}))

printVarSummary(u10)
printVarSummary(v10)
units=u10&time@units


data=asciiread("/home/cccr/rameshv/dipti/NCL/GetWidespreadFogDays/WSFogDays_2.5ddCriteriaRF50Per.txt",1059,"string")
delim=","
dates=str_get_field(data, 1, delim)
stations=toint(str_get_field(data, 3, delim))
gridpoints=toint(str_get_field(data, 2, delim))
delim="-"
year=toint(str_get_field(dates, 1, delim))
months=toint(str_get_field(dates, 2, delim))
days=toint(str_get_field(dates, 3, delim))
;print(days)

;print(stations)
;exit


;;;;;;;;;;; get count
labelCount=new(2,"integer")
labelCount=0

do i=0,dimsizes(data)-1

   if (stations(i).le.6) then
 labelCount(0)=labelCount(0)+1
   end if
   if (stations(i).ge.10) then
   labelCount(1)=labelCount(1)+1
   end if

end do

print(labelCount)

u10l=new((/labelCount(0)/),float)
v10l=new((/labelCount(0)/),float)
u10m=new((/labelCount(1)/),float)
v10m=new((/labelCount(1)/),float)

l=0
m=0
do i=0,dimsizes(data)-1

Time=cd_inv_calendar(year(i),months(i),days(i),0,0,0,units,0)

   if (stations(i).le.6) then
    u10l(l)=avg(u10({Time},:,:))
    v10l(l)=avg(v10({Time},:,:))
    l=l+1
   end if
   if (stations(i).ge.10) then
    u10m(m)=avg(u10({Time},:,:))
    v10m(m)=avg(v10({Time},:,:))
     m=m+1
   end if
end do


x25F  = round(.25*labelCount(1),3)-1     ; -1 to account for NCL indexing starting
x75F  = round(.75*labelCount(1),3)-1     ; at 0


x25N  = round(.25*labelCount(0),3)-1     ; -1 to account for NCL indexing starting
x75N  = round(.75*labelCount(0),3)-1     ; at 0

iarrF=new(5,float) ; fill with minimum, 25th percentile, median,
                          ; 75th percentile, maximum of each time series

iarrN=new(5,float) ; fill with minimum, 25th percentile, median,
                          ; 75th percentile, maximum of each time series


do i=0,5

qsort(v10m)
qsort(v10l)

tsF=v10m

;iarrF(i,:) = (/min(v10m),v10m(x25F),dim_median(v10m),v10m(x75F),max(v10m)/)

iarrF = (/min(tsF),tsF(x25F),dim_median(tsF),tsF(x75F),max(tsF)/)

tsN=v10l
;iarrN(i,:) = (/min(v10l),v10l(x25N),dim_median(v10l),v10l(x75N),max(v10l)/)

iarrN = (/min(tsN),tsN(x25N),dim_median(tsN),tsN(x75N),max(tsN)/)
end do

wks = gsn_open_wks("png","v10box")               ; send graphics to PNG file
 res            = True 
res@tmXBLabels = (/"Fog","No Fog"/) ; labels for each box
  ; res@tiMainString = "Box Plot"
  ; res@trYMinF = 230.
 ; res@trYMaxF = 345.
 opti=True
print(iarrF)
print(iarrN)
opti@boxColors = (/"blue","red"/)
  plot=boxplot(wks,(/0,1/),(/iarrF,iarrN/),opti,res,False)
draw(wks)                                    ; boxplot does not call these
  frame(wks)
end
