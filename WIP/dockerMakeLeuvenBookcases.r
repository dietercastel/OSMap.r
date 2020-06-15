library(tidyverse)
library(sf)
library(osmdata)
library(tmap)
library(tmaptools)
library(purrr) # required for map
library(png)

# loads leuvCoord which is a saved getbb("Leuven, Belgium") call
load("/tmp/wmleuv/rdata/leuvCoord.Rdata") 

updateCases <- function(){
	bookCases <- leuvCoord%>%
	     opq()%>%
	     add_osm_feature(key = "amenity", value="public_bookcase")%>%
	     osmdata_sf()
	print(bookCases)
	save(bookCases, file= "/tmp/wmleuv/rdata/bookCases.Rdata")
}

#please respect the overpass API policy https://operations.osmfoundation.org/policies/api/ 
updateCases() 

#xoffset = c(0.04, -0.04)
#yoffset = c(0.04, -0.053)
xoffset = c(0.015,-0.04)
yoffset = c(0.03,-0.057)

xbounds = leuvCoord[1,1:2] + xoffset
ybounds = leuvCoord[2,1:2] + yoffset

makeRaster <- function(filename, topLeftLat, topLeftLong, botRightLat, botRightLong, ...){
	path <- paste('/tmp/wmleuv/osmtiling/be/',filename, sep="")
	tile <- readPNG(path)
	xmx = max(topLeftLong, botRightLong)
	xmn = min(topLeftLong, botRightLong)
	ymx = max(topLeftLat, botRightLat)
	ymn = min(topLeftLat, botRightLat)
	#list(topLeftLat, topLeftLong, botRightLat, botRightLong,path)
	#list(xmx,xmn,ymx,ymn,path)
	return(annotation_raster(tile, ymin=ymn, ymax=ymx, xmin=xmn, xmax=xmx))
}

filterLat <- function(tileFrame,ybounds){
	return(between(tileFrame$topLeftLat,ybounds[1],ybounds[2]) | between(tileFrame$botRightLat,ybounds[1],ybounds[2]))
}
filterLon <- function(tileFrame,xbounds){
	return(between(tileFrame$topLeftLon,xbounds[1],xbounds[2]) | between(tileFrame$botRightLon,xbounds[1],xbounds[2]))
}

plotCases <- function(xbounds,ybounds,filename){
	load("/tmp/wmleuv/rdata/bookCases.Rdata")
	tileFrame <- read.csv('/tmp/wmleuv/osmtiling/z14-be.csv')
	#tileFrame <- read.csv('/tmp/wmleuv/osmtiling/tilesLeuven.csv')
	filtered <- dplyr::filter(tileFrame,filterLat(tileFrame,ybounds) & filterLon(tileFrame,xbounds))

	# print(tileFrame)
	annotationRasters <- pmap(filtered,makeRaster)

	  Reduce(function(a,b){a+b}, annotationRasters, ggplot())+
	  geom_sf(data = bookCases$osm_points,
			  size = 3, 
			  shape = 22,
			  fill = "blue") +
	  #makeRaster("14-8407-5494.png",50.87531,4.724121,50.86144,4.746094)+
	  #annotation_raster(readPNG("/tmp/wmleuv/osmtiling/images/14-8407-5494.png"), ymin=50.86144, ymax=50.87531, xmin=4.724121, xmax=4.746094)+
	  #makeRaster("14-8407-5495.png",50.86144,4.724121,50.84757,4.746094)+
	  #annotation_raster(mypng, ymin=50.8728, ymax=50.88232, xmin=4.68898, xmax=4.7169)+
	  #annotation_raster(mypng, ymin=50.8728, ymax=50.88232, xmin=4.68898, xmax=4.7169)+
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
plotCases(xbounds,ybounds,"/tmp/wmleuv/output/mapBookcase.png")
