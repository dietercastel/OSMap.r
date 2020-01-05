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
load("/tmp/wmleuv/aStreetIds.Rdata") # aStreetIds



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

#print(streetsAllowed)

years <- c("2005","2013","2020")

makeFrame <- function(year){
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
			  alpha = 1)+
	  #geom_image(data=logo,
				 #aes(x,y,image),
				#inherit.aes = FALSE,
				#size = 0.04) +
	  ggtitle(paste("   Stratenplan Leuven met straten waar gefilmd mag worden (", year, ").",sep=""))+
	  coord_sf(xlim = xbounds, 
			   ylim = ybounds,
			   expand = FALSE)+
	  theme_void()+
	  theme(
		plot.background = element_rect(fill = apacheColors["brandLight"]),
		plot.title = element_text(size = 18, face = "bold"),
		plot.margin=unit(c(0,0,0,0), "mm")
	  ) + 
	  labs(x=NULL, y=NULL)

	ggsave(paste("/tmp/wmleuv/map",year,".png",sep=""), plot=yearPlot, width = 12, height=10.5)
}

#makeFrame(years[1])
makeFrame(years[2])
makeFrame(years[3])
