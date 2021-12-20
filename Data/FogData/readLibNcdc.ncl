
undef("FileExistence")
undef("getNCDCData")

function FileExistence(stationID,year)
 local fFlag
begin
  folder="/home/user/Documents/Data/ncdc_Jun_2020/"+tostring(year)+"/"
  fname=folder+tostring(stationID)+"099999.csv"
  fFlag=fileexists(fname)
  return(fFlag) 
end


function getNCDCData(stationID,year)
 local fData,meanTData,meanDTData,meanVisData,meanWindData,maxTData,minTData,meanDDData,meanSLPData
begin
;;;;;;;; define vars
  fData=new((/2,31/),"integer",9)
  meanTData=new((/2,31/),"float",9999.99)
  meanDTData=new((/2,31/),"float",9999.99)
  meanVisData=new((/2,31/),"float",9999.99)
  meanWindData=new((/2,31/),"float",9999.99)
  maxTData=new((/2,31/),"float",9999.99)
  minTData=new((/2,31/),"float",9999.99)
  meanDDData=new((/2,31/),"float",9999.99)
  meanMSLPData=new((/2,31/),"float",9999.99)
;;;;;;;;; open file and read raw data
  folder="/home/user/Documents/Data/ncdc_Jun_2020/"+tostring(year)+"/"
  fname=folder+tostring(stationID)+"099999.csv"
  ncdcData=asciiread(fname,-1,"string")
;  print(ncdcData)
;;;;;;;;;;;;;;; get required field as string
   delem=","
   dates=str_get_field(ncdcData(1:),2,delem)
   visString=str_get_field(ncdcData(1:),29,delem)
   meanTString=str_get_field(ncdcData(1:),8,delem)
   meanDTString=str_get_field(ncdcData(1:),10,delem)
   meanVisString=str_get_field(ncdcData(1:),16,delem)
   meanWindString=str_get_field(ncdcData(1:),18,delem)
   maxTString=str_get_field(ncdcData(1:),22,delem)
   minTString=str_get_field(ncdcData(1:),24,delem)
   meanMSLPString=str_get_field(ncdcData(1:),12,delem)
   print(meanTString)

;;;;;;;;;;;;;;; get vals
   daysStr=(str_split_by_length(dates,(/1,4,1,2,1,2,1/)))
;   print(daysStr)
 if(dimsizes(dimsizes(daysStr)).eq.2) then
   days=tointeger(daysStr(:,5))
   months=tointeger(daysStr(:,3))
;   print(months)
   viss=str_split_by_length(visString,(/1,1,6/))
   vis=tointeger(viss(:,1))

;;;;;;;;;;;;;; loop to get actual data
  do mn=1,2 ;;;; month loop
     if(mn.eq.2)then
        month=12
     else
        month=mn
     end if
	do da=1,31 ;;;;;day loop
         do i=0,dimsizes(vis)-1 ;;;; data loop
          if(days(i).eq.da .and. months(i).eq.month)then
            fData(mn-1,da-1)=vis(i)
            tlen=strlen(meanTString(i))
            meanTData(mn-1,da-1)=tofloat(str_get_cols(meanTString(i),1,tlen-1))
            tlen=strlen(meanDTString(i))
            meanDTData(mn-1,da-1)=tofloat(str_get_cols(meanDTString(i),1,tlen-1))
            tlen=strlen(meanVisString(i))
            meanVisData(mn-1,da-1)=tofloat(str_get_cols(meanVisString(i),1,tlen-1))
            tlen=strlen(meanWindString(i))
            meanWindData(mn-1,da-1)=tofloat(str_get_cols(meanWindString(i),1,tlen-1))
            tlen=strlen(maxTString(i))
            maxTData(mn-1,da-1)=tofloat(str_get_cols(maxTString(i),1,tlen-1))
            tlen=strlen(minTString(i))
            minTData(mn-1,da-1)=tofloat(str_get_cols(minTString(i),1,tlen-1))
            tlen=strlen(meanMSLPString(i))
            meanMSLPData(mn-1,da-1)=tofloat(str_get_cols(meanMSLPString(i),1,tlen-1))
            meanDDData(mn-1,da-1)=meanTData(mn-1,da-1)- meanDTData(mn-1,da-1)

          end if
         end do  ;;;;; data loop end
        end do ;;;; day loop end
   end do   ;;;;; month loop end  
 end if



  return([/fData,meanTData,meanDTData,meanVisData,meanWindData,maxTData,minTData,meanDDData,meanMSLPData/])
end


