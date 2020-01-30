library(tidyverse)
library(osmdata)
library(sf)
#library(purrr) # problems with map function?
#library(ggimage) solve with PIL
load("/tmp/wmleuv/streets.Rdata") # streets
load("/tmp/wmleuv/smallstreets.Rdata") # smallStreets
load("/tmp/wmleuv/allstreets.Rdata") # allStreets
load("/tmp/wmleuv/pedStreets.Rdata") # pedStreets
load("/tmp/wmleuv/dijle.Rdata") # dijle
load("/tmp/wmleuv/sfAStreets.Rdata")



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
				   image = c("/tmp/wmleuv/apacheLokaal1.png"))

print(logo)
load("/tmp/wmleuv/leuvCoord.Rdata")
leuvCoord <-getbb("Leuven Belgium")
xbounds = leuvCoord[1,1:2] + xoffset
ybounds = leuvCoord[2,1:2] + yoffset

print(xbounds)
print(ybounds)
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
hlStreetSize <- 1
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

makeFrame <- function(year,bis="",backgroundColor=apacheColors["brandLight"],titleText=""){
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
			  alpha = 1)
	  #ggtitle(titleText)+ /not used atm 

	if(year == "2020") {
		busLocs <- allStreets$osm_polygons [which (allStreets$osm_polygons$highway== "platform"), ]
		yearPlot <- yearPlot +	  
			   geom_sf(data = busLocs,
				  inherit.aes = FALSE,
				  fill = hlColor,
				  size = 0,
				  alpha = 1)
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

	ggsave(paste("/tmp/wmleuv/output/map",year,bis,".png",sep=""), plot=finPlot, width = 12, height=10.22)
}

makeFrame(years[1], backgroundColor="white")
makeFrame(years[2], backgroundColor="white")
makeFrame(years[3], backgroundColor="white")
makeFrame(years[3],
	  bis="bis",
	  backgroundColor=rgb(red = 1, green = 0, blue = 0, alpha = 0.3),
	  titleText = "Leuven, in het rode gebied zet de politie mobiele camera's in.")
