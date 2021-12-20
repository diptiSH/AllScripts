#!/bin/sh

for entry in *.nc
do
  echo "$entry"


  cdo selmon,1,2,11,12 "$entry" NDJF_"$entry"

done


for entry in NDJF_*.nc
do
  echo "$entry"


  cdo sellonlatbox,0,360,0,90 "$entry" NH_"$entry"

done


for entry in NH_*.nc
do
  echo "$entry"

  outName=${entry:8}
  echo $outName
  cdo remapbil,/home/cccr/diptih/dipti/Data/eraDown/ERA5_2degree_Down/DailyMean/ERA5NH_t2m_daily_NovDecJan.nc "$entry" ../processed/Regrid_"$outName"

done


