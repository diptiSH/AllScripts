begin


;fmap=/home/cccr/rameshv/dipti/NCL/plots/clusterPlots/
data=asciiread("/home/cccr/rameshv/dipti/NCL/plots/clusterPlots/2Write3_by_3.txt",-1,"integer")
print(data)
ftlevel=addfile("/home/cccr/rameshv/dipti/Data/ERA5/ERA5files/AnomER5_MSLP_DecJan_1979-2019_0_Down.nc","r")
tsurf=ftlevel->msl;(:,{lats:latn},{lonf:lonr})
units=tsurf&time@units
time=cd_calendar(tsurf&time,0)
print(time)

countfogCirc=new(40,"integer")
countfogCirc=0

do j=0,dimsizes(time(:,0))-1

  do i=1980,2019

   if(time((j),0).eq.i)then
      if(time((j),1).eq.1) then
         if(data(j).eq.8)then
;        if(data(j).eq.0 .or.data(j).eq.1 .or. data(j).eq.3 .or. data(j).eq.7 .or. data(j).eq.(8)) then
;        if(data(j).eq.0 .or.data(j).eq.1 .or. data(j).eq.3 ) then
        countfogCirc(i-1980)=countfogCirc(i-1980)+1
        end if
      end if
   end if


  if(time((j),0).eq.i-1)then
      if(time((j),1).eq.12) then
         if(data(j).eq.8)then
;        if(data(j).eq.0 .or.data(j).eq.1 .or. data(j).eq.3 .or. data(j).eq.7 .or. data(j).eq.(8)) then
;        if(data(j).eq.0 .or.data(j).eq.1 .or. data(j).eq.3 ) then
        countfogCirc(i-1980)=countfogCirc(i-1980)+1
        end if


      end if
   end if


  end do


end do

asciiwrite("somMap_8.txt",countfogCirc) 
;************************************************
; plotting parameters
;************************************************
; wks   = gsn_open_wks ("png","CirculationDaysTrend2")               ; send graphics to PNG file

; res                  = True                     ; plot mods desired
; res@tiMainString     = "Basic XY plot"          ; add title

; plot  = gsn_csm_xy (wks,ispan(1980,2019,1),countfogCirc,res) ; create plot


end







