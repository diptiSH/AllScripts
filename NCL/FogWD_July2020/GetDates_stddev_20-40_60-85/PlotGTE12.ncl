begin


;;;;;;;; input files

fin500z=addfile("/home/cccr/rameshv/dipti/Data/eraDown/StdAnomERA5PerDay_.75_decJan_1979_2018_z500_download.nc","r")


;*******fog data
fogfile=addfile("/home/cccr/rameshv/dipti/Data/CombineStation_fog_data_24.nc","r")
fogdata=fogfile->fogdata
printVarSummary(fogdata)

;;;;;;;;; Read Variables
z500_old=fin500z->z(:,{0:40},{65:100})
time=fin500z->time
units=z500_old&time@units

;;;;;;; Convert to appropriate units
z500=z500_old

copy_VarMeta(z500_old,z500)


dims=dimsizes(z500(0,:,:))


;;;get counts

cntNE=0
cntPO=0


npoints=0.0
do yr=1979,2014
  if(yr.eq.1979) then
    stMon=2
  else
    stMon=1
  end if

if(yr.eq.2014) then
    edMon=1
  else
    edMon=2
  end if
   
 do mon=stMon,edMon
  if(mon.eq.2)then
    mn=12
  else
    mn=mon
  end if
  do d=1,31
    JTime=cd_inv_calendar(yr,mn,d,9,00,00,units,0)
   npoints= avg(z500({JTime},{20:40},{60:85}))
;;;criteria
    if(sum(fogdata({:},{yr},{mn},{d})).ge.12)then

      
    if(npoints.lt.0)then
       cntNE=cntNE+1
      end if 


    if(npoints.gt.0)then
       cntPO=cntPO+1
      end if 

    end if

  end do
 end do
end do

;;;;;;;;;;;;; data for plotting

;;;;;;;;;;slp file
fslp=addfile("/home/cccr/rameshv/dipti/Data/eraDown/AnomERA5PerDay_.75_decJan_1979_2018_z500_download.nc","r")
;;;; read variables
slp_old=short2flt(fslp->z(:,{0:70},{20:150}))
;;;;;;; Convert to appropriate units
slp=slp_old/9.81


copy_VarMeta(slp_old,slp)

units=slp&time@units




slp_varNE=new((/cntNE,dimsizes(slp(0,:,0)),dimsizes(slp(0,0,:))/),typeof(slp))
slp_varPO=new((/cntPO,dimsizes(slp(0,:,0)),dimsizes(slp(0,0,:))/),typeof(slp))

cntNE=0
cntPO=0


npoints=0.0
do yr=1979,2014
  if(yr.eq.1979) then
    stMon=2
  else
    stMon=1
  end if

if(yr.eq.2014) then
    edMon=1
  else
    edMon=2
  end if
   
 do mon=stMon,edMon
  if(mon.eq.2)then
    mn=12
  else
    mn=mon
  end if
  do d=1,31
    JTime=cd_inv_calendar(yr,mn,d,9,00,00,units,0)
   npoints= avg(z500({JTime},{20:40},{60:85}))
;;;criteria
    if(sum(fogdata({:},{yr},{mn},{d})).ge.12)then

      
    if(npoints.lt.0)then
       slp_varNE(cntNE,:,:)=slp({JTime},:,:) 
       cntNE=cntNE+1
      end if 


    if(npoints.gt.0)then
      slp_varPO(cntPO,:,:)=slp({JTime},:,:)
       cntPO=cntPO+1
      end if 

    end if

  end do
 end do
end do

;;;;;;;;; Average over time to get composite values
comp_slp_NE=dim_avg_n_Wrap(slp_varNE,0)
comp_slp_PO=dim_avg_n_Wrap(slp_varPO,0)

wks = gsn_open_wks("png","Anom500z_GTE12")         ; send graphics to PNG filenom
plot=new(2,"graphic")

;;;;;;;resources

  res = True
  res@gsnDraw      =  False                   ; do not draw the plot
  res@gsnFrame     =  False                   ; do not advance the frame
  res@mpFillOn = False
  res@cnFillOn        = True                  ; color fill
  res@cnLinesOn       = True                 ; do not draw contour lines
  res@cnFillPalette   = "BlWhRe";"BlueRed";"BlueDarkRed18"
  res@mpOutlineOn = True      ; turn the map outline on
  res@lbLabelBarOn= False ;;; turn off individual label bar
  res@mpGeophysicalLineColor = "black"
  res@gsnContourNegLineDashPattern = 11
  res@gsnContourPosLineDashPattern = 0
  res@gsnContourZeroLineThicknessF=2

 res@cnLevelSelectionMode = "ManualLevels" ; use explicit levels
  res@cnMinLevelValF  = -50.0                    ; set the minimum contour level
  res@cnMaxLevelValF  = 50.0                    ; set the maximum contour level
  res@cnLevelSpacingF = 5.0                     ; set the interval between contours
  res@gsnAddCyclic=False
  res@gsnRightString = ""
  res@mpCenterLonF     = 80.                   ; center plot at 180
  res@mpMinLonF        = 20.                   ; select a subregion
  res@mpMaxLonF        = 150.
  res@mpMinLatF        = 0. 
  res@mpMaxLatF        =  70.
  res@gsnLeftString = " "

  res@gsnCenterString = "PO"
  res@gsnLeftString=cntPO
  res@gsnRightString=" "
  plot(0) = gsn_csm_contour_map(wks,comp_slp_PO,res)    ; create and draw the temperature plot

 res@gsnCenterString = "NE"
  res@gsnLeftString=cntNE
  res@gsnRightString=" "
  plot(1) = gsn_csm_contour_map(wks,comp_slp_NE,res)    ; create and draw the temperature plot


;;;;;;;;;;;;;;;;;; panel resources
  resP                = True                ; panel only resources
  resP@gsnMaximize    = True                ; maximize plots
  resP@gsnPanelMainString="500 hPa Geopotential height"
  resP@gsnPanelLabelBar=True     ;; add common label bar 
;resP@gsnPanelRowSpec = True
gsn_panel(wks,plot,(/1,2/),resP)

end
