using DataFrames
using CSV

function tileNum2LatLong(zoom, xtile, ytile)
	n = 2^zoom
	longdeg = xtile/n * 360.0 - 180
	latrad = atan(sinh(pi * (1-2*ytile/n)))
	latdeg = latrad*180/pi
	return [latdeg,longdeg]
end

function br2LatLong(zoom, xtile, ytile)
	latlong = tileNum2LatLong(zoom,xtile+1,ytile+1)
	return [latlong[1],latlong[2]]
end

function getZXY(filename)
	parts = split(filename,"-")	
	zoom = parse(Int64,parts[1])
	x = parse(Int64,parts[2])
	y = parse(Int64,parts[3][1:end-4])
	return [zoom,x,y]
end


# Converts an array of arrays to a 2D matrix.
function matrixify(arrOfArr)
	#@time r1 = hvcat(length(arrOfArr[1]),arrOfArr...)
	#@time  Winner below
	return [ x[i] for x in arrOfArr, i in 1:length(arrOfArr[1])]
end

# Fetched images by exporting from openstreetmap website.
fns = readdir("images")

zxys = map(x->getZXY(x),fns)
zxyM = matrixify(zxys)

#Top left latitude and longitude
tlLatLong = matrixify(map(x->tileNum2LatLong(x...),zxys)) 
brLatLong = matrixify(map(x->br2LatLong(x...),zxys))

println(brLatLong)
df = DataFrame(filenames = fns,
			   zoom=zxyM[:,1],
			   xtile=zxyM[:,2],
			   ytile=zxyM[:,3],
			   topLeftLat = tlLatLong[:,1],
			   topLeftlong = tlLatLong[:,2],
			   botRightLat = brLatLong[:,1],
			   botRightLong = brLatLong[:,2])


CSV.write("tilesLeuven.csv",df)
