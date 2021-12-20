begin

f=addfile("/home/cccr/rameshv/dipti/Data/eraDown/ERA5to19/Clim_ERA5PerDay_.75_DecJan_1979_2019_surface_uv_t_dt_mslp_download.nc","r")

msl_old=f->msl
msl=msl_old/100.0
copy_VarMeta(msl_old,msl)
  wks=gsn_open_wks("eps","clim_mslp_dec_jan")
  res=True
  res@gsnPolar="NH"
  res@mpCenterLonF     = 80.
    zres=res
    zres@cnLevelSelectionMode = "ManualLevels" ; use explicit levels
    zres@cnFillOn  = True
    zres@cnLinesOn       = False
    zres@cnLineLabelsOn   = False
    zres@cnFillPalette = "amwg256";"cmp_b2r";"ViBlGrWhYeOrRe";"amwg256";
    zres@cnMinLevelValF  = 993.0               ; set the minimum contour l
    zres@cnMaxLevelValF  = 1038.0                   ; set the maximum contour level
    zres@cnLevelSpacingF = 3.0      
 plot=gsn_csm_contour_map(wks,msl(0,:,:),zres) 



end 
