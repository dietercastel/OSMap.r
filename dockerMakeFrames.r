library(tidyverse)
library(osmdata)
library(sf)
library(purrr)
library(ggimage)
load("/tmp/wmleuv/streets.Rdata") # streets
load("/tmp/wmleuv/smallstreets.Rdata") # smallStreets
load("/tmp/wmleuv/pedStreets.Rdata") # pedStreets
load("/tmp/wmleuv/dijle.Rdata")
load("/tmp/wmleuv/anprNotWorkingOSM.Rdata") # anprNotWorkingOSM
load("/tmp/wmleuv/sfAStreets.Rdata")
load("/tmp/wmleuv/aStreetIds.Rdata") # aStreetIds
load("/tmp/wmleuv/anprNotWorking.Rdata") # anprNotWorking
load("/tmp/wmleuv/sunders.Rdata") # anprNotWorking



getXs <- function(OSMobj){
	#print(OSMobj)
	result <- OSMobj$coords[["x"]]
	print(result)
}
getYs <- function(OSMobj){
	result <- OSMobj$coords[["y"]]
}

NWAlong = map(anprNotWorkingOSM, getXs)
NWAlat = map(anprNotWorkingOSM, getYs)

notWorkingANPR <- data.frame(longitude = unlist(NWAlong), latitude = unlist(NWAlat))
sfNotWorkingANPR <- st_as_sf(notWorkingANPR, coords = c("longitude", "latitude"), crs = 4326, agr = "constant")

xoffset = c(0.04, -0.04)
yoffset = c(0.04, -0.05)

load("/tmp/wmleuv/leuvCoord.Rdata")
leuvCoord <-getbb("Leuven Belgium")
xbounds = leuvCoord[1,1:2] + xoffset
ybounds = leuvCoord[2,1:2] + yoffset

workingANPR <- data.frame(longitude = c(4.71487,4.722256,4.725876), latitude = c(50.88055,50.868489,50.868851))
shapesworkingANPR <- c(24,24,25)
sfworkingANPR <- st_as_sf(workingANPR, coords = c("longitude", "latitude"), crs = 4326, agr = "constant")

print(xbounds)
print(ybounds)

source(file="/tmp/wmleuv/apacheColors.r")
print(apacheColors["error"])
streetSize <- .5
streetColor <- apacheColors["textGrey"]
hlStreetSize <- 1
hlColor <- apacheColors["error"]
riverColor <- apacheColors["brandDarkest"]
riverSize <- .5
year <- "TEST"
basePlot <-	ggplot() +
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
			  alpha = .5)
	  # geom_sf(data = allHlStreets,
	  #         color = "error",
	  #         size = .4,
	  #         alpha = .8) +

ggsave("/tmp/wmleuv/baseplot.png", width=12, height=12)

load("/tmp/wmleuv/streets2005.Rdata") #  streets2005
load("/tmp/wmleuv/streets2013.Rdata") # streets2013
load("/tmp/wmleuv/streetsAllowed.Rdata") # streetsAllowed
streets2020 <- streetsAllowed

print(streetsAllowed)

years <- c("2005","2013","2020")

makeFrame <- function(year){
	streetsAllowed <- get(paste("streets",year, sep=""))
	print(year)
	print(streetsAllowed)
	hlStreets1 <- streets$osm_lines [which (streets$osm_lines$name %in% streetsAllowed), ]
	hlStreets2 <- smallStreets$osm_lines [which (smallStreets$osm_lines$name %in% streetsAllowed), ]
	hlStreets3 <- pedStreets$osm_lines [which (pedStreets$osm_lines$name %in% streetsAllowed), ]
	hlStreetsPoly <- pedStreets$osm_polygons [which (pedStreets$osm_polygons$name %in% streetsAllowed), ]

	print(hlStreetsPoly)

	yearPlot <- basePlot +
	  geom_sf(data = hlStreets1,
			  color = hlColor,
			  size = hlStreetSize,
			  alpha = .8) +
	  geom_sf(data = hlStreets2,
			  inherit.aes = FALSE,
			  color = hlColor,
			  size = hlStreetSize,
			  alpha = .6)+
	  geom_sf(data = hlStreets3,
			  inherit.aes = FALSE,
			  color = hlColor,
			  size = hlStreetSize,
			  alpha = .6)+
	  geom_sf(data = hlStreetsPoly,
			  inherit.aes = FALSE,
			  fill = hlColor,
			  size = 0,
			  alpha = 1)+
	  #ggtitle(paste("Stratenplan Leuven met straten waar gefilmd mag worden(", year, ")"))+
	  coord_sf(xlim = xbounds, 
			   ylim = ybounds,
			   expand = FALSE)+
	  theme_void()+
	  theme(
		plot.background = element_rect(fill = apacheColors["brandLight"])
	  )

	ggsave(paste("/tmp/wmleuv/map",year,".png",sep=""), plot=yearPlot, width = 12, height = 12)
}

#makeFrame(years[1])
makeFrame(years[2])
#makeFrame(years[3])
