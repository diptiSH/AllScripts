begin



WDI = asciiread("//home/cccr/rameshv/dipti/NCL/trackLows/WDCHaracter_1979to2014_WDI.txt",-1,"string")


print(WDI(0))



date=str_get_field(WDI(1:),1,",")
fog=stringtointeger(str_get_field(WDI(1:),2,","))
WDIInd=tofloat(str_get_field(WDI(1:),3,","))

yr=stringtointeger(str_get_field(date,1,"-"))
mn=stringtointeger(str_get_field(date,2,"-"))
da=stringtointeger(str_get_field(date,3,"-"))

print(da)


print(WDIInd)
print(fog(0))
;exit
print(date(0))

Bar_inst=asciiread("//home/cccr/rameshv/dipti/NCL/trackLows/InstabilityIndex_MadhuraGietelman_1979to2014_500hPa.txt",-1,"string")

BarInstInd=tofloat(str_get_field(Bar_inst(1:),3,","))

print(BarInstInd)


fStations=new(35*2,"integer")
fStations=0
wdindex=new(35*2,"float")
wdindex=0.0
BaroclinicIndex=new(35*2,"float")
BaroclinicIndex=0.0

in=0

do year=1980,2014

do month=1,2

if(month.eq.2)then
 m=12
 y=year-1
else
 m=month
 y=year
end if

do i=0,dimsizes(date)-1
if(y.eq.yr(i) .and. m.eq.mn(i) .and..not.ismissing (fog(i)))then
fStations(in)=fStations(in)+fog(i)
end if


if(y.eq.yr(i) .and. m.eq.mn(i) .and..not.ismissing (WDIInd(i)))then
wdindex(in)=wdindex(in)+WDIInd(i)
end if

if(y.eq.yr(i) .and. m.eq.mn(i) .and..not.ismissing (BarInstInd(i)))then
BaroclinicIndex(in)=BaroclinicIndex(in)+BarInstInd(i)
end if

end do

in=in+1

end do

end do

print(BaroclinicIndex)


print(fStations)

wks = gsn_open_wks("png","xy2") ; send graphics to PNG file

  res1             = True
  res2             = True
  res3             = True

  res1@gsnMaximize = True

res1@xyLineColor = "red"       ; t
  res2@xyLineColor = "green"     ; u
  res3@xyLineColor = "blue"      ; v

  res1@tiYAxisString    = "Fog instances"
  res2@tiYAxisString    = "WDI"
  res3@tiYAxisString    = "Baroclinic Instability Index"

res3@amOrthogonalPosF = 0.72   ; Move "v" axis line to right a little.

print(escorc(fStations,wdindex))
print(escorc(fStations,BaroclinicIndex))

xData=ispan(1,70,1)

plot = gsn_csm_xy3(wks,xData,fStations,wdindex,BaroclinicIndex,res1,res2,res3)

;
; Set up resources for a customized legend.
;
  lgres                    = True
  lgres@lgLineColors       = (/"red","green","blue"/)
  lgres@lgItemType         = "Lines"        ; show lines only (default)
  lgres@lgLabelFontHeightF = .08            ; legend label font thickness
  lgres@vpWidthF           = 0.13           ; width of legend (NDC)
  lgres@vpHeightF          = 0.10           ; height of legend (NDC)
  lgres@lgPerimThicknessF  = 2.0            ; thicken the box perimeter
  lgres@lgMonoDashIndex    = True
  lgres@lgDashIndex        = 0

  labels = (/"fogInstances","WDI","InstabilityInd"/)
  nitems = dimsizes(labels)                 ; number of legend items

; Create legend
  lbid = gsn_create_legend(wks,nitems,labels,lgres)

;
; Use gsn_add_annotation to attach this legend to our existing plot.
; This way, if we resize the plot, the legend will stay with the
; plot and be resized automatically.
;
  amres                  = True

;
; Point (0,0) is the dead center of the plot. Point (0,.5) is center,
; flush bottom. Point (0.5,0.5) is flush bottom, flush right.
;
  amres@amJust           = "BottomRight"    ; Use bottom right corner of box
                                            ; for determining its location.
  amres@amParallelPosF   = 0.5              ; Move legend to right
  amres@amOrthogonalPosF = 0.5              ; Move legend down.

  annoid = gsn_add_annotation(plot,lbid,amres)  ; add legend to plot

;**********************************
; Now maximize the plot
;**********************************   
; Maximize these plots for PS or PDF output. If output is                    
; to an X11 window or an NCGM file, then this routine doesn't                
; do anything.                                                               
  
  psres = True                                                               
  maximize_output(wks,psres)  ; calls draw and frame for you 


end
