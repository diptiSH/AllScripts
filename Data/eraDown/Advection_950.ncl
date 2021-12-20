begin


; Units: u*(dT/dlon) + v(dT/dlat)  ->  (m/s)*(K/m) => K/s. If T were degC, the units would be C/s. 

   fuvr = addfile ("/home/cccr/rameshv/dipti/Data/eraDown/ERA5Daily_.75_NovDecJanFeb_1979_2018_uvrh950_download.nc", "r")

ft = addfile ("/home/cccr/rameshv/dipti/Data/eraDown/ERA5Daily_.75_NovDecJanFeb_1979_2018_t950_download.nc", "r")

   u = fuvr->u           ; (time,lev,lat,lon); (7,17,73,144);  m/s
   v = fuvr->v
   t = ft->t           ; degK
   q=fuvr->q      ; kg/kg

  u=u(:,::-1,:)
  v=v(:,::-1,:)
  t=t(:,::-1,:)
  q=q(:,::-1,:)
printVarSummary(u)
printVarSummary(t)



   cyclic    = True   ; Grid is global
   opt_adv   = 0      ; Return only the advected variable

   long_name = "specific humidity advection: NH"
   units     = "kg/kgs"
   gridType  = 0   ; global gaussian grid

 advq=advect_variable(u,v,q,gridType,long_name,units,opt_adv)

;   advTcfd=advect_variable(u,v,t,gridType,long_name,units,opt_adv)

   ;advTcfd   = advect_variable_cfd(u,v,T, t&latitude,t&longitude, cyclic, long_name, units, opt_adv)

 ;  printVarSummary(advTcfd)
 ;  printMinMax(advTcfd, 0)

;
 ;     system("/bin/rm -f tempAdvect950.nc")   ; remove any pre-existing file
 ;      ncdf = addfile("tempAdvect950.nc" ,"c")  ; open output netCDF file

 ;ncdf->advTcfd = advTcfd             

     system("/bin/rm -f humidityAdvect950.nc")   ; remove any pre-existing file
      ncdf = addfile("humidityAdvect950.nc" ,"c")  ; open output netCDF file

 ncdf->advq = advq













end
