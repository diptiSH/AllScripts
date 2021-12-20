begin

data=asciiread("WSFogDays_1.5ddCriteria50Per.txt",-1,"string")

print(data)

delim=","
dates=str_get_field(data, 1, delim)
delim="-"
year=toint(str_get_field(dates, 1, delim))
months=toint(str_get_field(dates, 2, delim))
days=toint(str_get_field(dates, 3, delim))


print(days)

wsfDayCnt=new(40,"integer")
wsfDayCnt=0
do y=1980,2019

do k=0,dimsizes(data)-1

if(months(k).eq.1 .and. year(k).eq.y) then
 wsfDayCnt(y-1980)=wsfDayCnt(y-1980)+1
end if

if(months(k).eq.12 .and. year(k).eq.y-1) then
 wsfDayCnt(y-1980)=wsfDayCnt(y-1980)+1
end if


end do


end do
;*********************************
; create plot
;K********************************
 wks   = gsn_open_wks ("png", "bar" )  ; send graphics to PNG file
 res   = True
 res@gsnScale = True               

; these four resources allow the user to stretch the plot size, and
; decide exactly where on the page to draw it.

 res@gsnMaximize = True

;---------- First plot --------------------

 res@tiMainString  = "Bar plot"
 res@gsnXYBarChart = True            ; Create bar plot

 
res@tmXMajorGrid                = True          ; implement x grid 
  res@tmXMajorGridThicknessF      = 1.0           ; 2.0 is default
  res@tmXMajorGridLineDashPattern = 2             ; select short dash lines
  
  res@tmYMajorGrid                = True          ; implement y grid
  res@tmYMajorGridThicknessF      = 1.0           ; 2.0 is default
  res@tmYMajorGridLineDashPattern = 2             ; select short dash lines

;res@tmXMinorGrid                = True          ; implement x grid
;  res@tmXMinorGridThicknessF      = 1.0           ; 2.0 is default
;  res@tmXMinorGridLineDashPattern = 2             ; select short dash lines


plot = gsn_csm_xy (wks,ispan(1980,2019,1),wsfDayCnt,res)

print(wsfDayCnt)



end
