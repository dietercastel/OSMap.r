using DataFrames
using CSV
using Plots
using Images

df = CSV.read("tilesLeuven.csv")

size(df)

#scatter([4.69],[50.9],size=(1799, 1280))
function plotMapImage(row)
	img1 = load(joinpath("be",row[:filename]))

	lenY, lenX = size(img1)

	minX = min(row[:botRightLong],row[:topLeftLong])
	maxX = max(row[:botRightLong],row[:topLeftLong])
	minY = min(row[:botRightLat],row[:topLeftLat])
	maxY = max(row[:botRightLat],row[:topLeftLat])

	rangeX = range(minX,stop=maxX,length=lenX)
	rangeY = range(minY,stop=maxY,length=lenY)
	p = plot!(rangeX,rangeY,reverse(img1,dims=1),yflip=false,dpi=1200)
	#p = plot!(rangeX,rangeY,reverse(img1,dims=1),yflip=false)
end

plotMapImage.(eachrow(df))

(r,c) = size(df)

p = scatter!(df[!,:topLeftLong],df[!,:topLeftLat],group = repeat(["topLeft"],r))
p = scatter!(df[!,:botRightLong],df[!,:botRightLat], group = repeat(["bottomRight"],r))

savefig(p,"plot.png")
