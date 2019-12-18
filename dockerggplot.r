library(tidyverse)
library(osmdata)
load("/tmp/wmleuv/streets.Rdata")
leuvCoord <-getbb("Leuven Belgium")
print(leuvCoord)
#print(streets)

ggplot() +
  geom_sf(data = streets$osm_lines,
          inherit.aes = FALSE,
          color = "black",
          size = .4,
          alpha = .8) +
  coord_sf(xlim = c(7.77, 7.92), 
           ylim = c(47.94, 48.06),
           expand = FALSE) 

ggsave("/tmp/wmleuv/map.png", width = 6, height = 6)
