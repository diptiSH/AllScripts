begin


nyears=dimsizes(ispan(1980,2016,1))
print(nyears)

;;;;;;;;;;*******fog data
fogfile=addfile("/home/cccr/rameshv/dipti/Data/CombineStation_fog_data_24.nc","r")
fogdata=fogfile->fogdata
printVarSummary(fogdata)


fogString=new((nyears*2*31),"string")


in=0

do y=1980,2016
   ;print(y)
 do m=1,2
   ; print(m)
    if(m.eq.2)then
       mn=12
    else
      mn=m
    end if
    do d=1,31
   fogString(in)=tostring(y)+"-"+tostring(mn)+"-"+tostring(d)+","+tostring(sum(fogdata({:},{y},{mn},{d})))

   in=in+1
    

    end do
 end do
end do

asciiwrite("fogInfo.txt",fogString)






























end
