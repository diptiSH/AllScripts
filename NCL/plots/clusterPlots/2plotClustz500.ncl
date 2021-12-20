begin
lats=10
latn=40
lonf=60
lonr=100
nsoms=8
ftlevel=addfile("/home/cccr/rameshv/dipti/Data/ERA5/ERA5files/AnomER5_500hPa_pl_DecJan_1979-2019_0_Down.nc","r")
fsurface=addfile("/home/cccr/rameshv/dipti/Data/ERA5/ER5_t2md2m_NovDecJan_1979-2019_0_Down.nc","r")
;tsurf=short2flt(fsurface->t2m(:,{23:32},{73:86}))
dsurf=short2flt(fsurface->d2m(:,{23:32},{73:86}))
tsurf=ftlevel->z(:,{lats:latn},{lonf:lonr})
units=tsurf&time@units
labels=toint(asciiread("3Write4_by_2.txt",-1,"float"))
allDays=dimsizes(tsurf(:,0,0))
print(dimsizes(tsurf(:,0,0)))
;exit

;print(labels)

data=asciiread("/home/cccr/rameshv/dipti/NCL/GetWidespreadFogDays/WSFogDays_1.5ddCriteriaRF50Per.txt",-1,"string")
delim=","
dates=str_get_field(data, 1, delim)
delim="-"
year=toint(str_get_field(dates, 1, delim))
months=toint(str_get_field(dates, 2, delim))
days=toint(str_get_field(dates, 3, delim))

;;;;;;;;;;; get count of each label
labelCount=new(8,"integer")
labelCount=0
do i=0,allDays-1
 do j=0,nsoms-1
  if (labels(i).eq.j) then
   labelCount(j)=labelCount(j)+1
  end if
 end do
end do

print(labelCount)
printVarSummary(tsurf)

;;;;;;;;;;;;;;;;;;;;;; Get fog day distribution
foglabelCount=new(8,"integer")
foglabelCount=0
timecord=(tsurf&time)
do j=0,dimsizes(data)-1
Time=cd_inv_calendar(year(j),months(j),days(j),0,0,0,units,0)
print(Time)
index=ind(timecord.eq.Time)
print(index)

do i=0,nsoms-1
  if (labels(index).eq.i) then
   foglabelCount(i)=foglabelCount(i)+1
  end if
 end do


end do

print(foglabelCount)


;;;;;;;;;;;;;; plot som map
do i=0,nsoms-1

dd=new((/labelCount(i),dimsizes(tsurf(0,:,0)),dimsizes(tsurf(0,0,:))/),typeof(tsurf))

 dd!0 = "time"
 dd!1 = "latitude"
 dd!2 = "longitude"

dd&latitude=tsurf&latitude
dd&longitude=tsurf&longitude

printVarSummary(dd)
k=0
do j=0,allDays-1
;Time=cd_inv_calendar(year(j),months(j),days(j),0,0,0,units,0)

if (labels(j).eq.i) then

dd(k,:,:)=tsurf(j,:,:)
k=k+1

end if


end do

ddavg=dim_avg_n_Wrap(dd,0)
printVarSummary(ddavg)
wks = gsn_open_wks("png" ,"z500_ce"+i)      ; send graphics to PNG file

  res                       = True     ; plot mods desired

  res@gsnMaximize           = True     ; Make plot fit the frame
  res@cnFillOn              = True     ; turn on color fill
  res@cnLinesOn             = False    ; turn of contour lines
  res@cnLevelSpacingF       = 0.5      ; contour spacing
  res@cnFillPalette         = "BlRe"
  res@lbOrientation         = "Vertical"

  res@gsnAddCyclic          = False    ; data already has cyclic point
				       ; this must also be set for any zoom

;
; Note that the gsn_csm_*map* templates automatically set 
; res@mpLimitMode="LatLon" for you. If you are plotting a 
; different projection, you may have to set this resource.
;
  res@mpMinLatF            = lats      ; range to zoom in on
  res@mpMaxLatF            =  latn
  res@mpMinLonF            =  lonf
  res@mpMaxLonF            = lonr
  res@gsnLeftString=labelCount(i)
  res@gsnRightString=foglabelCount(i)
   res@gsnCenterString=1.0*foglabelCount(i)/dimsizes(data)
 
  res@cnLevelSelectionMode = "ManualLevels"	; manually set the contour levels with the following 3 resources
  res@cnMinLevelValF  = -400.			; set the minimum contour level
  res@cnMaxLevelValF  = 400.			; set the maximum contour level
  res@cnLevelSpacingF = 50.			; set the interval between contours
  res@tiMainString = "Default map tickmark labels"
  plot = gsn_csm_contour_map(wks,ddavg, res)

delete(wks)
delete(plot)
delete(dd)
end do


end
