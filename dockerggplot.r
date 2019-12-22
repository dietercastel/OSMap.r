library(tidyverse)
library(osmdata)
library(sf)
library(purrr)
#library(tmap)
#library(tmaptools)
load("/tmp/wmleuv/streets.Rdata") # streets
load("/tmp/wmleuv/smallstreets.Rdata") # smallStreets
#load("/tmp/wmleuv/allstreets.Rdata") # smallStreets
# Loading this large object (150MB) results in killing the process in docker
load("/tmp/wmleuv/pedStreets.Rdata") # pedStreets
load("/tmp/wmleuv/dijle.Rdata")
load("/tmp/wmleuv/streetsAllowedOSM.Rdata")
load("/tmp/wmleuv/anprNotWorkingOSM.Rdata") # anprNotWorkingOSM
load("/tmp/wmleuv/sfAStreets.Rdata")
load("/tmp/wmleuv/aStreetIds.Rdata") # aStreetIds
load("/tmp/wmleuv/streetsAllowed.Rdata") # streetsAllowed
load("/tmp/wmleuv/anprNotWorking.Rdata") # anprNotWorking


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
#print(streets)
#print(smallStreets$osm_lines["osm_id"])
#print(streets$osm_lines["osm_id"])

#gbn<-geocode_OSM("Bondgenotenlaan 34, Leuven, Belgium")
#print(gbn)


aStreetIds <- unlist(aStreetIds)

# print(streetsAllowedOSM)
# print(length(streetsAllowedOSM))
# print(aStreetIds)
# print(length(aStreetIds))


#print(streets)
#print(row.names(streets$osm_lines))
#hlStreets1 <- streets$osm_lines[aStreetIds, ]
#hlStreets1 <- streets$osm_lines [which (streets$osm_lines$osm_id %in% aStreetIds), ]
#hlStreets2 <- smallStreets$osm_lines [which (smallStreets$osm_lines$osm_id %in% aStreetIds), ]

hlStreets1 <- streets$osm_lines [which (streets$osm_lines$name %in% streetsAllowed), ]
hlStreets2 <- smallStreets$osm_lines [which (smallStreets$osm_lines$name %in% streetsAllowed), ]
hlStreets3 <- pedStreets$osm_lines [which (pedStreets$osm_lines$name %in% streetsAllowed), ]

#allHlStreets <- allStreets$osm_lines [which (allStreets$osm_lines$name %in% streetsAllowed), ]

#anprNotWorkingOSM <- unlist(anprNotWorkingOSM, recursive=FALSE)
print(length(anprNotWorkingOSM))

getXs <- function(OSMobj){
	#print(OSMobj)
	result <- OSMobj$coords[["x"]]
	print(result)
}
getYs <- function(OSMobj){
	result <- OSMobj$coords[["y"]]
}

# List of list stuff, figure it out
# https://swcarpentry.github.io/r-novice-inflammation/13-supp-data-structures/
NWAlong = map(anprNotWorkingOSM, getXs)
NWAlat = map(anprNotWorkingOSM, getYs)
print(NWAlong)

print(NWAlat)

notWorkingANPR <- data.frame(longitude = unlist(NWAlong), latitude = unlist(NWAlat))
sfNotWorkingANPR <- st_as_sf(notWorkingANPR, coords = c("longitude", "latitude"), crs = 4326, agr = "constant")

xoffset = c(0.04, -0.04)
yoffset = c(0.04, -0.05)

xbounds = leuvCoord[1,1:2] + xoffset
ybounds = leuvCoord[2,1:2] + yoffset

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

#print(hlStreets1)
#print(hlStreets2[,1:2]$name)

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
  # geom_sf(data = allStreets$osm_lines,
  #         inherit.aes = FALSE,
  #         color = "white",
  #         size = .4,
  #         alpha = .8) +
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
  geom_sf(data = pedStreets$osm_lines,
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
  # geom_sf(data = allHlStreets,
  #         color = "red",
  #         size = .4,
  #         alpha = .8) +
  geom_sf(data = hlStreets1,
          color = "red",
          size = .4,
          alpha = .8) +
  geom_sf(data = hlStreets2,
		  inherit.aes = FALSE,
		  color = "red",
		  size = .4,
		  alpha = .6)+
  geom_sf(data = hlStreets3,
		  inherit.aes = FALSE,
		  color = "red",
		  size = .4,
		  alpha = .6)+
  geom_sf(data = sfNotWorkingANPR,
		  size = 3, 
		  shape = 21,
		  fill = "darkgreen") +
  geom_sf(data = sfworkingANPR,
		  size = 5, 
		  shape = shapesworkingANPR,
		  fill = "darkred") +
  coord_sf(xlim = xbounds, 
           ylim = ybounds,
           expand = FALSE)+
  theme_void()+
  theme(
    plot.background = element_rect(fill = "#282828")
  )

ggsave("/tmp/wmleuv/map.png", width = 12, height = 12)
