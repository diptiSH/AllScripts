begin

inFileq=addfile("DailyERA5_1000_q_6hourly_NovDecJan.nc","r")

inFile=addfile("DailyERA5_1000_u_6hourly_NovDecJan.nc","r")
u=short2flt(inFile->u(:,{1},:,:))
inFile=addfile("DailyERA5_1000_v_6hourly_NovDecJan.nc","r")
v=short2flt(inFile->v(:,{1},:,:))
q=short2flt(inFileq->q(:,{1},:,:))

nlat=dimsizes(u(0,:,0))
nlon=dimsizes(u(0,0,:))

time=u&time
latitude=u&latitude
longitude=u&longitude

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

 fout = addfile("Daily_QAdvection_1000hPa.nc" ,"c")  ; open output netCDF file

  setfileoption(fout,"DefineMode",True)

       dimNames = (/"time", "latitude", "longitude"/)  
	dimSizes = (/ -1   ,  nlat,  nlon /) 
	dimUnlim = (/ True , False, False/)   
	filedimdef(fout,dimNames,dimSizes,dimUnlim)


       filevardef(fout, "time" ,typeof(time),getvardims(time)) 
       filevardef(fout, "latitude"  ,typeof(latitude),getvardims(latitude))                          
       filevardef(fout, "longitude"  ,typeof(longitude),getvardims(longitude))                          
       filevardef(fout, "Qadv"    ,typeof(Qadv)  ,getvardims(Qadv)) 

       filevarattdef(fout,"time" ,time)                    ; copy time attributes
       filevarattdef(fout,"latitude"  ,latitude)                     ; copy lat attributes
       filevarattdef(fout,"longitude"  ,longitude)                     ; copy lon attributes
       filevarattdef(fout,"Qadv"   ,Qadv)  

 setfileoption(fout,"DefineMode",False)

  fout->time   = (/time/)     
       fout->latitude    = (/latitude/)
       fout->longitude    = (/longitude/) 
       fout->Qadv      = (/Qadv/)    


     




end
