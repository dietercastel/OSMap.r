using DataFrames
using CSV
using Plots

println("lol")

df = CSV.read("tilesLeuven.csv")

p = scatter(df[!,:topLeftLat],df[!,:topLeftlong])
p = scatter!(df[!,:botRightLat],df[!,:botRightLong])
savefig(p,"plot.png")

