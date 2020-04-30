using DataFrames
using CSV
using Plots

println("lol")

df = CSV.read("tilesLeuven.csv")

(r,c) = size(df)
p = scatter(df[!,:topLeftLat],df[!,:topLeftlong],group = repeat(["topLeft"],r))
p = scatter!(df[!,:botRightLat],df[!,:botRightLong], group = repeat(["bottomRight"],r))
savefig(p,"plot.png")

