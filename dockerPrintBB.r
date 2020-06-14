args = commandArgs(trailingOnly=TRUE)
print(args)

library(osmdata)
print(args[1])
bbox<-getbb(args[1])
bboxString<-paste(bbox[2,2],bbox[1,1],bbox[2,1],bbox[1,2])
runCommand<-paste("./osm_tile_downloaderBB.py",bboxString)
print(runCommand)

shebang <-"#!/usr/local/bin/python3"

fn <- paste("/tmp/wmleuv/osmtiling/tileDLBB-",args[1],".sh",sep="")
fileConn<-file(fn)
writeLines(c(shebang,runCommand),fileConn)
close(fileConn)
system(paste("chmod +x",fn))

print(paste("Executable file written:",fn))
