library(tidyverse)
library(osmdata)
library(sf)
library(purrr)
load("/tmp/wmleuv/rdata/streets.Rdata") # streets
load("/tmp/wmleuv/rdata/smallstreets.Rdata") # smallStreets
load("/tmp/wmleuv/rdata/allstreets.Rdata") # allStreets
## Loading this large object (150MB) results in killing the process in docker
## But not after increasing docker memory.
load("/tmp/wmleuv/rdata/dijle.Rdata")
#load("/tmp/wmleuv/rdata/anprNotWorking.Rdata") # anprNotWorking # List of ANPR adresses 
load("/tmp/wmleuv/rdata/anprNotWorkingOSM.Rdata") # anprNotWorkingOSM # OSM object list of coresponding coords.
#load("/tmp/wmleuv/rdata/sunders.Rdata") # sunders data with OSM carted camera's

# Alternative plotting of pedestrian zone
#load("/tmp/wmleuv/rdata/pedStreets.Rdata") # pedStreets
#load("/tmp/wmleuv/rdata/vgz1.Rdata")
#load("/tmp/wmleuv/rdata/vgz2.Rdata")
# pedZone <- voetgangerszone1
# pedZone <- voetgangerszone2
#pedZone <- c(vgz1,vgz2)

#hlStreets1 <- streets$osm_lines [which (streets$osm_lines$name %in% pedZone), ]
#hlStreets2 <- smallStreets$osm_lines [which (smallStreets$osm_lines$name %in% pedZone), ]
#hlStreets3 <- pedStreets$osm_lines [which (pedStreets$osm_lines$name %in% pedZone), ]
#hlStreetsPoly <- pedStreets$osm_polygons [which (pedStreets$osm_polygons$name %in% pedZone), ]

source(file="/tmp/wmleuv/apacheColors.r")
#print(apacheColors["error"])

library(png)
mypng <- readPNG('/tmp/wmleuv/input/voetgangerszone.png')

streetSize <- 1.6
streetColor <- apacheColors["textGrey"]
hlStreetSize <- 1
hlColor <- apacheColors["yellowLocalDark"]
riverColor <- apacheColors["brandDarkest"]
riverSize <- .8

#leuvCoord <-getbb("Leuven Belgium")
load("/tmp/wmleuv/rdata/leuvCoord.Rdata")



getXs <- function(OSMobj){
	#print(OSMobj$query)
	#result <- OSMobj$coords[["x"]]
	#print(result)
	OSMobj$coords[["x"]]
	#print(OSMobj$coords[["y"]])
}
getYs <- function(OSMobj){
	OSMobj$coords[["y"]]
}

# List of list stuff, figure it out
# https://swcarpentry.github.io/r-novice-inflammation/13-supp-data-structures/
NWAlong = map(anprNotWorkingOSM, getXs)
NWAlat = map(anprNotWorkingOSM, getYs)
#print(NWAlong)

#print(NWAlat)

notWorkingANPR <- data.frame(longitude = unlist(NWAlong), latitude = unlist(NWAlat))
sfNotWorkingANPR <- st_as_sf(notWorkingANPR, coords = c("longitude", "latitude"), crs = 4326, agr = "constant")

#print(sfNotWorkingANPR)

xoffset = c(0.04, -0.04)
yoffset = c(0.04, -0.053)

xbounds = leuvCoord[1,1:2] + xoffset
ybounds = leuvCoord[2,1:2] + yoffset

#left top
#50.88394, 4.71002
#right bottem
#50.866, 4.7366

# Other coords for smaller frame.
smallXbounds = c(4.71002, 4.7366)
names(smallXbounds) = c("min","max")
smallYbounds = c(50.866, 50.88394)
names(smallYbounds) = c("min","max")

# Only three working ones (WELLlll apperantly rather: working as in generating revenue :^)
# - Geldkoe-Martenlarenplein 50.88057, 4.71487
# - Hoegaardsestraat 50.868489, 4.722256
# - Oudebaan 50.868851, 4.725876
workingANPR <- data.frame(longitude = c(4.71487,4.722256,4.725876), latitude = c(50.88055,50.868489,50.868851))
shapesworkingANPR <- c(24,24,25)
sfworkingANPR <- st_as_sf(workingANPR, coords = c("longitude", "latitude"), crs = 4326, agr = "constant")

print(xbounds)
print(ybounds)

makeFile <- function(xbounds,ybounds,filename){
	ggplot() +
	#   geom_sf(data = allStreets$osm_lines,
	#           inherit.aes = FALSE,
	#           color = streetColor,
	#           size = streetSize)+
	  geom_sf(data = smallStreets$osm_lines,
			  inherit.aes = FALSE,
			  color = streetColor,
			  size = streetSize,
			  alpha = .6)+
		# TODO: automate this overlaying, now it's manual tweaking and screenshotting.
	  annotation_raster(mypng, ymin=50.8728, ymax=50.88232, xmin=4.68898, xmax=4.7169)+
	  geom_sf(data = dijle$osm_lines,
		  inherit.aes = FALSE,
		  color = riverColor,
		  size = riverSize) +
	  geom_sf(data = streets$osm_lines,
		  inherit.aes = FALSE,
		  color = apacheColors["textGrey"],
		  size = streetSize) +
	  geom_sf(data = sfNotWorkingANPR,
			  size = 5, 
			  shape = 24,
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
	    #plot.background = element_rect(fill = apacheColors["brandLight"])
	    plot.background = element_rect(fill = "white")
	  )

	ggsave(filename, width = 12, height = 10.5)
}
makeFile(xbounds,ybounds,"/tmp/wmleuv/output/mapANPR2020.png")
makeFile(smallXbounds,smallYbounds,"/tmp/wmleuv/output/mapANPR2020small.png")
