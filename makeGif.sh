#!/bin/bash
# Requires image magick convert to be installed
convert -loop 0 -delay 200 logo_map2005.png logo_map2013.png logo_map2020.png logo_map2020bis.png hlStreets.gif
echo "Written in file hlStreets.gif"
