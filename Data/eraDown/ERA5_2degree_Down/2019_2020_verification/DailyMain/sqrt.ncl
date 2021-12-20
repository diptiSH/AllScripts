begin

f=addfile("ERA5NH_1000_z_daily_NovDecJan.nc","r")

slp_old=short2flt(f->z(:,{90:20},:))
slp=slp_old;dim_standardize_n_Wrap(slp_old,1,0)

slp=slp/9.81



slp!1="lat"

printVarSummary(slp)

;exit

slp=SqrtCosWeight(slp)

printVarSummary(slp)

 ncdf = addfile("weighted1000.nc" ,"c")  ; open output netCDF file

ncdf->slp = slp



end
