begin

;;;;;;;;;;;;;;;;;;;**************** WD Data
data=asciiread("/home/cccr/rameshv/dipti/NCL/WDAnalysis/era-interim-derived-wd-tracks.csv",-1,"string")
;print(data)

delim=","
 eventId= stringtoint( str_get_field(data, 1, delim))
; print(eventId)

lon= stringtofloat(str_get_field(data, 2, delim))
;print(lon)

lat= stringtofloat(str_get_field(data, 3, delim))
;print(lat)

intensity=stringtofloat(str_get_field(data, 4, delim))

;eventID=stringto(str_get_field(data, 6, delim))

size=stringtofloat(str_get_field(data, 5, delim))

timeStepID= stringtoint( str_get_field(data, 10, delim))
;print(timeStepID)

DateTime= str_get_field(data, 8, delim)
;print(DateTime)

delim=" "
Date=str_get_field(DateTime, 1, delim)
;print(Date)

Time=str_get_field(DateTime, 2, delim)
;rint(Time)

delim="-"
day= stringtoint(str_get_field(Date,1,delim))
month= stringtoint(str_get_field(Date,2,delim))
year= stringtoint(str_get_field(Date,3,delim))

delim=":"
time=stringtoint(str_get_field(Time,1,delim))



;*******fog data
fogfile=addfile("/home/cccr/rameshv/dipti/Data/CombineStation_fog_data_24.nc","r")
fogdata=fogfile->fogdata
printVarSummary(fogdata)


cnt15=0
cnt3=0

do yr=1998,2014
 do mon=1,2
  if(mon.eq.2)then
    mn=12
  else
    mn=mon
  end if
  do d=1,31

    if(sum(fogdata({:},{yr},{mn},{d})) .ge. 15)
	 cnt15=cnt15+1
	end if

    if(sum(fogdata({:},{yr},{mn},{d})) .le. 3)
	 cnt3=cnt3+1
	
	end if
  end do
 end do
end do


print(cnt15)
print(cnt3)


yrs15=new(cnt15,"integer")
mns15=new(cnt15,"integer")
days15=new(cnt15,"integer")
dateString15=new(cnt15,"string")
in15=0


yrs3=new(cnt3,"integer")
mns3=new(cnt3,"integer")
days3=new(cnt3,"integer")
dateString3=new(cnt3,"string")

in3=0

do yr=1998,2014
 do mon=1,2
  if(mon.eq.2)then
    mn=12
  else
    mn=mon
  end if
  do d=1,31

    if(sum(fogdata({:},{yr},{mn},{d})) .ge. 15)
         yrs15(in15)=yr
         mns15(in15)=mn
         days15(in15)=d
         dateString15(in15)=yr+"-"+mn+"-"+d
         in15=in15+1
        end if

    if(sum(fogdata({:},{yr},{mn},{d})) .le. 3)
         yrs3(in3)=yr
         mns3(in3)=mn
         days3(in3)=d    
         dateString3(in3)=yr+"-"+mn+"-"+d

         in3=in3+1


        end if
  end do
 end do
end do


;;;;;;;;;;;;;;;; LTE 3
cnt0=0
cnt1=0
cnt2=0
do wdI=0,cnt3-1
  cntObs=0
  do i=0,dimsizes(lon)-1

    if (yrs3(wdI).eq.year(i) .and. mns3(wdI).eq.month(i) .and. days3(wdI).eq.day(i) .and. (lon(i).ge.65 .and. lon(i).le.80 ) .and. (lat(i).ge.25 .and.lat(i).le.40) )then
	       cntObs=cntObs+1
       end if

  end do
  
  if(cntObs.eq.0)then
      cnt0=cnt0+1  
  else
  
	eventIDS=new(cntObs,"integer")
    inn=0
    do i=0,dimsizes(lon)-1
     if (yrs3(wdI).eq.year(i) .and. mns3(wdI).eq.month(i) .and. days3(wdI).eq.day(i) .and. (lon(i).ge.65 .and. lon(i).le.80 ) .and. (lat(i).ge.25 .and.lat(i).le.40) )then
  
      eventIDS(inn)=eventId(i) 
      inn=inn+1
      end if
    end do
    print(eventIDS)	
    if((num(get_unique_values(eventIDS))).eq.1)then
      cnt1=cnt1+1
    end if
    if((num(get_unique_values(eventIDS))).gt.1)then
      cnt2=cnt2+1
    end if

  delete(eventIDS)
  
  end if
  
end do  

print(cnt0)
print(cnt1)
print(cnt2)


dateString0=new(cnt0,"string")
dateString1=new(cnt1,"string")
dateString2=new(cnt2,"string")

in0=0
in1=0
in2=0

do wdI=0,cnt3-1
  cntObs=0
  do i=0,dimsizes(lon)-1

    if (yrs3(wdI).eq.year(i) .and. mns3(wdI).eq.month(i) .and. days3(wdI).eq.day(i) .and. (lon(i).ge.65 .and. lon(i).le.80 ) .and. (lat(i).ge.25 .and.lat(i).le.40) )then
               cntObs=cntObs+1
       end if

  end do

   if(cntObs.eq.0)then
     dateString0(in0)=yrs3(wdI)+"-"+mns3(wdI)+"-"+days3(wdI)
     in0=in0+1
  else

        eventIDS=new(cntObs,"integer")
    inn=0
    do i=0,dimsizes(lon)-1
     if (yrs3(wdI).eq.year(i) .and. mns3(wdI).eq.month(i) .and. days3(wdI).eq.day(i) .and. (lon(i).ge.65 .and. lon(i).le.80 ) .and. (lat(i).ge.25 .and.lat(i).le.40) )then

      eventIDS(inn)=eventId(i)
      inn=inn+1
      end if
    end do
    print(eventIDS)
    if((num(get_unique_values(eventIDS))).eq.1)then
      dateString1(in1)=yrs3(wdI)+"-"+mns3(wdI)+"-"+days3(wdI)
     in1=in1+1
    end if
    if((num(get_unique_values(eventIDS))).gt.1)then
      dateString2(in2)=yrs3(wdI)+"-"+mns3(wdI)+"-"+days3(wdI)
     in2=in2+1
    end if

  delete(eventIDS)

   end if

end do

asciiwrite ("WD0_DatesLTE3_65-80_25-40.txt",dateString0)
asciiwrite ("WD1_DatesLTE3_65-80_25-40.txt",dateString1)
asciiwrite ("WD2_DatesLTE3_65-80_25-40.txt",dateString2)





end





