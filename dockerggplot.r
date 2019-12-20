library(tidyverse)
library(osmdata)
library(sf)
library(purrr)
#library(tmap)
#library(tmaptools)
load("/tmp/wmleuv/streets.Rdata") # streets
load("/tmp/wmleuv/smallstreets.Rdata") # smallStreets
load("/tmp/wmleuv/dijle.Rdata")
load("/tmp/wmleuv/streetsAllowedOSM.Rdata")
load("/tmp/wmleuv/anprNotWorkingOSM.Rdata")
load("/tmp/wmleuv/sfAStreets.Rdata")
load("/tmp/wmleuv/aStreetIds.Rdata") # aStreetIds
#hhstr<-sf::st_read("/tmp/wmleuv/hhstr.osm", layer = 'points')
leuvCoord <-getbb("Leuven Belgium")
#			x		y
#min <- c(4.640295,50.824210) 
#max <- c(4.77053,50.94407) 
#leuvCoord = data.frame(min,max) 
#rownames(leuvCoord) <- c("x","y")
#print(leuvCoord)
#save(leuvCoord, file="/tmp/wmleuv/leuvCoord.Rdata")
load("/tmp/wmleuv/leuvCoord.Rdata")
print(streets)
print(smallStreets$osm_lines["osm_id"])
print(streets$osm_lines["osm_id"])

#gbn<-geocode_OSM("Bondgenotenlaan 34, Leuven, Belgium")
#print(gbn)

aStreetIds <- unlist(aStreetIds)

print(aStreetIds)


#print(streets)
#print(row.names(streets$osm_lines))
#hlStreets1 <- streets$osm_lines[aStreetIds, ]
hlStreets1 <- streets$osm_lines [which (streets$osm_lines$osm_id  %in% aStreetIds), ]
hlStreets2 <- smallStreets$osm_lines [which (streets$osm_lines$osm_id  %in% aStreetIds), ]

print(hlStreets1)
print(hlStreets2)

xoffset = c(-0.02, 0.03)
yoffset = c(0.01, 0.00)

xbounds = leuvCoord[1,1:2] + xoffset
ybounds = leuvCoord[2,1:2] + yoffset

print("test")

# Only three working ones:
# - Geldkoe-Martenlarenplein 50.88057, 4.71487
# - Hoegaardsestraat 50.868489, 4.722256
# - Oudebaan 50.868851, 4.725876
workingANPR <- data.frame(longitude = c(4.71487,4.722256,4.725876), latitude = c(50.88055,50.868489,50.868851))
shapesworkingANPR <- c(24,24,25)
sfworkingANPR <- st_as_sf(workingANPR, coords = c("longitude", "latitude"), crs = 4326, agr = "constant")
#print(sfworkingANPR)

print(xbounds)
print(ybounds)
#print(sfAStreets)

getLines <- function(osmdataObj){
	osmdataObj$osm_lines
}

sfALines <- sfAStreets%>%
	map(getLines)

toSFDF <- function(collist){
	result <- collist%>%
		map(st_sfc)%>%
		rbind()
}
#SFDFALines <- toSFDF(sfALines)
#print(SFDFALines)


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
  geom_sf(data = hlStreets1,
          color = "red",
          size = .4,
          alpha = .8) +
  geom_sf(data = hlStreets2,
		  inherit.aes = FALSE,
		  color = "red",
		  size = .4,
		  alpha = .6)+
  coord_sf(xlim = xbounds, 
           ylim = ybounds,
           expand = FALSE)+
  theme_void()+
  theme(
    plot.background = element_rect(fill = "#282828")
  )

ggsave("/tmp/wmleuv/map.png", width = 12, height = 12)
