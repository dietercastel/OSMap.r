args = commandArgs(trailingOnly=TRUE)
print(args)

library(osmdata)
print(args[1])
bbox<-getbb(args[1])
print(paste("./osm_tile_downloaderBB.py",bbox[2,2],bbox[1,1],bbox[2,1],bbox[1,2]))
