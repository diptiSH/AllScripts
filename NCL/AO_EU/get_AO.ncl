begin 

 fname  = "date"        ;input Data
 inputVals=2232
 
 ;;;;;;;;; read Dates 

;data=asciiread("/home/cccr/rameshv/dipti/NCL/GetNoFogDays/NoWSFogDays_2.5ddCriteria50PerOnly_0.csv",-1,"string")
data=asciiread("AllDays.csv",-1,"string")

delim=","
dates=str_get_field(data, 1, delim)
delim="-"
year=toint(str_get_field(dates, 1, delim))
month=toint(str_get_field(dates, 2, delim))
day=toint(str_get_field(dates, 3, delim))




;  print(data)

   AOdata   = readAsciiTable ("AO_Data",4, "float",0)
  
;print(AOdata)
   
 combined_data=new((/inputVals/),"float")
; print(combined_data)

do i=0,24987
  do j=0,inputVals-1
    ;print(i)
   ;print(j)
    ;print(year(j))
    ;print(day(j))
   if ((AOdata(i,0).eq.year(j)).and.(AOdata(i,1).eq.month(j)).and.(AOdata(i,2).eq.day(j))) then
          combined_data(j)=AOdata(i,3)
          print(combined_data(j))
     
 end if
  end do
  
  end do

asciiwrite ("AO_AllDays.txt" , combined_data)

end 
