begin

;;;;;;;; EU files
infile1=addfile("STD145E40N_NORM_ERADAILY-500hPa-NovDecJan1979-2019.nc","r")
infile2=addfile("STD20E55N_NORM_ERADAILY-500hPa-NovDecJan1979-2019.nc","r")
infile3=addfile("STD75E55N_NORM_ERADAILY-500hPa-NovDecJan1979-2019.nc","r")

time = infile1->time
z145E40N=dim_avg_n_Wrap(infile1->z,(/1,2/))

;printVarSummary(z145E40N)
;print(z145E40N)
z20E55N=dim_avg_n_Wrap(infile2->z,(/1,2/))

z75E55N=dim_avg_n_Wrap(infile3->z,(/1,2/))

;printVarSummary(z20E55N)
;printVarSummary(z75E55N)


EUVal=-(1.0/4.0)*z20E55N+(1.0/2.0)*z75E55N-(1.0/4.0)*z145E40N

printVarSummary(EUVal)

copy_VarMeta(z20E55N,EUVal)

printVarSummary(EUVal)

print(EUVal)

ncdf = addfile("EU_NovDecJan.nc" ,"c")  ; open output netCDF file

ncdf->EUVal = EUVal

end

