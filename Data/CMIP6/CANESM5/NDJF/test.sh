#!/bin/sh



for entry in *.nc
do
  echo "$entry"
   

#   $var 'Regrid'${entry}


#   echo "${b} ${entry}" 

#cdo sellonlatbox,0,360,0,90 "$entry" 'NH'${entry}

# cdo remapbil,/home/cccr/diptih/dipti/Data/eraDown/ERA5_2degree_Down/DailyMean/ERA5NH_t2m_daily_NovDecJan.nc  "$entry"  'Regrid'${entry}
  cdo -selyear,1975/2014  "$entry" ../"$entry" 
done
