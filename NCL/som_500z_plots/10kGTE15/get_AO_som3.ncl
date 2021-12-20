begin

;;;;;;;;; read Dates

data=asciiread("som3GTE15.txt",-1,"string")

print(data)

 inputVals=dimsizes(data)
 print(inputVals)

delim="-"
year=toint(str_get_field(data, 1, delim))
month=toint(str_get_field(data, 2, delim))
day=toint(str_get_field(data, 3, delim))


print(day)


;  print(data)

   AOdata   = readAsciiTable ("/home/cccr/rameshv/dipti/NCL/AO_EU/AO_Data",4, "float",0)

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

asciiwrite ("AO_som3GTE15.txt" , combined_data)


end
