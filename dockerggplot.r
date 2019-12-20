library(tidyverse)
library(osmdata)
library(sf)
library(purrr)
#library(tmap)
#library(tmaptools)
load("/tmp/wmleuv/streets.Rdata")
load("/tmp/wmleuv/smallstreets.Rdata")
load("/tmp/wmleuv/dijle.Rdata")
load("/tmp/wmleuv/streetsAllowedOSM.Rdata")
load("/tmp/wmleuv/anprNotWorkingOSM.Rdata")
load("/tmp/wmleuv/sfAStreets.Rdata")
#hhstr<-sf::st_read("/tmp/wmleuv/hhstr.osm", layer = 'points')
leuvCoord <-getbb("Leuven Belgium")
print(leuvCoord)
#print(streets)

#gbn<-geocode_OSM("Bondgenotenlaan 34, Leuven, Belgium")
#print(gbn)

xoffset = c(-0.02, 0.03)
yoffset = c(0.01, 0.00)

xbounds = leuvCoord[1,1:2] + xoffset
ybounds = leuvCoord[2,1:2] + yoffset

# Only three working ones:
# - Geldkoe-Martenlarenplein 50.88057, 4.71487
# - Hoegaardsestraat 50.868489, 4.722256
# - Oudebaan 50.868851, 4.725876
workingANPR <- data.frame(longitude = c(4.71487,4.722256,4.725876), latitude = c(50.88055,50.868489,50.868851))
shapesworkingANPR <- c(24,24,25)
sfworkingANPR <- st_as_sf(workingANPR, coords = c("longitude", "latitude"), crs = 4326, agr = "constant")
print(sfworkingANPR)

print(xbounds)
print(ybounds)
print(sfAStreets)

getLines <- function(osmdataObj){
	osmdataObj$osm_lines
}

sfALines <- sfAStreets%>%
	map(getLines)

#sfAlinesDf <- data.frame(matrix(unlist(sfALines), nrow=length(sfALines), byrow=T))

#print(sfALines)

ggplot() +
  geom_sf(data = streets$osm_lines,
          inherit.aes = FALSE,
          color = "white",
          size = .4,
          alpha = .8) +
  geom_sf(data = smallStreets$osm_lines,
		  inherit.aes = FALSE,
		  color = "white",
		  size = .4,
		  alpha = .6)+
  geom_sf(data = dijle$osm_lines,
          inherit.aes = FALSE,
          color = "steelblue",
          size = .2,
          alpha = .5) +
  # geom_sf(data = hhstr$osm_lines,
  #         inherit.aes = FALSE,
  #         color = "red",
  #         size = .2,
  #         alpha = .5) +
  geom_sf(data = sfworkingANPR,
		  size = 4, 
		  shape = shapesworkingANPR,
		  fill = "darkred") +
  #geom_sf(data = sfAlinesDf,
#		  size = 4, 
#		  shape = shapesworkingANPR,
#		  fill = "red") +
  coord_sf(xlim = xbounds, 
           ylim = ybounds,
           expand = FALSE)+
  theme_void()+
  theme(
    plot.background = element_rect(fill = "#282828")
  )

ggsave("/tmp/wmleuv/map.png", width = 12, height = 12)
