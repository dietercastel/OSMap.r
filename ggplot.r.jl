using RCall
# Install ggplot and osmdata with Rstudio using:
#
# install.packages("tidyverse")
# install.packages("osmdata")
#
#@rlibrary ggplot2
#@rlibrary osmdata


# Escape double quote for R string.

println(R"
library(tidyverse)
library(osmdata)
library(sf)
streets <- getbb(\"Leuven, Belgium\")%>%
	opq()%>%
	add_osm_feature(key = \"highway\", 
                  value = c(\"motorway\", \"primary\", 
                            \"secondary\", \"tertiary\")) %>%
	osmdata_sf()
streets

tst  <- streets$osm_lines

ggplot() + geom_sf(data = tst, inherit.aes = FALSE, color = \"black\", size = .4, alpha = .8) 

ggsave(\"map.png\", width = 6, height = 6)
")


"
ggplot() + geom_sf(data = tst,
          inherit.aes = FALSE,
          color = \"black\",
          size = .4,
          alpha = .8) +
  coord_sf(xlim = c(7.77, 7.92), 
           ylim = c(47.94, 48.06),
           expand = FALSE) 
"

# Mhhh
# Error in loadNamespace(name) : there is no package called ‘sf’

# https://ggplot2tutor.com/streetmaps/streetmaps/
