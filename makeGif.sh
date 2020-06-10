#!/bin/bash
# Requires image magick convert to be installed
convert -loop 0 -delay 200 logo_trimmed_map2005.png logo_trimmed_map2013.png logo_trimmed_map2020.png logo_trimmed_map2020bis.png output/hlStreets.gif
echo "Written in file output/hlStreets.gif"
convert -loop 0 -delay 200 logo_trimmed_map2005small.png logo_trimmed_map2013small.png logo_trimmed_map2020small.png hlStreetsSmall.gif
echo "Written in file output/hlStreetsSmall.gif"