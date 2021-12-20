begin

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


;print("fffffffff")
;alist15   = [/yrs15,mns15,days15/]
;alist3= [/yrs3,mns3,days3/]
;print("ffffffffffff")


;write_table("DatesGTE15.txt", "w", alist15, "%s")
;write_table("DatesLTE3.txt", "w", alist3, "%s")


asciiwrite ("DatesGTE15.txt",dateString15)
asciiwrite ("DatesLTE3.txt",dateString3)


end





