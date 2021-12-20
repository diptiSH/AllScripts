begin

;;;;;;;; input files

finBII=addfile("/home/cccr/rameshv/dipti/Data/eraDown/BII.nc","r")


;*******fog data
fogfile=addfile("/home/cccr/rameshv/dipti/Data/CombineStation_fog_data_24.nc","r")
fogdata=fogfile->fogdata
printVarSummary(fogdata)

;;;;;;;;; Read Variables
BII=finBII->BII(:,{25:40},{60:80})

printVarSummary(BII)
time=finBII->time
units=BII&time@units


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
  
   npoints1= ( avg(BII({JTime},{:},{:})))
   
   outString(in)=yr+"-"+mn+"-"+d+","+sum(fogdata({:},{yr},{mn},{d}))+","+npoints1
   in=in+1
  end do
 end do
end do


asciiwrite ("WDCHaracter_1979to2014_BII_Madhura.txt",outString)



end
