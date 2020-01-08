library(tidyverse)
library(osmdata)
library(sf)
library(purrr)
# install.packages("ggimage") # required in that docker container
library(ggimage)
#library(tmap)
#library(tmaptools)
load("/tmp/wmleuv/streets.Rdata") # streets
load("/tmp/wmleuv/smallstreets.Rdata") # smallStreets
#load("/tmp/wmleuv/allstreets.Rdata") # smallStreets
# Loading this large object (150MB) results in killing the process in docker
load("/tmp/wmleuv/pedStreets.Rdata") # pedStreets
load("/tmp/wmleuv/dijle.Rdata")
#load("/tmp/wmleuv/streetsAllowedOSM.Rdata")
load("/tmp/wmleuv/anprNotWorkingOSM.Rdata") # anprNotWorkingOSM
load("/tmp/wmleuv/sfAStreets.Rdata")
load("/tmp/wmleuv/aStreetIds.Rdata") # aStreetIds
load("/tmp/wmleuv/anprNotWorking.Rdata") # anprNotWorking
load("/tmp/wmleuv/sunders.Rdata") # 

load("/tmp/wmleuv/vgz1.Rdata")
load("/tmp/wmleuv/vgz2.Rdata")

source(file="/tmp/wmleuv/apacheColors.r")
print(apacheColors["error"])

library(png)
mypng <- readPNG('/tmp/wmleuv/voetgangerszone.png')

streetSize <- .5
streetColor <- apacheColors["textGrey"]
hlStreetSize <- 1
hlColor <- apacheColors["yellowLocalDark"]
riverColor <- apacheColors["brandDarkest"]
riverSize <- .5

# sunders <- getbb("Leuven Belgium")%>%
#      opq()%>%
#      add_osm_feature(key = "man_made", value="surveillance")%>%
#      osmdata_sf()
# save(sunders, file= "/Users/dietercastel/git/wmleuv/sunders.Rdata")


#leuvCoord <-getbb("Leuven Belgium")
load("/tmp/wmleuv/leuvCoord.Rdata")


# pedZone <- voetgangerszone1
# pedZone <- voetgangerszone2
pedZone <- c(vgz1,vgz2)

hlStreets1 <- streets$osm_lines [which (streets$osm_lines$name %in% pedZone), ]
hlStreets2 <- smallStreets$osm_lines [which (smallStreets$osm_lines$name %in% pedZone), ]
hlStreets3 <- pedStreets$osm_lines [which (pedStreets$osm_lines$name %in% pedZone), ]
hlStreetsPoly <- pedStreets$osm_polygons [which (pedStreets$osm_polygons$name %in% pedZone), ]

getXs <- function(OSMobj){
	#print(OSMobj$query)
	result <- OSMobj$coords[["x"]]
	print(result)
	#print(OSMobj$coords[["y"]])
}
getYs <- function(OSMobj){
	result <- OSMobj$coords[["y"]]
}

# List of list stuff, figure it out
# https://swcarpentry.github.io/r-novice-inflammation/13-supp-data-structures/
NWAlong = map(anprNotWorkingOSM, getXs)
NWAlat = map(anprNotWorkingOSM, getYs)
#print(NWAlong)

#print(NWAlat)

notWorkingANPR <- data.frame(longitude = unlist(NWAlong), latitude = unlist(NWAlat))
sfNotWorkingANPR <- st_as_sf(notWorkingANPR, coords = c("longitude", "latitude"), crs = 4326, agr = "constant")

#print(sunders$osm_points)
#print(sfNotWorkingANPR)

xoffset = c(0.04, -0.04)
yoffset = c(0.04, -0.053)

xbounds = leuvCoord[1,1:2] + xoffset
ybounds = leuvCoord[2,1:2] + yoffset

#left top
#50.88394, 4.71002
#50.866, 4.7366


newXbounds = c(4.71002, 4.7366)
names(newXbounds) = c("min","max")
newYbounds = c(50.866, 50.88394)
names(newYbounds) = c("min","max")

#xbounds <- newXbounds
#ybounds <- newYbounds

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

print(streets$osm_polygons)
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
          color = apacheColors["textGrey"],
          size = streetSize,
          alpha = .8) +
  geom_sf(data = smallStreets$osm_lines,
		  inherit.aes = FALSE,
		  color = streetColor,
		  size = streetSize,
		  alpha = .6)+
  geom_sf(data = pedStreets$osm_lines,
		  inherit.aes = FALSE,
		  color = streetColor,
		  size = streetSize,
		  alpha = .6)+
  geom_sf(data = dijle$osm_lines,
          inherit.aes = FALSE,
          color = riverColor,
          size = riverSize,
          alpha = .5) +
  # geom_sf(data = hhstr$osm_lines,
  #         inherit.aes = FALSE,
  #         color = "error",
  #         size = .2,
  #         alpha = .5) +
  # geom_sf(data = allHlStreets,
  #         color = "error",
  #         size = .4,
  #         alpha = .8) +
#  geom_sf(data = hlStreets1,
#          color = hlColor,
#          size = hlStreetSize,
#          alpha = .8) +
#  geom_sf(data = hlStreets2,
#		  inherit.aes = FALSE,
#		  color = hlColor,
#		  size = hlStreetSize,
#		  alpha = .6)+
#  geom_sf(data = hlStreets3,
#		  inherit.aes = FALSE,
#		  color = hlColor,
#		  size = hlStreetSize,
#		  alpha = .6)+
#  geom_sf(data = hlStreetsPoly,
#		  inherit.aes = FALSE,
#		  fill = hlColor,
#		  size = 0,
#		  alpha = 1)+
#annotation_raster(mypng, ymin = 4.5,ymax= 5,xmin = 30,xmax = 35)
  annotation_raster(mypng, ymin=50.87316, ymax=50.88257, xmin=4.69101, xmax=4.71391)+
  geom_sf(data = sfNotWorkingANPR,
		  size = 5, 
		  shape = 24,
		  #size = 3, 
		  #shape = 21,
		  #fill = apacheColors["success"]) +
		  fill = apacheColors["error"]) +
  geom_sf(data = sfworkingANPR,
		  size = 5, 
		  shape = shapesworkingANPR,
		  fill = apacheColors["error"]) +
  coord_sf(xlim = xbounds, 
           ylim = ybounds,
           expand = FALSE)+
  theme_void()+
  theme(
    plot.background = element_rect(fill = apacheColors["brandLight"])
  )

print(sfNotWorkingANPR)
print(sfworkingANPR)
ggsave("/tmp/wmleuv/mapANPR2020.png", width = 12, height = 10.5)
#ggsave("/tmp/wmleuv/mapANPR2020small.png", width = 12, height = 10.5)
