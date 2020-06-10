library(purrr) # required for map
# Pseudo code from https://wiki.openstreetmap.org/wiki/Slippy_map_tilenames#Pseudo-code
# n = 2 ^ zoom
# lon_deg = xtile / n * 360.0 - 180.0
# lat_rad = arctan(sinh(π * (1 - 2 * ytile / n)))
# lat_deg = lat_rad * 180.0 / π

num2deg <- function(zoom,xtile,ytile){
	n <- 2^zoom
	lon_deg <- xtile/n*360.0 - 180.0
	lat_rad <- atan(sinh(pi*(1-2*ytile/n)))
	lat_deg <- lat_rad *180.0 / pi
	return(list(lat_deg,lon_deg))
}

# Quick Test

makeTest <- function(zoom, xtile, ytile, topLeftLat, topLeftLong, botRightLat, botRightLong, ...){
	mycalc = num2deg(zoom,xtile,ytile)
	print(mycalc)
	print(paste("ORIGINAL",topLeftLat,topLeftLong,sep=" ,"))
	print(paste("ORIGINAL BR",botRightLat,botRightLong,sep=" ,"))
	return(topLeftLat == mycalc[1] && topLeftLong == mycalc[2])
	# xmx = max(topLeftLong, botRightLong)
	# xmn = min(topLeftLong, botRightLong)
	# ymx = max(topLeftLat, botRightLat)
	# ymn = min(topLeftLat, botRightLat)
	# #list(topLeftLat, topLeftLong, botRightLat, botRightLong,path)
	# #list(xmx,xmn,ymx,ymn,path)
	# return(annotation_raster(tile, ymin=ymn, ymax=ymx, xmin=xmn, xmax=xmx))
}

tileFrame <- read.csv('/tmp/wmleuv/osmtiling/tilesLeuven.csv')
alltests <- pmap(tileFrame,makeTest)
print(alltests)
