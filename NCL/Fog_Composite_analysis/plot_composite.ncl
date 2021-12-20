begin

;*******fog data
fogfile=addfile("/home/cccr/rameshv/dipti/Data/CombinedFogData_25Stations.nc","r")
fogdata=fogfile->fogdata
;printVarSummary(fogdata)


fogcnt=0
nofogcnt=0
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
 
   if (sum(fogdata(:,{year},{mon},{da})).ge.12) then ;;;;; widespread count
      fogcnt=fogcnt+1
   end if ;;;;; widespread count

   if (sum(fogdata(:,{year},{mon},{da})).eq.0) then ;;;;;;no fog count
      nofogcnt=nofogcnt+1
   end if ;;;;;;no fog count

  end do ;;;;;;day loop
 end do ;;;;;;month loop
end do ;;;;;; year loop

print(fogcnt)
print(nofogcnt)

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

z_var_fog=new((/fogcnt,dimsizes(z(0,:,0)),dimsizes(z(0,0,:))/),typeof(z))
z_var_nofog=new((/nofogcnt,dimsizes(z(0,:,0)),dimsizes(z(0,0,:))/),typeof(z))

fogcnt=0
nofogcnt=0
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
      z_var_fog(fogcnt,:,:)=z({JTime},:,:)
      fogcnt=fogcnt+1
   end if ;;;;; widespread count

   if (sum(fogdata(:,{year},{mon},{da})).eq.0) then ;;;;;;no fog count
      z_var_nofog(nofogcnt,:,:)=z({JTime},:,:)
      nofogcnt=nofogcnt+1
   end if ;;;;;;no fog count

  end do ;;;;;;day loop
 end do ;;;;;;month loop
end do ;;;;;; year loop

comp_z_fog=dim_avg_n_Wrap(z_var_fog,0)
comp_z_nofog=dim_avg_n_Wrap(z_var_nofog,0)

wks = gsn_open_wks("eps","Fog_noFog_Composite")
plot=new(2,"graphic")

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

  zres@gsnCenterString = "Fog Days"
  zres@gsnLeftString=tostring(fogcnt)
plot(0)=gsn_csm_contour_map(wks,comp_z_fog,zres)
  zres@gsnCenterString = "No Fog Days"
  zres@gsnLeftString=tostring(nofogcnt)
plot(1)=gsn_csm_contour_map(wks,comp_z_nofog,zres)

;;;;;;;;;;;;;;;;;; panel resources
  resP                = True                ; panel only resources
  resP@gsnMaximize    = True                ; maximize plots
  resP@gsnPanelMainString="Anomalous Composite for 500hPa geopotential height (m)"
  resP@gsnPanelLabelBar=True     ;; add common label bar 
  gsn_panel(wks,plot,(/1,2/),resP)


end
