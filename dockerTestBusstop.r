library(tidyverse)
library(osmdata)
library(sf)
load("/tmp/wmleuv/rdata/allstreets.Rdata") # allStreets
print(allStreets$osm_lines)
# bus bus.lanes bus.oneway bus_bay busway.left busway.right
busLocs <- allStreets$osm_polygons [which (allStreets$osm_polygons$highway== "platform"), ]
print(busLocs)
