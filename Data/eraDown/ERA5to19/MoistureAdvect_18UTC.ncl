begin

inFile=addfile("ERA5_.75Globe_18UTC_NovDecJan_1979_2019_uvq_975.nc","r")
u=short2flt(inFile->u)
v=short2flt(inFile->v)
q=short2flt(inFile->q)

u_rev=u(:,::-1,:)
v_rev=v(:,::-1,:)
q_rev=q(:,::-1,:)

printVarSummary(u_rev)
printVarSummary(v_rev)
printVarSummary(q_rev)

 gridType  = 1   ; global rectilinear grid
   opt_adv   = 0   ; return only the advected variable
 
   long_name = "advection of specific humidity"
   units     = "Kgkg-1/s"

   Qadv = advect_variable(u_rev,v_rev,q_rev,gridType,long_name,units,opt_adv)

   printVarSummary(Qadv)  
   printMinMax(Qadv, 0)  

 ncdf = addfile("QAdvection18UTC.nc" ,"c")  ; open output netCDF file
  ncdf->Qadv  = Qadv    
     




end