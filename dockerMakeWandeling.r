library(tidyverse)
library(osmdata)
library(sf)
library(png)

print(st_layers("/tmp/wmleuv/wandelingLeuven.gpx"))
gpxLinestring <- st_read("/tmp/wmleuv/wandelingLeuven.gpx",layer="routes")
mypng <- readPNG('/tmp/wmleuv/input/wandelingOSM.png')

print(gpxLinestring)

load("/tmp/wmleuv/streets.Rdata") # streets
load("/tmp/wmleuv/smallstreets.Rdata") # smallStreets
load("/tmp/wmleuv/allstreets.Rdata") # allStreets
load("/tmp/wmleuv/pedStreets.Rdata") # pedStreets
load("/tmp/wmleuv/dijle.Rdata") # dijle
load("/tmp/wmleuv/sfAStreets.Rdata")

load("/tmp/wmleuv/anprNotWorkingOSM.Rdata") # anprNotWorkingOSM


getXs <- function(OSMobj){
	#print(OSMobj)
	result <- OSMobj$coords[["x"]]
	#print(result)
}
getYs <- function(OSMobj){
	result <- OSMobj$coords[["y"]]
}

#Last ANPR loc for legend: 50.8874, 4.69739
workingANPR <- data.frame(longitude = c(4.71487,4.722256,4.725876,4.69735), latitude = c(50.88055,50.868489,50.868851,50.8874))
shapesworkingANPR <- c(24,24,25,24)
sfworkingANPR <- st_as_sf(workingANPR, coords = c("longitude", "latitude"), crs = 4326, agr = "constant")
# List of list stuff, figure it out
# https://swcarpentry.github.io/r-novice-inflammation/13-supp-data-structures/
NWAlong = map(anprNotWorkingOSM, getXs)
NWAlat = map(anprNotWorkingOSM, getYs)

notWorkingANPR <- data.frame(longitude = unlist(NWAlong), latitude = unlist(NWAlat))
sfNotWorkingANPR <- st_as_sf(notWorkingANPR, coords = c("longitude", "latitude"), crs = 4326, agr = "constant")

load("/tmp/wmleuv/leuvCoord.Rdata")

# Screencapped from OSM & found coords manually
# TL 50.88763, 4.69553
# BR 50.8773, 4.7166
xbounds = c(4.69553, 4.7166)
names(xbounds) = c("min","max")
ybounds = c(50.8773, 50.88763)
names(ybounds) = c("min","max")

print(xbounds)
print(ybounds)

source(file="/tmp/wmleuv/apacheColors.r")
streetSize <- .5
streetColor <- apacheColors["textGrey"]
hlStreetSize <- 3.7
hlColor <- apacheColors["error"]
routeColor <- apacheColors["brandDarkest"]
routeSize <- 3
riverColor <- apacheColors["brandDarkest"]
riverSize <- .7
basePlot <-	ggplot()

load("/tmp/wmleuv/streetsAllowed.Rdata") # streetsAllowed
streets2020 <- streetsAllowed


years <- c("2005","2013","2020")

makeFrame <- function(year,bis="",backgroundColor=apacheColors["brandLight"],titleText=""){
	if(nchar(titleText)== 0){
		titleText <- "Leuven, de rode straten filmt de politie permanent."
	}
	titleText <- paste(titleText," (", year, ")",sep="")
	streetsAllowed <- get(paste("streets",year, sep=""))
	print(year)
	hlStreets1 <- streets$osm_lines [which (streets$osm_lines$name %in% streetsAllowed), ]
	hlStreets2 <- smallStreets$osm_lines [which (smallStreets$osm_lines$name %in% streetsAllowed), ]
	hlStreets3 <- pedStreets$osm_lines [which (pedStreets$osm_lines$name %in% streetsAllowed), ]
	hlStreetsPoly <- pedStreets$osm_polygons [which (pedStreets$osm_polygons$name %in% streetsAllowed), ]

	yearPlot <- basePlot+
# TL 50.88763, 4.69553
# BR 50.8773, 4.7166
	  annotation_raster(mypng, ymin=50.8773, ymax=50.88763, xmin=4.69553, xmax=4.7166)+
	  geom_sf(data = hlStreets1,
			  color = alpha(hlColor,0.6),
			  size = hlStreetSize) +
	  geom_sf(data = hlStreets2,
			  inherit.aes = FALSE,
			  color = alpha(hlColor,0.6),
			  size = hlStreetSize)+
	  geom_sf(data = hlStreets3,
			  inherit.aes = FALSE,
			  color = alpha(hlColor,0.6),
			  size = hlStreetSize)+
	  geom_sf(data = hlStreetsPoly,
			  inherit.aes = FALSE,
			  fill = alpha(hlColor,0.3),
			  size = 0)

	if(year == "2020") {
		busLocs <- allStreets$osm_polygons [which (allStreets$osm_polygons$highway== "platform"), ]
		yearPlot <- yearPlot +	  
			   geom_sf(data = busLocs,
					   inherit.aes = FALSE,
					   fill = alpha(hlColor,0.8),
					   size = 0,
					   alpha = 1) +
			   geom_sf(data = gpxLinestring,
					   inherit.aes = FALSE,
					   color = alpha(routeColor,0.8),
					   size = routeSize,
					   alpha = 0.8)+
			  geom_sf(data = sfNotWorkingANPR,
					  size = 8, 
					  shape = 24,
					  fill = apacheColors["error"]) +
			  geom_sf(data = sfworkingANPR,
					  size = 8, 
					  shape = shapesworkingANPR,
					  fill = apacheColors["error"])
	} 
	finPlot <- yearPlot +
	  coord_sf(xlim = xbounds, 
			   ylim = ybounds,
			   expand = FALSE)+
	  theme_void()+
	  theme(
		plot.background = element_rect(fill = backgroundColor),
		plot.title = element_text(size = 18, face = "bold"),
	  ) 

	ggsave(paste("/tmp/wmleuv/output/wandeling",year,bis,".png",sep=""), plot=finPlot, width = 12, height=10.22)
}

makeFrame(years[3], backgroundColor="white")
