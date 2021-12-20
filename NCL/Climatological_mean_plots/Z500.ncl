begin

f=addfile("/home/cccr/rameshv/dipti/Data/eraDown/ERA5to19/Clim_ERA5PerDay_.75_DecJan_1979_2019_z500_download.nc","r")

msl_old=f->z
msl=msl_old/9.81
copy_VarMeta(msl_old,msl)
  wks=gsn_open_wks("eps","clim_z500_dec_jan_color")
  res=True
  res@gsnPolar="NH"
  res@mpCenterLonF     = 80.
    zres=res
    zres@cnLevelSelectionMode = "ManualLevels" ; use explicit levels
    zres@cnFillOn  = True
    zres@cnLinesOn       = False
    zres@cnLineColor="blue"
    zres@cnLineLabelsOn   = False
    zres@cnFillPalette = "amwg256";"cmp_b2r";"ViBlGrWhYeOrRe";"amwg256";
    zres@cnMinLevelValF  = 5100               ; set the minimum contour l
    zres@cnMaxLevelValF  = 6000                   ; set the maximum contour level
    zres@cnLevelSpacingF = 60      
 plot=gsn_csm_contour_map(wks,msl(0,:,:),zres) 



end 
