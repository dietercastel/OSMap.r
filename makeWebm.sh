#!/bin/bash
# Requires image magick convert to be installed
convert -format WEBP -loop 0 -delay 200 logo_trimmed_map2005.png logo_trimmed_map2013.png logo_trimmed_map2020.png logo_trimmed_map2020bis.png hlStreets.webm
echo "Written in file hlStreets.webm"
convert -format WEBP -loop 0 -delay 200 logo_trimmed_map2005small.png logo_trimmed_map2013small.png logo_trimmed_map2020small.png hlStreetsSmall.webm
echo "Written in file hlStreetsSmall.webm"
