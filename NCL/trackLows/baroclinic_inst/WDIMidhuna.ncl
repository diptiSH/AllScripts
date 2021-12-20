begin

;;;;;;;; input files

fin200z=addfile("/home/cccr/rameshv/dipti/Data/eraDown/AnomERA5PerDay_.75_NovDecJanFeb_1979_2016_z200_download.nc","r")
fin850z=addfile("/home/cccr/rameshv/dipti/Data/eraDown/AnomERA5PerDay_.75_NovDecJanFeb_1979_2016_z850_download.nc","r")


;;;;;;;;; Read Variables
z200_old=fin200z->z
z850_old=fin850z->z
printVarSummary(z200_old)
time=fin200z->time
units=z200_old&time@units

;;;;;;; Convert to appropriate units
z200=z200_old/9.81
z850=z850_old/9.81

copy_VarMeta(z200_old,z200)
copy_VarMeta(z850_old,z850)

printVarSummary(z850)
printVarSummary(z200)

WDI=z850
WDI=z850-z200

WDI@standard_name="WD Index"
WDI@long_name="WD Index Midhuna et al 2020"

system("/bin/rm -f WDI.nc")   ; remove any pre-existing file
       ncdf = addfile("WDI.nc" ,"c")  ; open output netCDF file
  ncdf->WDI  = WDI  











end
