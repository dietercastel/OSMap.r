using DataFrames
using CSV

df = CSV.read("tilesLeuven.csv")

function dlTile((filename,zoom,xtile,ytile))
	fn = filename[1]
	z = zoom[1]
	x = xtile[1]
	y = ytile[1]
	baseUrl = "https://tile.openstreetmap.be/osmbe/$z/$x/$y.png"
	#println(baseUrl)
	run(`curl -v "$baseUrl" --output be/$fn`)
end

map((:filename,:zoom,:xtile,:ytile) => dlTile,groupby(df,:filename))

