begin

data=asciiread("/home/cccr/rameshv/dipti/NCL/GetWidespreadFogDays/WSFogDays_1.5ddCriteriaRF50Per.txt",-1,"string")
delim=","
dates=str_get_field(data, 1, delim)
delim="-"
year=toint(str_get_field(dates, 1, delim))
months=toint(str_get_field(dates, 2, delim))
days=toint(str_get_field(dates, 3, delim))
somMap_0=asciiread("somMap_0.txt",-1,"integer")
somMap_1=asciiread("somMap_1.txt",-1,"integer")
somMap_3=asciiread("somMap_3.txt",-1,"integer")
somMap_7=asciiread("somMap_7.txt",-1,"integer")
somMap_8=asciiread("somMap_8.txt",-1,"integer")
somMap=asciiread("somMap.txt",-1,"integer")
somMap2=asciiread("somMap2.txt",-1,"integer")

;print(data)

countWDFDays=new(40,"integer")
countWDFDays=0

do i=1980,2019

 do j=0,dimsizes(data)-1

   if(year(j).eq.i)then
      if(months(j).eq.1) then
        countWDFDays(i-1980)=countWDFDays(i-1980)+1

      end if
   end if


  if(year(j).eq.i-1)then
      if(months(j).eq.12) then
        countWDFDays(i-1980)=countWDFDays(i-1980)+1

      end if
   end if

 end do

end do


 data2      = new((/4,dimsizes(countWDFDays)/),float)

 data2(0,:) = countWDFDays
 data2(1,:) = somMap
 data2(2,:) = somMap2
 data2(3,:)= somMap_0
; data2(4,:)= somMap_1
; data2(5,:)= somMap_3
; data2(6,:)= somMap_7
; data2(7,:)= somMap_8

;************************************************
; plotting parameters
;************************************************
 wks   = gsn_open_wks ("png","WSFDaysTrend_1")               ; send graphics to PNG file

 res                  = True                     ; plot mods desired
 res@tiMainString     = "Basic XY plot"          ; add title

 plot  = gsn_csm_xy (wks,ispan(1980,2019,1),data2,res) ; create plot


end
