#!/bin/sh

for entry in NH*.nc
do
  echo "$entry"

#  echo "$entry" | cut -f 2 -d "/"
#  cdo selyear,1975/2014 "$entry" ../"$entry"
#   cdo sellonlatbox,0,360,0,90  "$entry" NH_"$entry"

   cdo remapbil,/home/cccr/diptih/dipti/Data/eraDown/ERA5_2degree_Down/DailyMean/ERA5NH_t2m_daily_NovDecJan.nc  "$entry" Regrid_"$entry"

done

