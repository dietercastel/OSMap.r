library(tidyverse)
library(sf)
library(osmdata)
library(tmap)
library(tmaptools)
library(purrr) # required for map
library(png)

# Process command line arguments
args = commandArgs(trailingOnly=TRUE)
print(args)
# getbb of osmdata get's the bounding box boundingBoxinates of a region.
boundingBox<-getbb(args[1]) # e.g "Gent, Belgium" 

updateCases <- function(){
	bookCases <- boundingBox%>%
	     opq()%>% # opq() creates an openquery API call for the bounding box
	     add_osm_feature(key = "amenity", value="public_bookcase")%>% 
				# supported features here: https://wiki.openstreetmap.org/wiki/Map_Features
	     osmdata_sf()
	print(bookCases)
	save(bookCases, file= "/tmp/wmleuv/rdata/bookcases.Rdata") # save to file to respect the ToS.
}

#please respect the overpass API policy https://operations.osmfoundation.org/policies/api/ 
# you can comment this line if you're rerunning an example.
updateCases() 

xbounds = boundingBox[1,1:2]
ybounds = boundingBox[2,1:2]

# function that returns an annotation_raster object with the 
# given image covering the bounding box coordinates
makeRaster <- function(filename, topLeftLatitude, topLeftLongitude, botRightLatitude, botRightLongitude, ...){
	path <- paste('/tmp/wmleuv/osmtiling/be/',filename, sep="")
	tile <- readPNG(path)
	# print(path)
	xmx = max(topLeftLongitude, botRightLongitude)
	xmn = min(topLeftLongitude, botRightLongitude)
	ymx = max(topLeftLatitude, botRightLatitude)
	ymn = min(topLeftLatitude, botRightLatitude)
	return(annotation_raster(tile, ymin=ymn, ymax=ymx, xmin=xmn, xmax=xmx))
}

filterLat <- function(tileFrame,ybounds){
	return(between(tileFrame$topLeftLat,ybounds[1],ybounds[2]) | between(tileFrame$botRightLat,ybounds[1],ybounds[2]))
}
filterLon <- function(tileFrame,xbounds){
	return(between(tileFrame$topLeftLon,xbounds[1],xbounds[2]) | between(tileFrame$botRightLon,xbounds[1],xbounds[2]))
}

plotCases <- function(xbounds,ybounds,filename){
	load("/tmp/wmleuv/rdata/bookCases.Rdata") # loads the bookCases variable
	tileFrame <- read.csv('/tmp/wmleuv/osmtiling/z14-be.csv')
	# filter only the required rows. 
	filtered <- dplyr::filter(tileFrame,filterLat(tileFrame,ybounds) & filterLon(tileFrame,xbounds))

	# print(tileFrame)
	# for each row of filtered generate a annotation_raster object.
	annotationRasters <- pmap(filtered,makeRaster)


	# Combine each annotation_raster object with reduce.
	Reduce(function(a,b){a+b}, annotationRasters, ggplot())+
	geom_sf(data = bookCases$osm_points,
			size = 3, 
			shape = 22,
			# different shapes at https://www.datanovia.com/en/wp-content/uploads/dn-tutorials/ggplot2/figures/030-ggplot-point-shapes-r-pch-list-showing-different-point-shapes-in-rstudio-1.png
			fill = "blue") +
	coord_sf(xlim = xbounds, 
		 ylim = ybounds,
		 expand = FALSE)+
	theme_void()+ # remove axis
	theme(
		plot.background = element_rect(fill = "white")
	)

	ggsave(filename, width = 12, height = 10.5)
	print(paste("Saved result in", filename))
	print("Look in the /output folder.")
}
plotCases(xbounds,ybounds,"/tmp/wmleuv/output/bookcases.png")
