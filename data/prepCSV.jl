#!/usr/local/bin/julia
using CSV
using DataFrames

f = CSV.read(ARGS[1])
df = DataFrame(f)

outDf = filter(row->row[1]=="ANPR",df)

CSV.write(outDf, string("cleaned",ARGS[1]))
