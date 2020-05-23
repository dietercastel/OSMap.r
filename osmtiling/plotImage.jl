using DataFrames
using CSV
using Plots
using Images

df = CSV.read("tilesLeuven.csv")


function plotMapImage(df,row)
	img1 = load(joinpath("be",df[row,:filename]))

	lenY, lenX = size(img1)

	minX = min(df[row,:botRightLong],df[row,:topLeftLong])
	maxX = max(df[row,:botRightLong],df[row,:topLeftLong])
	minY = min(df[row,:botRightLat],df[row,:topLeftLat])
	maxY = max(df[row,:botRightLat],df[row,:topLeftLat])

	rangeX = range(minX,stop=maxX,length=lenX)
	rangeY = range(minY,stop=maxY,length=lenY)
	p = plot!(rangeX,rangeY,reverse(img1,dims=1),yflip=false)
end

plotMapImage(df,1)
plotMapImage(df,2)
plotMapImage(df,3)
plotMapImage(df,4)

(r,c) = size(df)

p = scatter!(df[!,:topLeftLong],df[!,:topLeftLat],group = repeat(["topLeft"],r))
p = scatter!(df[!,:botRightLong],df[!,:botRightLat], group = repeat(["bottomRight"],r))

savefig(p,"plot.png")
