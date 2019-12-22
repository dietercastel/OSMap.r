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


# smallStreets <- getbb("Leuven Belgium")%>%
#   opq()%>%
#   add_osm_feature(key = "highway", 
#                   value = c("residential", "living_street",
#                             "unclassified",
#                             "service", "footway")) %>%
#   osmdata_sf()
# save(smallStreets, file= "/Users/dietercastel/git/wmleuv/smallstreets.Rdata")

allStreets <- getbb("Leuven Belgium")%>%
  opq()%>%
  add_osm_feature(key = "highway")%>%
  osmdata_sf()
save(allStreets, file= "/Users/dietercastel/git/wmleuv/allstreets.Rdata")



# dijle <- getbb("Leuven Belgium")%>%
#      opq()%>%
#      add_osm_feature(key = "waterway", value = "river") %>%
#      osmdata_sf()
#
# save(dijle, file="/Users/dietercastel/git/wmleuv/dijle.Rdata")


# hhstr <- getbb("Hoegaardsestraat Leuven Belgium")%>%
# 	   opq() %>%
# 	   add_osm_feature(key = "highway", 
# 					   value= c("motorway","trunk","primary","secondary",
# 								"tertiary","unclassified","residential"))%>%
# 	   osmdata_sf()
#
# save(hhstr, file="/Users/dietercastel/git/wmleuv/hhstr.Rdata")
