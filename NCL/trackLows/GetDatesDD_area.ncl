begin


;;;;;;;; input files

;fin500z=addfile("/home/cccr/rameshv/dipti/Data/eraDown/AnomERA5PerDay_.75_decJan_1979_2018_z500_download.nc","r")
finSur=addfile("/home/cccr/rameshv/dipti/Data/eraDown/ERA5_.75_decJan_1979_2018_d2m_t2m_3_download.nc","r")
foro=addfile("/home/cccr/rameshv/dipti/Data/ERA5/era5_oro0.75.nc","r")

;*******fog data
fogfile=addfile("/home/cccr/rameshv/dipti/Data/CombineStation_fog_data_24.nc","r")
fogdata=fogfile->fogdata
printVarSummary(fogdata)

;;;;;;;;; Read Variables
t2m=short2flt(finSur->t2m)
d2m=short2flt(finSur->d2m)
time=finSur->time
units=t2m&time@units
oro=short2flt(foro->z)
oro=oro/9.8

oroConf=conform(t2m,oro(0,:,:),(/1,2/))

dd=t2m
dd=t2m-d2m

printVarSummary(dd)
printVarSummary(oro)
printVarSummary(oroConf)
;;;;;;;;;;;;;;;;;;;;masked dd
maskdd=mask(dd,oroConf.gt.500.0,False)
copy_VarMeta(dd,maskdd)

print(oro(0,{35},{80}))
print(maskdd(0,{35},{80}))
print(oro(0,{22},{80}))
print(maskdd(0,{22},{80}))
print(oro(0,{21},{80}))
print(maskdd(0,{21},{80}))

print(oro(0,{25},{80}))
print(maskdd(0,{25},{80}))

print(oro(0,{28.31},{77.1}))
print(maskdd(0,{28.31},{77.1}))

print(oro(0,{31.38},{74.5}))
print(maskdd(0,{31.38},{74.5}))

print(oro(0,{25.27},{82.5}))
print(maskdd(0,{25.27},{82.5}))


print(oro(0,{25.18},{83}))
print(maskdd(0,{25.18},{83}))



print(oro(0,{28.31},{77.1}))
print(maskdd(0,{28.31},{77.1}))





nyears=dimsizes(ispan(1998,2014,1))
ntimes=nyears*2*31

outString=new((ntimes),"string")
in=0
npoints=0
do yr=1998,2014
 do mon=1,2
  if(mon.eq.2)then
    mn=12
  else
    mn=mon
  end if
  do d=1,31
    JTime=cd_inv_calendar(yr,mn,d,3,00,00,units,0)
  
   npoints= num(maskdd({JTime},{24:32},{74:86}).le.3.5)
   outString(in)=yr+"-"+mn+"-"+d+","+sum(fogdata({:},{yr},{mn},{d}))+","+npoints
   in=in+1
  end do
 end do
end do


asciiwrite ("dd_gridpoints_fogStations_3.5.txt",outString)












end
