begin

f=addfile("ERA5NH_mslp_DailyDecJan.nc","r")
;f=addfile("ERA5NH_1000_z_daily_NovDecJan.nc","r")
;zERA5NH_1000_z_daily_NovDecJan.nc



slp_old=short2flt(f->msl(:,{90:20},:))
;slp_old=short2flt(f->z(:,{90:20},:))
slp=dim_standardize_n_Wrap(slp_old,1,0)

;slp=slp/9.81

slp=slp/100.0

slp!1="lat"

printVarSummary(slp)

;exit

slp=SqrtCosWeight(slp)

printVarSummary(slp)

; ncdf = addfile("weighted1000Std.nc" ,"c")  ; open output netCDF file

ncdf = addfile("weightedSLPDecJanStd.nc" ,"c")  ; open output netCDF file


 ncdf->slp = slp        







end
