begin

;*******fog data
fogfile=addfile("/home/cccr/rameshv/dipti/Data/CombinedFogData_25Stations.nc","r")
fogdata=fogfile->fogdata
;printVarSummary(fogdata)

;;;;;;;;htfile
fhtFile=addfile("/home/cccr/rameshv/dipti/Data/eraDown/ERA5to19/StdAnomERA5PerDay_.75_decJan_1979_2019_z500_download.nc","r")
;;;; read variables
z_old=short2flt(fhtFile->z(:,:,:))
time=fhtFile->time
units=z_old&time@units
;;;;;;; Convert to appropriate units
z=z_old/9.81
copy_VarMeta(z_old,z)
printVarSummary(z)



fogcntNeg=0
fogcntPos=0
nofogcntNeg=0
nofogcntPos=0
do yr=1980,2019 ;;;;;; year loop
 do mn=0,1 ;;;;;;month loop
    if(mn.eq.0)then
      year=yr-1
      mon=12
    else
      year=yr
      mon=1
    end if 
  do da=1,31;;;;;;day loop
   JTime=cd_inv_calendar(year,mon,da,9,00,00,units,0)
   if (sum(fogdata(:,{year},{mon},{da})).ge.12) then ;;;;; widespread count
     if(avg(z({JTime},{20:40},{60:85})).lt.0.0)then
      fogcntNeg=fogcntNeg+1
     end if
     if(avg(z({JTime},{20:40},{60:85})).gt.0.0)then
      fogcntPos=fogcntPos+1
     end if
   end if ;;;;; widespread count

   if (sum(fogdata(:,{year},{mon},{da})).eq.0) then ;;;;;;no fog count
     if(avg(z({JTime},{20:40},{60:85})).lt.0.0)then
      nofogcntNeg=nofogcntNeg+1
     end if
     if(avg(z({JTime},{20:40},{60:85})).gt.0.0)then
      nofogcntPos=nofogcntPos+1
     end if      
   end if ;;;;;;no fog count

  end do ;;;;;;day loop
 end do ;;;;;;month loop
end do ;;;;;; year loop

print(fogcntNeg)
print(nofogcntNeg)
print(fogcntPos)
print(nofogcntPos)


;;;;;;;;;; get dates

fNegDay=new(fogcntNeg,"string")
fPosDay=new(fogcntPos,"string")
nfNegDay=new(nofogcntNeg,"string")
nfPosDay=new(nofogcntPos,"string")


fogcntNeg=0
fogcntPos=0
nofogcntNeg=0
nofogcntPos=0
do yr=1980,2019 ;;;;;; year loop
 do mn=0,1 ;;;;;;month loop
    if(mn.eq.0)then
      year=yr-1
      mon=12
    else
      year=yr
      mon=1
    end if 
  do da=1,31;;;;;;day loop
   JTime=cd_inv_calendar(year,mon,da,9,00,00,units,0)
   if (sum(fogdata(:,{year},{mon},{da})).ge.12) then ;;;;; widespread count
     if(avg(z({JTime},{20:40},{60:85})).lt.0.0)then
      fNegDay(fogcntNeg)=year+"-"+mon+"-"+da
      fogcntNeg=fogcntNeg+1
     end if
     if(avg(z({JTime},{20:40},{60:85})).gt.0.0)then
      fPosDay(fogcntPos)=year+"-"+mon+"-"+da
      fogcntPos=fogcntPos+1
     end if
   end if ;;;;; widespread count

   if (sum(fogdata(:,{year},{mon},{da})).eq.0) then ;;;;;;no fog count
     if(avg(z({JTime},{20:40},{60:85})).lt.0.0)then
      nfNegDay(nofogcntNeg)=year+"-"+mon+"-"+da     
      nofogcntNeg=nofogcntNeg+1
     end if
     if(avg(z({JTime},{20:40},{60:85})).gt.0.0)then
      nfPosDay(nofogcntPos)=year+"-"+mon+"-"+da
      nofogcntPos=nofogcntPos+1
     end if      
   end if ;;;;;;no fog count

  end do ;;;;;;day loop
 end do ;;;;;;month loop
end do ;;;;;; year loop

;;;;;;;;;;;;plot

;;;;;;;;htfile
fhtFile=addfile("/home/cccr/rameshv/dipti/Data/eraDown/ERA5to19/AnomERA5PerDay_.75_DecJan_1979_2019_z500_download.nc","r")
;;;; read variables
z_old=short2flt(fhtFile->z(:,:,:))
time=fhtFile->time
units=z_old&time@units
;;;;;;; Convert to appropriate units
z=z_old/9.81
copy_VarMeta(z_old,z)
printVarSummary(z)

z_var_fogNeg=new((/fogcntNeg,dimsizes(z(0,:,0)),dimsizes(z(0,0,:))/),typeof(z))
z_var_nofogNeg=new((/nofogcntNeg,dimsizes(z(0,:,0)),dimsizes(z(0,0,:))/),typeof(z))
z_var_fogPos=new((/fogcntPos,dimsizes(z(0,:,0)),dimsizes(z(0,0,:))/),typeof(z))
z_var_nofogPos=new((/nofogcntPos,dimsizes(z(0,:,0)),dimsizes(z(0,0,:))/),typeof(z))

