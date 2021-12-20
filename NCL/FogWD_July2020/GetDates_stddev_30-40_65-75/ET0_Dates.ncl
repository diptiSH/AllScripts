begin


;;;;;;;; input files

fin500z=addfile("/home/cccr/rameshv/dipti/Data/eraDown/StdAnomERA5PerDay_.75_decJan_1979_2018_z500_download.nc","r")


;*******fog data
fogfile=addfile("/home/cccr/rameshv/dipti/Data/CombineStation_fog_data_24.nc","r")
fogdata=fogfile->fogdata
printVarSummary(fogdata)

;;;;;;;;; Read Variables
z500_old=fin500z->z(:,{0:40},{65:100})
time=fin500z->time
units=z500_old&time@units

;;;;;;; Convert to appropriate units
z500=z500_old

copy_VarMeta(z500_old,z500)


dims=dimsizes(z500(0,:,:))


;;;get counts
cntAll=0
cnt=0
cnt0_neg1=0
cntneg1=0
cnt0_pos1=0
cntpos1=0
cntNE=0
cntPO=0
npoints=0.0
do yr=1979,2014
  if(yr.eq.1979) then
    stMon=2
  else
    stMon=1
  end if

if(yr.eq.2014) then
    edMon=1
  else
    edMon=2
  end if
   
 do mon=stMon,edMon
  if(mon.eq.2)then
    mn=12
  else
    mn=mon
  end if
  do d=1,31
    JTime=cd_inv_calendar(yr,mn,d,9,00,00,units,0)
   npoints= avg(z500({JTime},{30:40},{65:75}))
;;;criteria
    if(sum(fogdata({:},{yr},{mn},{d})).eq.0)then

       cntAll=cntAll+1

      if(npoints.eq.0)then
       cnt=cnt+1
      end if   

     if(npoints.lt.0 .and. npoints.gt.-1)then
       cnt0_neg1=cnt0_neg1+1
      end if 

    if(npoints.le.-1)then
       cntneg1=cntneg1+1
      end if 

if(npoints.gt.0 .and. npoints.lt.1)then
       cnt0_pos1=cnt0_pos1+1
      end if 

    if(npoints.ge.1)then
       cntpos1=cntpos1+1
      end if 

if(npoints.lt.0)then
       cntNE=cntNE+1
      end if 

if(npoints.gt.0)then
       cntPO=cntPO+1
      end if 


    end if

  end do
 end do
end do

print(cntNE)
print(cntPO)

;;;;;;;;;;;; get outstring
outStringNE=new((cntNE),"string")
outStringPO=new((cntPO),"string")
outString0_neg1=new((cnt0_neg1),"string")
outStringneg1=new((cntneg1),"string")
outString0_pos1=new((cnt0_pos1),"string")
outStringpos1=new((cntpos1),"string")
outStringcntAll=new((cntAll),"string")
         

npoints=0.0
cnt0_neg1=0
cntneg1=0
cnt0_pos1=0
cntpos1=0
cntNE=0
cntPO=0
cntAll=0

do yr=1979,2014
  if(yr.eq.1979) then
    stMon=2
  else
    stMon=1
  end if

if(yr.eq.2014) then
    edMon=1
  else
    edMon=2
  end if
   
 do mon=stMon,edMon
  if(mon.eq.2)then
    mn=12
  else
    mn=mon
  end if
  do d=1,31
    JTime=cd_inv_calendar(yr,mn,d,9,00,00,units,0)
   npoints= avg(z500({JTime},{30:40},{65:75}))
;;;criteria
    if(sum(fogdata({:},{yr},{mn},{d})).eq.0)then
        outStringcntAll(cntAll)=yr+"-"+mn+"-"+d  
          cntAll=cntAll+1
     if(npoints.lt.0 .and. npoints.gt.-1)then
       outString0_neg1(cnt0_neg1)=yr+"-"+mn+"-"+d
       cnt0_neg1=cnt0_neg1+1
      end if 

    if(npoints.le.-1)then
      outStringneg1(cntneg1)=yr+"-"+mn+"-"+d
       cntneg1=cntneg1+1
      end if 

if(npoints.gt.0 .and. npoints.lt.1)then
      outString0_pos1(cnt0_pos1)=yr+"-"+mn+"-"+d
       cnt0_pos1=cnt0_pos1+1
      end if 

    if(npoints.ge.1)then
       outStringpos1(cntpos1)=yr+"-"+mn+"-"+d
       cntpos1=cntpos1+1
      end if 

if(npoints.lt.0)then
       outStringNE(cntNE)=yr+"-"+mn+"-"+d
       cntNE=cntNE+1
      end if 

if(npoints.gt.0)then
       outStringPO(cntPO)=yr+"-"+mn+"-"+d
       cntPO=cntPO+1
      end if 


    end if

  end do
 end do
end do

asciiwrite ("Dates_ETO_cntAll.txt",outStringcntAll)
asciiwrite ("Dates_ETO_0_pos1.txt",outString0_pos1)
asciiwrite ("Dates_ETO_0_neg1.txt",outString0_neg1)
asciiwrite ("Dates_ETO_neg1.txt",outStringneg1)
asciiwrite ("Dates_ETO_PO.txt",outStringPO)
asciiwrite ("Dates_ETO_NE.txt",outStringNE)
asciiwrite ("Dates_ETO_pos1.txt",outStringpos1)




end
