begin


;;;;;;;; input files

fin200z=addfile("/home/cccr/rameshv/dipti/Data/eraDown/AnomERA5PerDay_.75_NovDecJanFeb_1979_2016_z200_download.nc","r")
fin850z=addfile("/home/cccr/rameshv/dipti/Data/eraDown/AnomERA5PerDay_.75_NovDecJanFeb_1979_2018_z850_download.nc","r")


;*******fog data
fogfile=addfile("/home/cccr/rameshv/dipti/Data/CombineStation_fog_data_24.nc","r")
fogdata=fogfile->fogdata
printVarSummary(fogdata)

;;;;;;;;; Read Variables
z200_old=fin200z->z(:,{25:40},{60:80})
z850_old=fin850z->z(:,{25:40},{60:80})
printVarSummary(z200_old)
time=fin200z->time
units=z200_old&time@units

;;;;;;; Convert to appropriate units
z200=z200_old/9.81
z850=z850_old/9.81

copy_VarMeta(z200_old,z200)
copy_VarMeta(z850_old,z850)
nyears=dimsizes(ispan(1979,2014,1))
ntimes=nyears*2*31

outString=new((ntimes+1),"string")
outString(0)="year-mn-d,fogstations,WDI"
in=1
npoints=0
do yr=1979,2014
 do mon=1,2
  if(mon.eq.2)then
    mn=12
  else
    mn=mon
  end if
  do d=1,31
    JTime=cd_inv_calendar(yr,mn,d,9,00,00,units,0)
  
   npoints1= ( avg(z850({JTime},{:},{:}))-avg(z200({JTime},{:},{:})))
   
   outString(in)=yr+"-"+mn+"-"+d+","+sum(fogdata({:},{yr},{mn},{d}))+","+npoints1
   in=in+1
  end do
 end do
end do


asciiwrite ("WDCHaracter_1979to2014_WDI.txt",outString)












end
