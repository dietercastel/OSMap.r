library(tidyverse)
library(sf)
library(osmdata)
library(tmap)
library(tmaptools)
library(purrr) # required for map
library(png)

load("/tmp/wmleuv/leuvCoord.Rdata") # loads leuvCoord

updateCases <- function(){
	bookCases <- leuvCoord%>%
	     opq()%>%
	     add_osm_feature(key = "amenity", value="public_bookcase")%>%
	     osmdata_sf()
	print(bookCases)
	save(bookCases, file= "/tmp/wmleuv/bookCases.Rdata")
}

#updateCases() please respect the overpass API policy https://operations.osmfoundation.org/policies/api/ 

xoffset = c(0.04, -0.04)
yoffset = c(0.04, -0.053)

xbounds = leuvCoord[1,1:2] + xoffset
ybounds = leuvCoord[2,1:2] + yoffset

mypng <- readPNG('/tmp/wmleuv/voetgangerszone.png')

plotCases <- function(xbounds,ybounds,filename){
	load("/tmp/wmleuv/bookCases.Rdata")
	ggplot() +
	  annotation_raster(mypng, ymin=50.8728, ymax=50.88232, xmin=4.68898, xmax=4.7169)+
	  geom_sf(data = bookCases$osm_points,
			  size = 5, 
			  shape = 12,
			  fill = "blue") +
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
