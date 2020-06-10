library(tidyverse)
library(osmdata)
library(sf)
#library(purrr) # problems with map function?
#library(ggimage) solve with PIL
load("/tmp/wmleuv/streets.Rdata") # streets
load("/tmp/wmleuv/smallstreets.Rdata") # smallStreets
load("/tmp/wmleuv/pedStreets.Rdata") # pedStreets
load("/tmp/wmleuv/dijle.Rdata") # dijle
load("/tmp/wmleuv/sfAStreets.Rdata")

library(png)
mypng <- readPNG('/tmp/wmleuv/input/centrum.png')


getXs <- function(OSMobj){
	#print(OSMobj)
	result <- OSMobj$coords[["x"]]
	print(result)
}
getYs <- function(OSMobj){
	result <- OSMobj$coords[["y"]]
}



xoffset = c(0.04, -0.04)
yoffset = c(0.04, -0.053)
logo <- data.frame(x = c(4.7177),
				   y = c(50.8864),
				   image = c("/tmp/wmleuv/input/apacheLokaal1.png"))

print(logo)
load("/tmp/wmleuv/leuvCoord.Rdata")
leuvCoord <-getbb("Leuven Belgium")

#Latitude, longitude
#50.88197, 4.69498

xbounds = leuvCoord[1,1:2] + xoffset
ybounds = leuvCoord[2,1:2] + yoffset

newXbounds = c(4.697, 4.7068)
names(newXbounds) = c("min","max")
newYbounds = c(50.87667, 50.8825)
names(newYbounds) = c("min","max")
#print(xbounds)
print(newXbounds)
#print(ybounds)
print(newYbounds)
#upper left
#50.8825, 4.6967
#bottem right
#50.87667, 4.70608
#width = xbounds["max"]-xbounds["min"]
#print(width)
#height = ybounds["max"]-ybounds["min"]
#print(height)
#ratio = height/width
#print(ratio)

source(file="/tmp/wmleuv/apacheColors.r")
#print(apacheColors["error"])
streetSize <- .5
streetColor <- apacheColors["textGrey"]
hlStreetSize <- 8
hlColor <- apacheColors["error"]
riverColor <- apacheColors["brandDarkest"]
riverSize <- .7
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

load("/tmp/wmleuv/streets2005.Rdata") #  streets2005
load("/tmp/wmleuv/streets2013.Rdata") # streets2013
load("/tmp/wmleuv/streetsAllowed.Rdata") # streetsAllowed
streets2020 <- streetsAllowed

#print(streetsAllowed)

years <- c("2005","2013","2020")

makeFrame <- function(year,
		      bis="",
		      xbb=xbounds,
		      ybb=ybounds,
		      backgroundColor=apacheColors["brandLight"],
		      titleText=""){
	if(nchar(titleText)== 0){
		titleText <- "Leuven, de rode straten filmt de politie permanent."
	}
	titleText <- paste(titleText," (", year, ")",sep="")
	streetsAllowed <- get(paste("streets",year, sep=""))
	print(year)
	print(streetsAllowed)
	hlStreets1 <- streets$osm_lines [which (streets$osm_lines$name %in% streetsAllowed), ]
	hlStreets2 <- smallStreets$osm_lines [which (smallStreets$osm_lines$name %in% streetsAllowed), ]
	hlStreets3 <- pedStreets$osm_lines [which (pedStreets$osm_lines$name %in% streetsAllowed), ]
	hlStreetsPoly <- pedStreets$osm_polygons [which (pedStreets$osm_polygons$name %in% streetsAllowed), ]

	#print(hlStreetsPoly)

	yearPlot <- basePlot +
		#newXbounds = c(4.697, 4.7068)
		#newYbounds = c(50.87667, 50.8825)
	  annotation_raster(mypng, ymin=50.8825, ymax=50.87667, xmin=4.697, xmax=4.7068)+
	  geom_sf(data = hlStreets1,
			  color = alpha(hlColor,.7),
			  size = hlStreetSize,
			  alpha = .2) +
	  geom_sf(data = hlStreets2,
			  inherit.aes = FALSE,
			  color = alpha(hlColor,.7),
			  #color = hlColor,
			  size = hlStreetSize,
			  alpha = .6)+
	  geom_sf(data = hlStreets3,
			  inherit.aes = FALSE,
			  color = alpha(hlColor,.7),
			  #color = hlColor,
			  size = hlStreetSize,
			  alpha = .6)+
	  #geom_sf(data = hlStreetsPoly,
			  #inherit.aes = FALSE,
			  #fill = alpha(hlColor,.7),
			  #size = 0)+
	  #geom_image(data=logo,
				 #aes(x,y,image),
				#inherit.aes = FALSE,
				#size = 0.04) +
	  #ggtitle(titleText)+
	  coord_sf(xlim = xbb, 
			   ylim = ybb,
			   expand = FALSE)+
	  theme_void()+
	  theme(
		plot.background = element_rect(fill = backgroundColor),
		plot.title = element_text(size = 18, face = "bold"),
	  )

	ggsave(paste("/tmp/wmleuv/output/map",year,bis,".png",sep=""), plot=yearPlot, width = 12, height=10.5)
}

makeFrame(years[1],bis="small",xbb=newXbounds,ybb=newYbounds,backgroundColor="white")
makeFrame(years[2],bis="small",xbb=newXbounds,ybb=newYbounds,backgroundColor="white")
makeFrame(years[3],bis="small",xbb=newXbounds,ybb=newYbounds,backgroundColor="white")
#makeFrame(years[3],
	  #bis="bis",
	  #backgroundColor=rgb(red = 1, green = 0, blue = 0, alpha = 0.3),
	  #titleText = "Leuven, in het rode gebied zet de politie mobiele camera's in.")
