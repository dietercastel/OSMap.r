library(tidyverse)
library(sf)
library(osmdata)
library(tmap)
library(tmaptools)
library(purrr) # required for map
library(png)

# loads mechelenCoord which is a saved getbb("Mechelen, Belgium") call
# load("/tmp/wmleuv/rdata/mechelenCoord.Rdata") 

mechelenCoord<-getbb("Mechelen, Belgium")

updateCases <- function(){
	bookCases <- mechelenCoord%>%
	     opq()%>%
	     add_osm_feature(key = "amenity", value="public_bookcase")%>%
	     osmdata_sf()
	print(bookCases)
	save(bookCases, file= "/tmp/wmleuv/rdata/mechelenBookCases.Rdata")
}

#please respect the overpass API policy https://operations.osmfoundation.org/policies/api/ 
updateCases() 

xbounds = mechelenCoord[1,1:2]
ybounds = mechelenCoord[2,1:2]

makeRaster <- function(filename, topLeftLat, topLeftLong, botRightLat, botRightLong, ...){
	path <- paste('/tmp/wmleuv/osmtiling/be/',filename, sep="")
	tile <- readPNG(path)
	# print(path)
	xmx = max(topLeftLong, botRightLong)
	xmn = min(topLeftLong, botRightLong)
	ymx = max(topLeftLat, botRightLat)
	ymn = min(topLeftLat, botRightLat)
	return(annotation_raster(tile, ymin=ymn, ymax=ymx, xmin=xmn, xmax=xmx))
}

filterLat <- function(tileFrame,ybounds){
	return(between(tileFrame$topLeftLat,ybounds[1],ybounds[2]) | between(tileFrame$botRightLat,ybounds[1],ybounds[2]))
}
filterLon <- function(tileFrame,xbounds){
	return(between(tileFrame$topLeftLon,xbounds[1],xbounds[2]) | between(tileFrame$botRightLon,xbounds[1],xbounds[2]))
}

plotCases <- function(xbounds,ybounds,filename){
	load("/tmp/wmleuv/rdata/mechelenBookCases.Rdata")
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
	  coord_sf(xlim = xbounds, 
		   ylim = ybounds,
		   expand = FALSE)+
	  theme_void()+
	  theme(
	    plot.background = element_rect(fill = "white")
	  )

	ggsave(filename, width = 12, height = 10.5)
}
plotCases(xbounds,ybounds,"/tmp/wmleuv/output/mechelenBookcases.png")
