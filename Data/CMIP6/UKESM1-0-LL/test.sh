#!/bin/sh

for entry in *.nc
do
  echo "$entry"
   
#  echo "$entry" | cut -f 2 -d "/"
  cdo selyear,1975/2014 "$entry" ../"$entry" 
done
