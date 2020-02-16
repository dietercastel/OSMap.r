#TODO: Complete this.
# Fetching the tiles for the overlay automatically.
library(tidyverse)
library(osmdata)
library(sf)
library(purrr)
#library(ggspatial)
# TODO: get docker container with installed deps.
library(OpenStreetMap) # Requires Java
library(ggplot2)

load("/tmp/wmleuv/leuvCoord.Rdata")


topLeft = c(leuvCoord[2,1],leuvCoord[1,1])
bottomRight = topLeft = c(leuvCoord[2,2],leuvCoord[1,2])
print(topLeft)
print(bottomRight)

map <- openmap(topLeft,bottomRight,type="https://tile.openstreetmap.be/osmbe/{z}/{x}/{y}.png")
autoplot(map)
ggsave("/tmp/wmleuv/output/leuvenOSMbe.png", width = 12, height = 10.5)
