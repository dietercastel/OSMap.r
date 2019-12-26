#!/bin/bash
# Requires image magick convert to be installed
convert -loop 1 -delay 100 map2005.png map2013.png map.png out.gif
