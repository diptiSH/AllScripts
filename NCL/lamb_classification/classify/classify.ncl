begin

f= addfile("/home/cccr/rameshv/dipti/Data/ERA5/ERA5files/ER5_MSLP_DecJan_1979-2019_0_Down.nc","r")
fsurface=addfile("/home/cccr/rameshv/dipti/Data/ERA5/ERA5files/ER5_dd_DecJan_1979-2019_0_Down.nc","r")
;finv=addfile("/home/cccr/rameshv/dipti/Data/ERA5/ERA5files/ER5_inv_DecJan_1979-2019_0_Down.nc","r")
foro=addfile("/home/cccr/rameshv/dipti/Data/ERA5/era5Orography.nc","r")

;;;;;;;;;;*******fog data
fogfile=addfile("/home/cccr/rameshv/dipti/Data/CombineStation_fog_data_24.nc","r")
fogdata=fogfile->fogdata
printVarSummary(fogdata)


slp=short2flt(f->msl)

printVarSummary(slp)

dd=short2flt(fsurface->t2m(:,{23:32},{73:86}))
;inv=short2flt(finv->t2m(:,{23:32},{73:86}))
oro=short2flt(foro->z(:,{23:32},{73:86}))
lats=dd&latitude
lons=dd&longitude


slp=slp/100.0

time=f->time

units=time@units

printVarSummary(slp)
printVarSummary(dd)

print(num((oro/9.81).lt.500.0))
gridNums=num((oro/9.81).lt.500.0)



p1=slp(:,{38},{77})
p2=slp(:,{38},{82})
p3=slp(:,{33},{72})
p4=slp(:,{33},{77})
p5=slp(:,{33},{82})
p6=slp(:,{33},{87})
p7=slp(:,{28},{72})
p8=slp(:,{28},{77})
p9=slp(:,{28},{82})
p10=slp(:,{28},{87})
p11=slp(:,{23},{72})
p12=slp(:,{23},{77})
p13=slp(:,{23},{82})
p14=slp(:,{23},{87})
p15=slp(:,{18},{77})
p16=slp(:,{18},{82})

r2d = 45.0/atan(1.0)     ; conversion factor (radians to degrees)

outTxt=new(dimsizes(slp(:,0,0)),"string")

do i=0,dimsizes(slp(:,0,0))-1

;;;;;;;get date

date=tostring(cd_calendar(time(i),-2))
;print(date)

outTxt(i)=date

;;;;;; decide LWT
FS=1.305*(0.25*(p5(i)+2.0*p9(i)+p13(i))-0.25*(p4(i)+2.0*p8(i)+p12(i)))
FW=0.5*(p12(i)+p13(i))-0.5*(p4(i)+p5(i))
ZS=0.85*(0.25*(p6(i)+2.0*p10(i)+p14(i))-0.25*(p5(i)+2.0*p9(i)+p13(i))-0.25*(p4(i)+2.0*p8(i)+p12(i))+0.25*(p3(i)+2.0*p7(i)+p11(i)))
ZW=1.12*(0.5*(p15(i)+p16(i))-0.5*(p8(i)+p9(i)))-0.91*(0.5*(p8(i)+p9(i))-0.5*(p1(i)+p2(i)))
F=sqrt(FS*FS+FW*FW)
Z=ZS+ZW

rad_dir=atan2(FW, FS)
dir = atan2(FW, FS) * 57.29578;r2d + 180 
;print(dir)

if(abs(Z).lt.F)then
typeStr="Dierectional"
outTxt(i)=outTxt(i)+","+typeStr+"_"+tostring(dir)+"_"+tostring(rad_dir)
else if(abs(Z).gt.2.0*F)then
        if(Z.gt.0)then
           typeStr="Cyclonic"
         else
           typeStr="Antiyclonic"
         end if
         outTxt(i)=outTxt(i)+","+typeStr
     else
         typeStr="Hybrid"
         if(Z.gt.0)then
           circ="Cyclonic"
         else
           circ="Antiyclonic"
         end if
    outTxt(i)=outTxt(i)+","+typeStr+"_"+circ+"_"+tostring(dir)+"_"+tostring(rad_dir)
 ;        print(circ)

     end if
end if
;print(typeStr)


;;;;;;;;;;;;;; decide no of stations reporting fog

yr=toint(str_get_cols(date,0,3))
mn=toint(str_get_cols(date,4,5))
d=toint(str_get_cols(date,6,7))

;print(yr)
if(yr.lt.2017) then
fogstr=tostring(sum(fogdata({:},{yr},{mn},{d})))

;print(fogstr)

 outTxt(i)=outTxt(i)+","+fogstr
else
 outTxt(i)=outTxt(i)+","
end if

;;;;;;;;;;;;;; Decide no of grid points satisfying fog criterion
fg_points=0
do la=0,dimsizes(lats)-1
         do lo=0,dimsizes(lons)-1
           lat=lats(la)
           lon=lons(lo)
           if((oro(0,{lat},{lon})/9.81) .le. 500.0)then
;               if(dd(i,{lat},{lon}).lt.1.5 .and. inv(i,{lat},{lon}).lt.0)then
                if(dd(i,{lat},{lon}).lt.1.5 )then
                   fg_points=fg_points+1
                end if


            end if
         end do
end do

perF=fg_points*100.0/gridNums

fogpointsstr=tostring(fg_points)


outTxt(i)=outTxt(i)+","+fogpointsstr+"_"+tostring(perF)

print(outTxt(i))
end do

;print(outTxt(0:4))

asciiwrite("Date_LWT_FStations_FPoints_ddOnly.txt",outTxt)

end

