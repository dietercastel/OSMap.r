library(tidyverse)
library(osmdata)
available_tags("highway")
leuvCoord<-getbb("Leuven Belgium")
print(leuvCoord)


#streets <- getbb("Leuven Belgium")%>%
#  opq()%>%
#  add_osm_feature(key = "highway", 
#                  value = c("motorway", "primary", 
#                            "secondary", "tertiary")) %>%
#  osmdata_sf()
#streets
#
## Save it to file 
#save(streets, file= "/Users/dietercastel/git/wmleuv/streets.Rdata")