year11=toint(str_get_field(fNegDay,1,"-"))
mon11=toint(str_get_field(fNegDay,2,"-"))
da11=toint(str_get_field(fNegDay,3,"-"))
;print(year11)
;print(mon11)
;print(da11)

do i=0,fogcntNeg-1
JTime=cd_inv_calendar(year11(i),mon11(i),da11(i),9,00,00,units,0)
z_var_fogNeg(i,:,:)=z({JTime},:,:)
end do

delete(year11)
delete(mon11)
delete(da11)


year11=toint(str_get_field(fPosDay,1,"-"))
mon11=toint(str_get_field(fPosDay,2,"-"))
da11=toint(str_get_field(fPosDay,3,"-"))
;print(year11)
;print(mon11)
;print(da11)

do i=0,fogcntPos-1
JTime=cd_inv_calendar(year11(i),mon11(i),da11(i),9,00,00,units,0)
z_var_fogPos(i,:,:)=z({JTime},:,:)
end do

delete(year11)
delete(mon11)
delete(da11)

;;;
year11=toint(str_get_field(nfNegDay,1,"-"))
mon11=toint(str_get_field(nfNegDay,2,"-"))
da11=toint(str_get_field(nfNegDay,3,"-"))
;print(year11)
;print(mon11)
;print(da11)

do i=0,nofogcntNeg-1
JTime=cd_inv_calendar(year11(i),mon11(i),da11(i),9,00,00,units,0)
z_var_nofogNeg(i,:,:)=z({JTime},:,:)
end do

delete(year11)
delete(mon11)
delete(da11)


year11=toint(str_get_field(nfPosDay,1,"-"))
mon11=toint(str_get_field(nfPosDay,2,"-"))
da11=toint(str_get_field(nfPosDay,3,"-"))
;print(year11)
;print(mon11)
;print(da11)

do i=0,nofogcntPos-1
JTime=cd_inv_calendar(year11(i),mon11(i),da11(i),9,00,00,units,0)
z_var_nofogPos(i,:,:)=z({JTime},:,:)
end do

delete(year11)
delete(mon11)
delete(da11)

comp_z_fogNeg=dim_avg_n_Wrap(z_var_fogNeg,0)
comp_z_nofogNeg=dim_avg_n_Wrap(z_var_nofogNeg,0)
comp_z_fogPos=dim_avg_n_Wrap(z_var_fogPos,0)
comp_z_nofogPos=dim_avg_n_Wrap(z_var_nofogPos,0)


wks = gsn_open_wks("eps","Fog_noFog_Composite_PosNeg")
plot=new(4,"graphic")

res=True
res@gsnDraw      =  False                   ; do not draw the plot
res@gsnFrame                = False            ; so we can draw time stamp
res@gsnRightString = ""
res@gsnLeftString = " "
;res@mpMinLonF        = 20.                   ; select a subregion
;  res@mpMaxLonF        = 150.
;  res@mpMinLatF        = 0. 
;  res@mpMaxLatF        =  70.

res@mpCenterLonF     = 80.                   ; center plot at 180
res@gsnPolar="NH"


;;;; resources for z
  zres=res
  zres@cnLinesOn       = True 
  zres@cnLineColor="blue"
  zres@gsnContourZeroLineThicknessF =0
  zres@gsnContourNegLineDashPattern = 11
  zres@gsnContourPosLineDashPattern = 0
  zres@gsnContourLineThicknessesScale=2
  zres@mpGridLineColor="grey"
  zres@cnLineLabelsOn   = True 
  zres@cnLineLabelDensityF   = 1.5               ; increase the number of line labels/line
  zres@cnLineLabelInterval   = 1  
  zres@cnLevelSelectionMode = "ManualLevels" ; use explicit levels
  zres@cnMinLevelValF  = -60.0               ; set the minimum contour level
  zres@cnMaxLevelValF  = 60.0                   ; set the maximum contour level
  zres@cnLevelSpacingF = 10                     ; set the interval between contours

  zres@gsnCenterString = "Fog Days Neg"
  zres@gsnLeftString=tostring(fogcntNeg)
plot(0)=gsn_csm_contour_map(wks,comp_z_fogNeg,zres)
  zres@gsnCenterString = "No Fog Days Neg"
  zres@gsnLeftString=tostring(nofogcntNeg)
plot(1)=gsn_csm_contour_map(wks,comp_z_nofogNeg,zres)
  zres@gsnCenterString = "Fog Days Pos"
  zres@gsnLeftString=tostring(fogcntPos)
plot(2)=gsn_csm_contour_map(wks,comp_z_fogPos,zres)
  zres@gsnCenterString = "No Fog Days Pos"
  zres@gsnLeftString=tostring(nofogcntPos)
plot(3)=gsn_csm_contour_map(wks,comp_z_nofogPos,zres)


;;;;;;;;;;;;;;;;;; panel resources
  resP                = True                ; panel only resources
  resP@gsnMaximize    = True                ; maximize plots
  resP@gsnPanelMainString="Anomalous Composite for 500hPa geopotential height (m)"
  resP@gsnPanelLabelBar=True     ;; add common label bar 
  gsn_panel(wks,plot,(/2,2/),resP)


end
