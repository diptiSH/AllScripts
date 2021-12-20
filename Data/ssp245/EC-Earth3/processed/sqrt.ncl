begin

f=addfile("NH_NDJF_zg_day_EC-Earth3_ssp245_r1i1p1f1_gr_20150101-21001231.nc","r")
;zERA5NH_1000_z_daily_NovDecJan.nc


printVarSummary(f->zg)

;exit

zg_old=short2flt(f->zg(:,{100000},{20:90},:))

printVarSummary(zg_old)

;zg_old=short2flt(f->z(:,{90:20},:))
;zg=dim_standardize_n_Wrap(zg_old,1,0)

zg=zg_old

zg!1="lat"

;print(zg&lat)

printVarSummary(zg)

;exit

zg=SqrtCosWeight(zg)

printVarSummary(zg)

 ncdf = addfile("weighted1000Std.nc" ,"c")  ; open output netCDF file

;ncdf = addfile("weightedSLPDecJanStd.nc" ,"c")  ; open output netCDF file


 ncdf->zg = zg        







end
